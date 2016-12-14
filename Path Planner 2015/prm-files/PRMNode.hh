//
// = FILENAME
//    PRMNode.hh
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#ifndef PRMNode_hh
#define PRMNode_hh

#include "AStarNode.hh"
#include "Position.hh"

#include <cmath>

class PRMNode : public Position,
                public Cure::AStarNode
{
public:

  /**
   * Call this function to add a new edge to a certain node
   *
   * @param node pointer to node to add edge to
   */
  void addNewEdge(PRMNode* node);

  /**
   * Call this function to remove an edge (if it exists) to a certain node
   * 
   * @param node pointer to node to delete the edge to
   */
  void deleteEdge(PRMNode* node);

  /**
   * This function should return a list of nodes connected to this one
   * and the cost to move there
   * 
   * @param l list of connections to neighboring nodes and their costs
   * @return true always
   */
  bool getConnections(std::list< std::pair<AStarNode*, double> > &l);

protected:
  /// List of edges
  std::list<PRMNode*> m_Edges;

  double guessCostTo(AStarNode *n);
};

inline double
PRMNode::guessCostTo(AStarNode *n)
{
  double dx = ((PRMNode*)n)->getX() - getX();
  double dy = ((PRMNode*)n)->getY() - getY();
  return sqrt(dx*dx+dy*dy);
}

#endif // PRMNode_hh
