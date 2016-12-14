//
// = FILENAME
//    World.hh
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#ifndef World_hh
#define World_hh

#include <vector>
#include <iostream>

/**
 * The base class for representing the world
 */
class World {
public:

  /**
   * Constructor
   */
  World();

  /**
   * Destructor 
   */
  virtual ~World();

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
  virtual bool readObstacles(std::istream &fs);

  /**
   * Use this function to check if a certain point collides with any
   * of the obstales in the world
   *
   * NOTE that this function MUST be overloaded
   * 
   * @param x x-coordinate of point to check for collision
   * @param y y-coordinate of point to check for collision
   * @return true if point (x,y) collides with any of the obstacles
   */
  virtual bool collidesWith(double x, double y) = 0;

  /**
   * This function will go through all the obstacles in the world and
   * ask for them to to write matlab display code to the stream.
   *
   * The default implementation of the function is to do nothing
   *
   * @param fs reference to and output stream, for example an fstream (file)
   * @return N/A
   */
  virtual void writeMatlabDisplayCode(std::ostream &fs);
};

#endif // World_hh
