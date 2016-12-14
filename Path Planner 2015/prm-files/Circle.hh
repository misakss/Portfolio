//
// = FILENAME
//    Circle.hh
//
// = AUTHOR(S)
//    Martin Isaksson
//
/*----------------------------------------------------------------------*/

#ifndef Circle_hh
#define Circle_hh

#include "Obstacle.hh"
#include "World.hh"
#include "MyWorld.hh"
#include <iostream>

// Sub-class for Obstacle
class Circle : public Obstacle {
public:

  Circle(double m_Xc,double m_Yc, double m_Radius);

  double xc,yc,r;

  ~Circle();

  bool collidesWith(double x,double y);
 
  void writeMatlabDisplayCode(std::ostream &fs);
};

#endif // Circle_hh
