//
// = FILENAME
//    PRM.cc
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#include "PRM.hh"

#include <cstdlib>
#include <iostream>
#include <cfloat>

PRM::PRM()
{
  // Make sure that the random generator has been initialize
  srand(time(0));
}

PRM::~PRM()
{
  
}

int 
PRM::buildRoadMap(World &world, 
                  double xMin, double xMax,
                  double yMin, double yMax,                   
                  int nNodes, int K, double step)
{
  // Store step size so that the same value can be used in findPath
  m_Step = step;

  clearNodes();

  // Clear the vector with edges (used for debug display stuff)
  m_Edges.clear();

  // Create new set of n nodes with random positions. Each new node is
  // first checked for collisions before being added
  int n = 0;
  while (m_Nodes.size() < nNodes) {

    PRMNode *node = generateNodeWithRandomPosition(xMin, xMax, yMin, yMax);

    // Check if we can add it, is it does not collide with anything
    if (world.collidesWith(node->getX(), node->getY())) {

      // Delete the newly created node to avoid memory leaks
      delete node;

      // Go back up and create a new one
      continue;
    }

    // Try to connect this node to existing nodes in the neighborhod
    // of this node
    
    // Get list of distances to other nodes
    std::list< std::pair<double, int> > distances;
    getNodeDistances(node, distances);
    
    int k = 0;
    for (std::list< std::pair<double, int> >::iterator iter = distances.begin();
         iter != distances.end(); iter++) {

      // Skip the nodes if it is the same as we try to connect to
      if (iter->second == n) {
        continue;
      }

      // Check if the path between the nodes is free from collisions
      if (isCollisionFreePath(world,
                              node->getX(), 
                              node->getY(),
                              m_Nodes[iter->second]->getX(), 
                              m_Nodes[iter->second]->getY(),
                              step)) {

        m_Nodes[iter->second]->addNewEdge(node);
        node->addNewEdge(m_Nodes[iter->second]);
        m_Edges.push_back( std::make_pair(n, iter->second) );        
      }
      
      // If we have tested enough of the neighbors we break here
      k++;
      if (k >= K) break;
    } 

    m_Nodes.push_back(node);
    n++;
  }
}

void
PRM::clearNodes()
{
  // Clear nodes
  for (unsigned int i = 0; i < m_Nodes.size(); i++) 
    delete m_Nodes[i];
  m_Nodes.clear();
}

void
PRM::getNodeDistances(PRMNode *n, 
                      std::list< std::pair<double, int> > &distances)
{
  for (unsigned int i = 0; i < m_Nodes.size(); i++) {

    double d = sqrt( (m_Nodes[i]->getX() - n->getX()) *
                     (m_Nodes[i]->getX() - n->getX()) +
                     (m_Nodes[i]->getY() - n->getY()) *
                     (m_Nodes[i]->getY() - n->getY()) );

    distances.push_back( std::make_pair(d, i) );
  }

  // Sort the list with distances so that the closest one comes first
  distances.sort();
}

bool
PRM::isCollisionFreePath(World &world, 
                         double xS, double yS, double xE, double yE,
                         double step)
{
  double dx = xE - xS;
  double dy = yE - yS;

  // The angle of the line
  double ang = atan2(dy, dx);

  // The length of the line
  double len = sqrt(dx*dx + dy*dy);

  // The direction cosines
  double kx = cos(ang);
  double ky = sin(ang);

  bool last = false;
  bool done = false;
  double pos = 0; // where on the line are we
  while (!done) {

    double x = xS + pos * kx;
    double y = yS + pos * ky;
    
    if (world.collidesWith(x,y)) return false;
 
    if (!last && pos > len) {
      last = true;
      pos = len;
    } else if (last) {
      done = true; 
    }

    pos += step;
  }

  return true;
}

int
PRM::findClosestNodeOnGraph(World &world, double x, double y)
{
  double minD = DBL_MAX;
  int minI = -1;
  for (unsigned int i = 0; i < m_Nodes.size(); i++) {
    double dx = x - m_Nodes[i]->getX();
    double dy = y - m_Nodes[i]->getY();
    double d = sqrt(dx*dx+dy*dy);
    if (d < minD &&
        isCollisionFreePath(world,
                            m_Nodes[i]->getX(), m_Nodes[i]->getY(), x, y, 
                            m_Step)) {
      minD = d;
      minI = i;
    }
  }
 
  return minI;
}

bool 
PRM::findPath(World &world,
              double xStart, double yStart,
              double xGoal, double yGoal,
              std::list<Position> &path)
{
  path.clear();

  // Find the node in the graf that is closest to the start and goal
  // point and offer a collision free path from these points to the
  // road map.

  int start = findClosestNodeOnGraph(world, xStart, yStart);
  int goal = findClosestNodeOnGraph(world, xGoal, yGoal);

  if (start < 0) {
    std::cerr << "Could not connect the start point ("
              << xStart << ", " << yStart << " ) "
              << "to the road map. You should think about rebuilding it\n";
    return false;
  }
  if (start < 0) {
    std::cerr << "Could not connect the goal point ("
              << xGoal << ", " << yGoal << ") "
              << "to the road map. You should think about rebuilding it\n";
    return false;
  }

  double pathLen = 0;
  if (m_Nodes[goal]->findPath(m_Nodes[start], pathLen)) {

    path.push_back(Position(xStart, yStart));

    PRMNode *n = m_Nodes[start];

    while (n) {

      path.push_back( Position( ((PRMNode*)n)->getX(), 
                                ((PRMNode*)n)->getY() ) );

      n = (PRMNode*)n->parent;
    }

    path.push_back(Position(xGoal, yGoal));

    return true;
  }

  return false;  
}

PRMNode* 
PRM::generateNodeWithRandomPosition(double xMin, double xMax,
                                    double yMin, double yMax)
{
  PRMNode* n = new PRMNode();

  n->setX(xMin + ((xMax - xMin) * (rand() / (RAND_MAX + 1.0))));
  n->setY(yMin + ((yMax - yMin) * (rand() / (RAND_MAX + 1.0))));

  return n;
}

void 
PRM::writeMatlabDisplayCode(std::ostream &s, bool dispEdges, bool dispNodes)
{
  if (dispNodes) {
    for (unsigned int i = 0; i < m_Nodes.size(); i++) {
      s << "plot(" 
        << m_Nodes[i]->getX() << "," 
        << m_Nodes[i]->getY() << ",\'.g\')\n";
    }
  }

  // We always write the code for displaying the edges but in case we
  // are ordered not to displayit we add a "if 0 ... end" around it
  // that can be removed manually
  s << "if " << (int)dispEdges << std::endl;
  for (std::vector< std::pair<int, int> >::iterator i = m_Edges.begin();
       i != m_Edges.end(); i++) {
    s << "  plot([" 
      << m_Nodes[i->first]->getX() << "," 
      << m_Nodes[i->second]->getX() << "] ,[" 
      << m_Nodes[i->first]->getY() << ", "
      << m_Nodes[i->second]->getY() << "], \'k\')\n";
  }
  s << "end" << std::endl;
}
