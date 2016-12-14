//
// = FILENAME
//    SingleCircleWorld.hh
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#ifndef SingleCircleWorld_hh
#define SingleCircleWorld_hh

#include "World.hh"

/**
 * The base class for represents the world
 */
class SingleCircleWorld : public World {
public:

  /**
   * Constructs an empty world
   */
  SingleCircleWorld();

  /**
   * Destructor deletes all geometric objects in the world
   */
  ~SingleCircleWorld();

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

protected:

  /// The center coordinate of the circle
  double m_Xc, m_Yc;
  
  /// The radius of the circle
  double m_Radius;
};

#endif // SingleCircleWorld_hh
