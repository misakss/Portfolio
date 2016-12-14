//
// = FILENAME
//    AStarNode.cc
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
#include "AStarNode.hh"

#ifndef DEPEND
#include <float.h>
#endif

namespace Cure {

typedef std::list<std::pair<AStarNode*, double> >::iterator StarConnIter;

AStarNode::AStarNode()
{}

AStarNode::~AStarNode()
{}

bool 
AStarNode::findPath(AStarNode* target, double &cost)
{
  if (target == this) {
    this->parent = NULL;
    cost = 0;
    return true;
  }

  std::list<AStarNode*> open;
  std::list<AStarNode*> closed;

  addPathElement(this, 0, NULL, target, open, closed);

  bool found = false;
  while (!found && !open.empty()) {

    // Move the first item from the open list and move it to the list
    // of closed nodes
    AStarNode *node = open.front();
    open.pop_front();
    closed.push_front(node);

    // Check if we have reached the target node
    if (node == target) {
      found = true;
    } else {
      // Add all the nodes connected to this node
      std::list<std::pair<AStarNode*, double> > conns;
      node->getConnections(conns);

      for (StarConnIter e =conns.begin(); e != conns.end(); e++) {
        double costF = node->costG + e->second;
        addPathElement(e->first, costF, node, target, open, closed);
      }
    } 
  }

  cost = target->costG;
  
  return found;
}

void
AStarNode::addToOpenList(std::list<AStarNode*> &open, AStarNode *n)
{
  for (std::list<AStarNode*>::iterator i = open.begin(); 
       i != open.end(); i++) {
    if (n->costG + n->costH < (*i)->costG + (*i)->costH) {
      open.insert(i, n);
      return;
    }
  }

  open.push_back(n);
}

void
AStarNode::addPathElement(AStarNode* n, double cost, 
                          AStarNode *parent, AStarNode *target,
                          std::list<AStarNode*> &open,
                          std::list<AStarNode*> &closed)
{
  // Check if the node is already in the open or closed list and if
  // the cost there is lower. If this is the case there is no point in
  // going on because a path already exist to this node with lower
  // cost.
  for (std::list<AStarNode*>::iterator i = open.begin(); 
       i != open.end(); i++) {
    if (n == (*i)) {
      if ((*i)->costG > cost) {
        // The cost is lower and we could find a better path
        open.erase(i);
        break;
      } else {
        // Found a lower cost no point in going on
        return;
      }
    }
  }
  for (std::list<AStarNode*>::iterator i = closed.begin(); 
       i != closed.end(); i++) {
    if (n == (*i)) {
      if ((*i)->costG > cost) {
        // The cost is lower and we could find a better path
        closed.erase(i);
        break;
      } else {
        // Found a lower cost no point in going on
        return;
      }
    }
  }

  // Create new node or use found one from list
  n->parent = parent;              // Parent node
  n->costG  = cost;                // cost from start
  n->costH  = guessCostTo(target); // Guessed cost to target

  addToOpenList(open,n);
}

} // namespace Cure
