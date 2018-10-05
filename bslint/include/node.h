#ifndef __NODE_H__
#define __NODE_H__

#include <iostream>

struct Node
{
    Node *parent;
    std::string name;
    std::vector<Node> *children;
};

#endif