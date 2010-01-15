/*******************************
 * Name:	funcalea.cpp
 * Author:	Mika�l Mayer
 * Purpose:	This file enable to create random functions thanks to a random-tree.
 * History: Work started 20071029
 *********************************/

#include "stdafx.h"
#include "funcalea.h"

void Tree2::fillEmptyNumber(int i) {
	if(numberEmpty<i)
		return;
	if(left==NULL) {
		if(i==1) {
			left = new Tree2();
		} else if(right==NULL && i==2) {
			right = new Tree2();
		} else if(right!=NULL) {
			right->fillEmptyNumber(i-1);
		}
	} else {
		int n=left->numberEmpty;
		if(i<=n)
			left->fillEmptyNumber(i);
		else if (right!=NULL){
			right->fillEmptyNumber(i-n);
		} else if(right == NULL && i==n+1) {
			right = new Tree2();
		}
	}
	numberEmpty++;
}

void Tree::fillEmptyNumber(int i) {
	if(t==NULL) {
		t=new Tree2();
		return;
	}
	t->fillEmptyNumber(i);
}

void Tree::addRandomNodes(int n) {
	int size = numberEmpty();
	for(int i=0; i<n; i++) {
		fillEmptyNumber((rand()%size)+1);
		size++;
	}
}

cplx randcplx() {
	//Nombre d�cimal al�atoire entre -4 et 4
	return cplx((double)(rand()%400)/50.0-4.0,
				(double)(rand()%400)/50.0-4.0);
}

Function* randPolynom(int degre) {
	if(degre==0) return new Constante(randcplx());
	return new Somme(randPolynom(0), new Multiplication(Identity::get(), randPolynom(degre-1)));
}

Function *Tree2::convertToFunction(bool holo) {
	if(left==NULL && right==NULL) {
		int numbercasesIdentity = holo?1:4;
		switch(rand()%numbercasesIdentity) {
			case 0:
			case 1:	return Identity::get();
			case 2:	return Identity_x::get();
			case 3:	return Identity_y::get();
		}
	}
	Function *argument1=NULL, *argument2=NULL;
	if(left!=NULL)
		argument1=left->convertToFunction(holo);
	if(right!=NULL)
		argument2=right->convertToFunction(holo);
	if(argument2!=NULL && argument1==NULL) {
		argument1=argument2;
		argument2=NULL;
	}
	int numbercases;
	if(holo)
		numbercases=18;
	else
		numbercases = 22;
	if(argument2==NULL) {//Fonctions unaires
		switch(rand()%numbercases) {
			case 0: return new Exp(argument1);
			case 1: return new Cos(argument1);
			case 2: return new Sin(argument1);
			case 3: return new Cosh(argument1);
			case 4: return new Sinh(argument1);
			case 5: return new Arcsin(argument1);
			case 6: return new Arccos(argument1);
			case 7: return new Arctan(argument1);
			case 8: return new Argsh(argument1);
			case 9: return new Argch(argument1);
			case 10: return new Argth(argument1);
			case 11: return new Exposant(argument1,2);
			case 12: return new Exposant(argument1,rand()%4+2);
			case 13: return new Division(new Constante(1.0),argument1);
			case 14: return new Exposant(argument1,-(rand()%4+2));
			case 15: return new Multiplication(new Constante(randcplx()),argument1);
			case 16: return new Somme(new Constante(randcplx()),argument1);
			case 17: return new Compose(randPolynom(rand()%3+1), argument1);
			case 18: return new Real(argument1);
			case 19: return new Imag(argument1);
			case 20: return new Conj(argument1);
			case 21: return new Circle(argument1);
		}
	} else {
		switch(rand()%6) {
			case 0: return new Multiplication(argument1, argument2);
			case 1: return new Somme(argument1, argument2);
			case 2: 
				if(argument1==Identity::get() && argument2==Identity::get())
					return new Constante(1.0);
				return new Division(argument1, argument2);
			case 3:
				if(argument1==Identity::get() && argument2==Identity::get())
					return new Constante(-1.0);
				return new Soustraction(argument1, argument2);
			case 4: return new ExposantComplexe(argument1, argument2);
			case 5: return new Compose(argument1, argument2);
		}
	}
	return NULL;
}

Function *Tree::convertToFunction(bool holo) {
	if(t==NULL) //Cas normalement improbable.
		return new Constante(0.0);
	return t->convertToFunction(holo);
}

Function* Tree::createFuncAlea(int n, bool holo) {
	Tree* t = new Tree();
	//srand(1);
	t->addRandomNodes(n);
	Function *resultat = t->convertToFunction(holo);
	delete t;
	return resultat;
}
