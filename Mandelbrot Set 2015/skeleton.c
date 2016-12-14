#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <unistd.h>
#include "SDL.h"
#include <time.h>

SDL_Surface *screen;
int sizeX; //= 1024;
int sizeY; //= 576;

///////////////////Declare functions/////////////////////////////

void putpixel(int x, int y, int color);

double *zoom(double cx_max,double cy_max,double cx_min,double cy_min);

void Mandelbrot(double cx_max,double cy_max,double cx_min,double cy_min);

///////////////////Run program in main///////////////////////////

int main()
{
  double cx_min = -2.5;
  double cx_max = 1;
  double cy_min = -1;
  double cy_max = 1;
  int PicOrZoom,SizeOrDefault;
  //sizeX = 1024;
  //sizeY = 576;
  printf("\n**********************************************\nWELCOME TO THE PROGRAM MANDELBROT SET \n**********************************************\n\nIf you want to enter the size of the picture press 0, if you want to use deafault settings press 1 : ");
  scanf("%d",&SizeOrDefault);
  if (SizeOrDefault!=0 || SizeOrDefault!=1)
    {
      printf("\nError: You didn't press 0 or 1, program will quit \n\n");
    }
  if (SizeOrDefault==0)
    {
      printf("\n--------------------------------------------------\nYou have chosen to enter the size of the picture.\n \nEnter the width of the picture: \n");
      scanf("%d",&sizeX);
      printf("\nEnter the height of the picture: \n");
      scanf("%d",&sizeY);
      //If I choose sizeX=sizeY picture should still look the same but smaller
      cy_max=0.75*(cy_min+(cx_max-cx_min)*(sizeY/sizeX)); //Scale it right, 0.75 looks better than 1
      cy_min=(-1)*cy_max; //Put the smaller picture in the center
    }
  else if (SizeOrDefault==1)
    {
      printf("\nYou have chosen the default setting of the size of the picture\n");
      sizeX=1024;
      sizeY=576;
    }
  if (SizeOrDefault==0 || SizeOrDefault==1)
    {
  printf("\nIf you just want to see the Mandelbrot set press 0, if you also would like to zoom into the set press 1 [Exit program by pressing ESC] : \n");
  scanf("%d",&PicOrZoom);
    
	// Initialize SDL's subsystems - in this case, only video.
  if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) 
  {
    fprintf(stderr, "Unable to init SDL: %s\n", SDL_GetError());
    exit(1);
  }

  // Register SDL_Quit to be called at exit; makes sure things are
  // cleaned up when we quit.
  atexit(SDL_Quit);
    
  // Attempt to create a 640x480 window with 32bit pixels.
  screen = SDL_SetVideoMode(sizeX, sizeY, 32, SDL_SWSURFACE);
  
  // If we fail, return error.
  if ( screen == NULL ) 
  {
    fprintf(stderr, "Unable to set 640x480 video: %s\n", SDL_GetError());
    exit(1);
  }
    
     while (1) //loop forever 
    {
    // Render stuff
      
      switch (PicOrZoom)
	{
	case 0:
	  render(cx_max,cy_max,cx_min,cy_min);
	  break;
	case 1:
	  render(cx_max,cy_max,cx_min,cy_min);
	  double *a=zoom(cx_max,cy_max,cx_min,cy_min);
	  cx_max=a[0];
	  cy_max=a[1];
	  cx_min=a[2];
	  cy_min=a[3];
	  break;
	}
    // Check for events.
    SDL_Event event;
    while (SDL_PollEvent(&event)) 
    {
      switch (event.type) 
      {
      case SDL_KEYDOWN:
        break;
      case SDL_KEYUP:
        // If escape is pressed, return (and thus, quit)
        if (event.key.keysym.sym == SDLK_ESCAPE)
          return 0;
        break;
      case SDL_QUIT:
        return(0);
      }
    }
  }
  }
    return 0;
}

///////////////////Create functions that is needed///////////////

void render(double cx_max,double cy_max,double cx_min,double cy_min)
{   
  // Lock surface if needed
  if (SDL_MUSTLOCK(screen)) 
    if (SDL_LockSurface(screen) < 0) 
      return;
  
  /*  int x,y;
  //just set some pixels to red, white, green and blue:
  x=30; y=40; putpixel(x, y, 0xFF0000);
  x=35; y=40; putpixel(x, y, 0xFFFFFF);
  x=35; y=45; putpixel(x, y, 0x00FF00);
  x=40; y=45; putpixel(x, y, 0x00FF00);
  x=45; y=50; putpixel(x, y, 0x000000);
  x=50; y=55; putpixel(x, y, 0x0000FF);
  */

  Mandelbrot(cx_max,cy_max,cx_min,cy_min);
  
  // Unlock if needed
  if (SDL_MUSTLOCK(screen)) 
      SDL_UnlockSurface(screen);

  // update the whole screen
  SDL_UpdateRect(screen, 0, 0, sizeX, sizeY);    
  
}

