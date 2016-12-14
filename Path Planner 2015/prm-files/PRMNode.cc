//
// = FILENAME
//    PRMNode.cc
//
// = AUTHOR(S)
//    Patric Jensfelt
//
/*----------------------------------------------------------------------*/

#include "PRMNode.hh"

#include <cmath>
#include <algorithm>

void
PRMNode::addNewEdge(PRMNode *node)
{
  m_Edges.push_back(node);
}

void
PRMNode::deleteEdge(PRMNode *node)
{
  std::list<PRMNode*>::iterator foundEdge = m_Edges.end();

  foundEdge = std::find(m_Edges.begin(), m_Edges.end(), node);
  
  if (foundEdge != m_Edges.end()) m_Edges.erase(foundEdge);
}

bool
PRMNode::getConnections(std::list< std::pair<AStarNode*, double> > &l)
{
  for (std::list<PRMNode*>::iterator i = m_Edges.begin();
       i != m_Edges.end(); i++) {

    double dx = getX() - (*i)->getX();
    double dy = getY() - (*i)->getY();
    double d = sqrt(dx*dx + dy*dy);

    l.push_back( std::make_pair(*i, d) );
  }
  return true;
}
