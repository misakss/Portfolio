//
// = FILENAME
//    Rectangle.hh
//
// = AUTHOR(S)
//    Martin Isaksson
//
/*----------------------------------------------------------------------*/

#ifndef Rectangle_hh
#define Rectangle_hh

#include "Obstacle.hh"
#include "World.hh"
#include "MyWorld.hh"
#include <iostream>

// Sub-class for Obstacle
class Rectangle : public Obstacle {
public:

  Rectangle(double m_Xr,double m_Yr,double m_Width,double m_Height,double m_Angle);
  double xr,yr,w,h,a,x1,x2,x4,y1,y2,y4,y3,x3,a1,a2,a3,a4,b1,b2,b3,b4,u1,u2,u3,u4,A,A1,A2,A3,A4;

  ~Rectangle();

  bool collidesWith(double x,double y);

  void writeMatlabDisplayCode(std::ostream &fs);
};

#endif // Rectangle_hh
