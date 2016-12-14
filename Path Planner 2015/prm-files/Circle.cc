//
// = FILENAME
//    Circle.cc
//    
// = AUTHOR(S)
//    Martin Isaksson
//
/*----------------------------------------------------------------------*/

#include "Circle.hh"

#include <iostream>
#include <cmath>

Circle::Circle(double m_Xc,double m_Yc,double m_Radius)
{
  // Use the inputs that we get from MyWorld, readObstacle
  xc=m_Xc;
  yc=m_Yc;
  r=m_Radius;
}

Circle::~Circle()
{}

bool
Circle::collidesWith(double x,double y)
{
  double dx = x - xc;
  double dy = y - yc;
  
  return (sqrt(dx*dx+dy*dy) <= r);
}

void 
Circle::writeMatlabDisplayCode(std::ostream &fs)
{
  fs << "plot(" 
     << xc << " + " << r << "*cos((0:5:360)/180*pi),"
     << yc << " + " << r << "*sin((0:5:360)/180*pi))"
     << std::endl;
}
