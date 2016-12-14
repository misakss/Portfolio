//
// = FILENAME
//    MyWorld.hh
//
// = AUTHOR(S)
//    Martin Isaksson
//
/*----------------------------------------------------------------------*/

#ifndef MyWorld_hh
#define MyWorld_hh

#include <list> 
#include "World.hh"
#include "Obstacle.hh"
#include "Circle.hh"
#include "Rectangle.hh"


// This is a sub-class of World that aggregates obstacles 
 
class MyWorld : public World {
public:

 
  MyWorld();
  std::list<Obstacle*> obstacles;

  ~MyWorld();
  
    /**
   * Use this function to read the obstacles from a file.
   * The format of this file is assumed to be 
   * TYPE par1 par2 par3
   * TYPE par1 par2
   * where TYPE tell what type of obstacle/object it is and the parameters 
   * give the properties of that obstacle/object
   *
   * The default implementation of this function is to do nothing
   *
   * @param fs input stream to read objects from
   * @return true if the file as read successfully, false in case of errors
   */
  bool readObstacles(std::istream &fs);


  /**
   * Use this function to check if a certain point collides with any
   * of the obstales in the world
   * 
   * @param x x-coordinate of point to check for collision
   * @param y y-coordinate of point to check for collision
   * @return true if point (x,y) collides with any of the obstacles
   */
  bool collidesWith(double x, double y);

  /**
   * This function will go through all the obstacles in the world and
   * ask for them to to write matlab display code to the stream.
   *
   * @param fs reference to and output stream, for example an fstream (file)
   * @return N/A
   */
  void writeMatlabDisplayCode(std::ostream &fs);
};

#endif // MyWorld_hh
