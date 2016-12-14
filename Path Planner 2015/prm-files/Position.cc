//
// = FILENAME
//    Position.cc
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#include "Position.hh"

Position::Position()
  :m_X(0), 
   m_Y(0) 
{}

Position::Position(double x, double y)
  :m_X(x), 
   m_Y(y) 
{}

/// Function used to copy an object
Position::Position(const Position &src)
{
  // No need to copy if we are trying to copy ourselves
  if (&src != this)
    *this = src;
}

/// Function used to copy an object
void 
Position::operator=(const Position &src)
{
  m_X = src.getX();
  m_Y = src.getY();
}

