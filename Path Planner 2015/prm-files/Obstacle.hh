//
// = FILENAME
//    Obstacle.hh
//
// = AUTHOR(S)
//    Martin Isaksson
//
/*----------------------------------------------------------------------*/

#ifndef Obstacle_hh
#define Obstacle_hh

#include <iostream>
// Make this a Base class
class Obstacle {
public:

  Obstacle();

  virtual ~Obstacle();
  
  /**
   * Use this function to check if a certain point collides with any
   * of the obstales in the world
   * 
   * @param x x-coordinate of point to check for collision
   * @param y y-coordinate of point to check for collision
   * @return true if point (x,y) collides with any of the obstacles
   */

  virtual bool collidesWith(double x, double y) = 0;
  
  // So we use same function in Circle and Rectangle
  virtual void writeMatlabDisplayCode(std::ostream &fs) = 0;

};

#endif // Obstacle_hh