/*Generate the Mandelbrot set*/

unsigned long createRGB(int r, int g, int b)
{   
  return ((r & 0xff) << 16) + ((g & 0xff) << 8) + (b & 0xff);
}

void Mandelbrot(double cx_max,double cy_max,double cx_min,double cy_min)
{
  /*
     Z_n = zx + i*zy
     Z_(n+1) = Z_n^2 + C
     Z0 = 0 => zx = 0 , zy = 0 => Z_(1) = C
     C = cx +i*cy
     Z_(n+1) = (zx + i*zy)^2 + cx + i*cy = zx^2 + i*2*zx*zy - zy^2 + cx + i*cy =
             = zx^2 - zy^2 +cx + i*(2*zx*zy + cy)
     Re{Z_(n+1)} = zx^2 - zy^2 + cx
     Im{Z_(n+1)} = 2*zx*zy + cy

     Interpolate the picture between the edges to get the C-values.
     cx_max = 1 , cx_min = -2.5 , cy_max = 1 , cy_min = -1
     By google-ing I can use the values above.
     I want to interpolate continiously with constant steps over the picture.
     To do that I need the size of a pixel.
     That is pixelwidth=(cx_max-cx_min)/sizeX and pixelhight=(cy_max-cy_min)/sizeY.
     Loop over all X and all Y in the picture and generate cx=cx_min+X*pixelwidth and
     cy=cy_min+Y*pixelhight by interpolation
 */
  clock_t start = clock();
  int X,Y,iteration,r,g,b,hex;
  int maxIteration=400;
  double zx2,zy2,ZX,ZY,Z_old,Z_old2,Z_old3,Z_old4,Z_old5,Z,cx,cy,zx,zy,dist2,i,pixelheight,pixelwidth;
  pixelwidth = (cx_max-cx_min)/(sizeX-1);
  pixelheight = (cy_max-cy_min)/(sizeY-1);
  for (Y=0;Y<sizeY;Y++)
    {
      cy = cy_min + Y*pixelheight;
      for (X=0;X<sizeX;X++)
	{
	  cx = cx_min + X*pixelwidth;
	  zx = 0; //Z0=0
	  zy = 0; //Z0=0
	  ZX = 0;
	  ZY = 0;
	  Z_old=0;
	  Z_old2=0;
	  Z_old3=0;
	  Z_old4=0;
	  Z_old5=0;
	  Z=0;
	  zx2=0;
	  zy2=0;
	  dist2=0;
	  for (iteration=0;iteration<maxIteration;iteration++)
	    {
	      ZX = zx2 - zy2 + cx;
	      ZY = 2*zx*zy + cy;
	      zx=ZX;
	      zy=ZY;
	      dist2=zx2+zy2;
	      zx2=zx*zx;
	      zy2=zy*zy; 
	      Z=ZX+ZY;
	      
	      //Speed up the process by stop calculating if dist2>4
	      if (dist2>4.0)
		{
		  i = (iteration*255/maxIteration);
		  r = round(sin(0.024*i + 0) * 127 + 128);
		  g = round(sin(0.024*i + 2) * 127 + 128);
		  b = round(sin(0.024*i + 4) * 127 + 128);
		  hex=createRGB(r,g,b);
		  putpixel(X, Y, hex);
		  break;
		  //make color
		}
	      /*
		Speed up the process by stop calculating the set if the same value 
		appears again in the set, because that means it should be painted black 
	      */
	      else if (Z==Z_old || Z==Z_old2 || Z==Z_old3 || Z==Z_old4 || Z==Z_old5)
		{
		  putpixel(X, Y, 0x000000);
		  break;
		}
	      else
		{
		  //make it black	      
		  putpixel(X, Y, 0x000000);

		}
	      Z_old5=Z_old4;
	      Z_old4=Z_old3;
	      Z_old3=Z_old2;
	      Z_old2=Z_old;
	      Z_old=Z;
	    }
	}
    }
  clock_t end = clock();
  double elapsed_time = (end - start)/(double)CLOCKS_PER_SEC;
  //printf("Elapsed time: %.2f.\n", elapsed_time);
}

double *zoom(double cx_max,double cy_max,double cx_min,double cy_min)
{
  //I have chosen to zoom into the point (-0.04524074130409,0.9868162207157852) in [c]
  cx_max=-0.04524074130409+(cx_max-cx_min)*0.25; 
  cx_min=-0.04524074130409-(cx_max-cx_min)*0.25;
  cy_max=0.9868162207157852+(cy_max-cy_min)*0.25;
  cy_min=0.9868162207157852-(cy_max-cy_min)*0.25;
  double a[]={cx_max,cy_max,cx_min,cy_min};
  return a;
}

void putpixel(int x, int y, int color)
{
  unsigned int *ptr = (unsigned int*)screen->pixels;
  int lineoffset = y * (screen->pitch / 4);
  ptr[lineoffset + x] = color;
}


