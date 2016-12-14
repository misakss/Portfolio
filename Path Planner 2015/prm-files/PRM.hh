//
// = FILENAME
//    PRM.hh
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#ifndef PRM_hh
#define PRM_hh

#include "World.hh"
#include "PRMNode.hh"

#include <vector>
#include <list>

/**
 * This class implements a basic version of the probabilistic road map
 * (PRM) method for path planning.
 */
class PRM {
public:

  /**
   * Constructor
   */
  PRM();

  /**
   * Destructor
   */
  ~PRM();

  /**
   * Call this function to build up the road map that allows you to
   * plan paths through the given world. 
   *
   * @param world reference to the world holding the obstacles
   * @param xMin min value for x-coordinate to generate nodes for 
   * @param xMax max value for x-coordinate to generate nodes for 
   * @param yMin min value for y-coordinate to generate nodes for 
   * @param yMax max value for y-coordinate to generate nodes for 
   * @param nNodes number of nodes to use for the road map
   * @param K number of nearest nodes to try to connect a new node to
   * @param step step size when shecking for collisions along edges 
   *
   * Note1: This is a probabilistic method and the particular road map
   * generated with this call might not provide a solution for a given
   * problem so you might have to generate a new one in some cases.
   *
   * Note2: If the world changes you need to update the road-map. The
   * brute force way to do so is to call this function again and
   * generate a new road map from scratch.
   */
  int buildRoadMap(World &world, 
                   double xMin, double xMax,
                   double yMin, double yMax,                   
                   int nNodes, int K, double step);

  /**
   * Calculates the path from a start to an end position. It is assume
   * that you have already called buildRoadMap. The world passed as an
   * argument to this function is only used to make sure that the
   * specified start and goal positions can be connected correctly to
   * the road map.
   *
   * @param world reference to the world holding the obstacles
   * @param xStart x-coordinate for the start position
   * @param yStart y-coordinate for the start position
   * @param xEnd x-coordinate for the end position
   * @param yEnd y-coordinate for the end position
   * @param path reference to the list that will contain the
   * resulting path (if found)
   * @return true if path was found, else false
   * 
   * @see buildRoadMap
   */
  bool findPath(World &world,                
                double xStart, double yStart,
                double xGoal, double yGoal,
                std::list<Position> &path);

  /**
   * Use this function to generate matlab code to display the nodes and edges.
   * 
   * @param s reference to stream to output matlab code to
   * @param dispEdges flag telling if we should generate display code for edges
   * @param dispNodes flag telling if we should generate display code for nodes
   * @return N/A
   */
  void writeMatlabDisplayCode(std::ostream &s,
                              bool dispEdges = true,
                              bool dispNodes = true);

protected:

  /**
   * This function creates a new node with random position
   * 
   * @param xMin min value for x-coordinate to generate nodes for 
   * @param xMax max value for x-coordinate to generate nodes for 
   * @param yMin min value for y-coordinate to generate nodes for 
   * @param yMax max value for y-coordinate to generate nodes for 
   * @return pointer to new node
   */
  PRMNode* generateNodeWithRandomPosition(double xMin, double xMax,
                                          double yMin, double yMax);

  /**
   * Use this function to find the node on the graph closest
   * (collision free straight line) to a certain point (x,y).
   *
   * @param world reference to the world holding the obstacles
   * @param x x-coordinate of the point to connect to graph
   * @param y y-coordinate of the point to connect to graph
   * @return index of closest node if found, -1 if not
   */
  int findClosestNodeOnGraph(World &world, double x, double y);

  /**
   * Use this function to check if a line (xS,yS)->(xE,yE) collides
   * with any of the obstacles in the world. It does this by sampling
   * the line with a certain step size specified as argument to the function.
   * 
   * @param world a reference to the world model
   * @param xS x-coordinate of the start point for the edge
   * @param yS y-coordinate of the start point for the edge
   * @param xE x-coordinate of the end point for the edge
   * @param yE y-coordinate of the end point for the edge
   * @param step the step size to use when checking for collisions
   * @return true if the line (xS,yS)->(xE,xE) does not collide with any of the obstacles
   */
  bool isCollisionFreePath(World &world,
                           double xS, double yS, double xE, double yE,
                           double step);

  /**
   * This function builds a structure with the distances to all the
   * other nodes. It can be used to try to connect nodes with edges.
   * 
   * The list will contain pairs of node index in m_Nodes and the
   * corresponding distances. Notice that the distance to the noe
   * given in the argument will also be in there.
   *
   * @param n node to calculate distances to
   * @param distances the list with 
   */
  void getNodeDistances(PRMNode *n, 
                        std::list< std::pair<double, int> > &distances);

  /**
   * Clear the list of nodes and delete the node objects
   */
  void clearNodes();

  /**
   * Vector with all randomly generated nodes generated that do not
   * collide with any obstacles
   */
  std::vector<PRMNode*> m_Nodes;

  /**
   * Vector with pairs of indices coding the edges (only for debugging)
   */
  std::vector< std::pair<int, int> > m_Edges;

  /**
   * Store the step size used when building the road map to use when
   * looking for the closest node in findPath
   */
  double m_Step;
};

#endif // PRM_hh
