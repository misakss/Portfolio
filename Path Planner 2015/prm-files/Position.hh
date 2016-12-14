//
// = FILENAME
//    Position.hh
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#ifndef Position_hh
#define Position_hh

/**
 * This class encapsulates position data
 */
class Position {
public:
  /// Empty constructor
  Position();

  /// Constructor that allows you to set the position (x,y)
  Position(double x, double y);

  /// Function used to copy an object
  Position(const Position &src);

  /// Function used to copy an object
  void operator=(const Position &src);

  /// Function to set the x-coordinate of the position
  void setX(double x);

  /// Function to get the x-coordinate of the position
  double getX() const;

  /// Function to set the y-coordinate of the position
  void setY(double y);

  /// Function to get the y-coordinate of the position
  double getY() const;
protected:
  double m_X;
  double m_Y;
};

inline void Position::setX(double x) { m_X = x; }
inline double Position::getX() const { return m_X; }
inline void Position::setY(double y) { m_Y = y; }
inline double Position::getY() const { return m_Y; }

#endif // Position_hh
