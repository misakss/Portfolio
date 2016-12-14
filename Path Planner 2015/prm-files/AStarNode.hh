//
// = FILENAME
//    AStarNode.hh
//
// = AUTHOR(S)
//    Patric Jensfelt
//
// = DESCRIPTION
//    
// = COPYRIGHT
//    Copyright (c) 2004 Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#ifndef Cure_AStarNode_hh
#define Cure_AStarNode_hh

#ifndef DEPEND
#include <list>
#include <string>
#endif

namespace Cure {

/**
 * Base class for nodes in agraph that you want to be able to use for
 * A* search. You need to implement a function getConnections that
 * will return a list of connnections to other nodes and the cost to
 * go there but then you should be able to use A*.
 * 
 * @author Patric Jensfelt 
 * @see
 */
class AStarNode {
public:
  AStarNode();

  virtual ~AStarNode();

  /**
   * Find a path from the current node to the 
   */
  bool findPath(AStarNode* target, double &cost);

  /**
   * Fill in the supplied list with connections from this node to
   * connected nodes
   * 
   * @param l list of connections to neighboring nodes and their costs
   * @return true always
   */
  virtual bool getConnections(std::list< std::pair<AStarNode*, double> > &l) = 0;

  /** Points to the next node to step to when a path has been found */
  AStarNode *parent;

protected:

  /** Temporary variable used when finding a path */
  double costG;

  /** Temporary variable used when finding a path */
  double costH;

  /**
   * Estimate the cost to get to a certain node. This is the
   * heuristics function. The better this function is the faster the
   * search will be.
   */  
  virtual double guessCostTo(AStarNode *n) { return 1; }

  void addToOpenList(std::list<AStarNode*> &open, AStarNode *n);

  void addPathElement(AStarNode* n, double cost, AStarNode *parent,
                      AStarNode* target,
                      std::list<AStarNode*> &open,
                      std::list<AStarNode*> &closed);

private:
};

}; // namespace Cure

#endif // Cure_AStarNode_hh
