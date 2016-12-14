//
// = FILENAME
//    SingleCircleWorld.cc
//    
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#include "SingleCircleWorld.hh"

#include <iostream>
#include <cmath>

SingleCircleWorld::SingleCircleWorld()
{
  m_Xc = 5;
  m_Yc = 5;
  m_Radius = 4;
}

SingleCircleWorld::~SingleCircleWorld()
{}

bool 
SingleCircleWorld::collidesWith(double x, double y)
{
  double dx = x - m_Xc;
  double dy = y - m_Yc;
  
  return (sqrt(dx*dx+dy*dy) <= m_Radius);
}

void 
SingleCircleWorld::writeMatlabDisplayCode(std::ostream &fs)
{
  fs << "plot(" 
     << m_Xc << " + " << m_Radius << "*cos((0:5:360)/180*pi),"
     << m_Yc << " + " << m_Radius << "*sin((0:5:360)/180*pi))"
     << std::endl;
}
