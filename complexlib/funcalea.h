/*******************************
 * Name:	funcalea.h
 * Author:	Mikaël Mayer
 * Purpose:	This file enable to c
 reate random functions thanks to a random-tree.
 * History: Work started 20071028
 *********************************/
#ifndef FUNCALEA_H
#define FUNCALEA_H
#include "functions.h"

class Tree2 {
public:
	Tree2* left;
	Tree2* right;
	int numberEmpty;
	Tree2() {numberEmpty = 2;left=NULL; right=NULL;}
	~Tree2() {if(left) delete left; if(right) delete right;}
	void fillEmptyNumber(int i);
	Function* convertToFunction(bool holo);
};

class Tree {
private:
	Tree2* t;
	Tree() {t=NULL;}
public:
	~Tree() {if(t) delete t;}
	int numberEmpty() {if(!t) return 1; else return t->numberEmpty;}
	void fillEmptyNumber(int i);
	void addRandomNodes(int n);
	Function* convertToFunction(bool holo);
	static Function* createFuncAlea(int n, bool holo);
};

#endif