//
// = FILENAME
//    MyWorld.cc
//    
// = AUTHOR(S)
//    Martin Isaksson
//
/*----------------------------------------------------------------------*/

#include "MyWorld.hh"
#include "Obstacle.hh"
#include "Rectangle.hh"
#include "Circle.hh"
#include "World.hh"

#include <iostream>
#include <cmath>
#include <list>
#include <sstream>
#include <fstream>
#include <string>
using namespace std;

MyWorld::MyWorld()
{
}

MyWorld::~MyWorld()
{
  list<Obstacle*>::iterator iter=obstacles.begin();
  for (iter;iter!=obstacles.end();iter++) delete (*iter);
}

bool
MyWorld::readObstacles(std::istream &fs)
{
  string type;
  double m_Xc,m_Yc,m_Radius,m_Xr,m_Yr,m_Width,m_Height,m_Angle;
  while (fs>>type)
    {
      if (type=="CIRCLE")
	{
	  fs >> m_Xc; fs >> m_Yc; fs >> m_Radius;
	  Obstacle *obstacle=new Circle(m_Xc,m_Yc,m_Radius);
	  obstacles.push_back(obstacle);
	}
      else if (type=="RECTANGLE")
	{
	  fs >> m_Xr; fs >> m_Yr; fs >> m_Width; fs >> m_Height; fs >> m_Angle;
	  Obstacle *obstacle=new Rectangle(m_Xr,m_Yr,m_Width,m_Height,m_Angle);
	  obstacles.push_back(obstacle);
	}
      // else false;
    }  
  return true;
  /* Read text-file and put every obstacle (depending on which TYPE put
     the coordinates in a list)
     in the list obstacles. Also make sure that this function
     returns true if the file reads successfully and
     false otherwise. 
  */
}

bool
MyWorld::collidesWith(double x,double y)
{
  list<Obstacle*>::iterator iter=obstacles.begin();
 for(iter; iter!=obstacles.end();iter++)
   {
    if((*iter)->collidesWith(x,y))
      {
	return true;
      }
   }
 return false;
}

void 
MyWorld::writeMatlabDisplayCode(std::ostream &fs)
{
  list<Obstacle*>::iterator iter=obstacles.begin();
  for(iter; iter!=obstacles.end();iter++)
  (*iter)->writeMatlabDisplayCode(fs);
}
