/*******************************
 * Name:	functions_tostring.cpp
 * Author:	Mikaël Mayer
 * Purpose:	Implements the toString methods of Function class
 * History: Work started 20070901
 *********************************/

#include "stdafx.h"
#include "functions.h"

TCHAR *Function::toStringConst(TCHAR* const data_const, TCHAR *max_data) {
  TCHAR* data = data_const;
  toString(data, max_data);
  return data;
}

TCHAR* Function::addString(TCHAR* &data, TCHAR *max_data, TCHAR* str) {
  size_t required_tchars = _tcslen(str);
  while(required_tchars > 0 && data != max_data) {
    *(data++) = *(str++);
    required_tchars--;
  }
  return data;
}

TCHAR* Function::addTchar(TCHAR* &data, TCHAR *max_data, TCHAR tch) {
  if(data != max_data) *(data++) = tch;
  return data;
}

TCHAR* Function::addInt(TCHAR* &data, TCHAR *max_data, int number) {
  TCHAR nombre[256];
	_stprintf_s(nombre, TEXT("%d"), number);
  addString(data, max_data, nombre);
  return data;
}
TCHAR* Function::addDouble(TCHAR* &data, TCHAR *max_data, double number) {
  TCHAR nombre[256];
	_stprintf_s(nombre, TEXT("%g"), number);
  addString(data, max_data, nombre);
  return data;
}

TCHAR* FunctionUnary::toString_name(TCHAR* &data, TCHAR *max_data,
                                    TCHAR* function_name, bool parenthesis) {
  addString(data, max_data, function_name);
  if(parenthesis) addTchar(data, max_data, '(');
	argument->toString(data, max_data);
  if(parenthesis) addTchar(data, max_data, ')');
	return data;
}


TCHAR* FunctionBinary::toString_symbol(TCHAR* &data, TCHAR *max_data, TCHAR symbol) {
  if(argument->priorite()<priorite()) addTchar(data, max_data, L'(');
	argument->toString(data, max_data);
	if(argument->priorite()<priorite()) addTchar(data, max_data, L')');
	if(data!=max_data) *(data++) = symbol;
	if(argument2->priorite()<=priorite()) addTchar(data, max_data, L'(');
	argument2->toString(data, max_data);
	if(argument2->priorite()<=priorite()) addTchar(data, max_data, L')');
	return data;
}
TCHAR *Identity::toString(TCHAR* &data, TCHAR *max_data) {
	addTchar(data, max_data, L'z'); return data;
}
TCHAR *Identity_x::toString(TCHAR* &data, TCHAR *max_data) {
	addTchar(data, max_data, L'x'); return data;
}
TCHAR *Identity_y::toString(TCHAR* &data, TCHAR *max_data) {
	addTchar(data, max_data, L'y'); return data;
}


// Les fonction toString:

TCHAR *Somme::toString(TCHAR* &data, TCHAR *max_data) {
  return toString_symbol(data, max_data, L'+');
}

TCHAR *Soustraction::toString(TCHAR* &data, TCHAR *max_data) {
  return toString_symbol(data, max_data, L'-');
}

TCHAR *Multiplication::toString(TCHAR* &data, TCHAR *max_data) {
	return toString_symbol(data, max_data, L'*');
}

TCHAR *Division::toString(TCHAR* &data, TCHAR *max_data) {
	return toString_symbol(data, max_data, L'/');
}

TCHAR *ExposantComplexe::toString(TCHAR* &data, TCHAR *max_data) {
	addTchar(data, max_data, L'(');
	argument->toString(data, max_data);
	addString(data, max_data, TEXT(")^("));
	argument2->toString(data, max_data);
	addTchar(data, max_data, L')');
	return data;
}

TCHAR *Compose::toString(TCHAR* &data, TCHAR *max_data) {
	addString(data, max_data, TEXT("o("));
	argument->toString(data, max_data);
	addTchar(data, max_data, L',');
	argument2->toString(data, max_data);
	addTchar(data, max_data, L')');
	return data;
}

TCHAR *CompositionRecursive::toString(TCHAR* &data, TCHAR *max_data) {
	addString(data, max_data, TEXT("oo("));
	argument->toString(data, max_data);
	addTchar(data, max_data, L',');
  addInt(data, max_data, nbCompose);
	addTchar(data, max_data, L')');
	return data;
}


TCHAR *Exposant::toString(TCHAR* &data, TCHAR *max_data) {
  addString(data, max_data, TEXT("("));
	argument->toString(data, max_data);
  addString(data, max_data, TEXT(")^"));
  addInt(data, max_data, exposant);
	return data;
}

TCHAR *Constante::toString(TCHAR* &data, TCHAR *max_data) {
	TCHAR nombre[256];
	valeur.toString(nombre);
  bool parenthesis = (_tcschr(nombre, L'+')!=NULL || _tcschr(nombre, L'-')!=NULL);
	if(parenthesis) addTchar(data, max_data, L'(');
  addString(data, max_data, nombre);
	if(parenthesis) addTchar(data, max_data, L')');
	return data;
}

TCHAR *Oppose::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("-"));
}

TCHAR *Sin::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("sin"));
}

TCHAR *Cos::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("cos"));
}
TCHAR *Tan::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("tan"));
}

TCHAR *Exp::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("exp"));
}

TCHAR *Cosh::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("cosh"));
}

TCHAR *Sinh::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("sinh"));
}

TCHAR *Tanh::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("tanh"));
}

TCHAR *Ln::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("ln"));
}

TCHAR *Sqrt::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("sqrt"));
}

TCHAR *Argsh::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("argsh"));
}

TCHAR *Argch::toString(TCHAR* &data, TCHAR *max_data) {
  return FunctionUnary::toString_name(data, max_data, TEXT("argch"));
}

TCHAR *Argth::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("argth"));
}

TCHAR *Arcsin::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("arcsin"));
}

TCHAR *Arccos::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("arccos"));
}

TCHAR *Arctan::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("arctan"));
}

TCHAR *Real::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("real"));
}

TCHAR *Imag::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("imag"));
}

TCHAR *Conj::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("conj"));
}

TCHAR *Circle::toString(TCHAR* &data, TCHAR *max_data) {
	return FunctionUnary::toString_name(data, max_data, TEXT("circle"));
}

TCHAR *Variable::toString(TCHAR* &data, TCHAR *max_data) {
  addString(data, max_data, nom);
	return data;
}

TCHAR *SommeMultiple::toString(TCHAR* &data, TCHAR *max_data) {
	addString(data, max_data, TEXT("sum("));
  argument->toString(data, max_data);
  addTchar(data, max_data, L',');
	var->toString(data, max_data);
	addTchar(data, max_data, L',');
  debut->toString(data, max_data);
	addTchar(data, max_data, L',');
  fin->toString(data, max_data);
	addTchar(data, max_data, L',');
  step->toString(data, max_data);
	addTchar(data, max_data, L')');
	return data;
}

TCHAR *ProduitMultiple::toString(TCHAR* &data, TCHAR *max_data) {
	addString(data, max_data, TEXT("prod("));
	argument->toString(data, max_data);
	addTchar(data, max_data, L',');
	var->toString(data, max_data);
	addTchar(data, max_data, L',');
  debut->toString(data, max_data);
	addTchar(data, max_data, L',');
  fin->toString(data, max_data);
	addTchar(data, max_data, L',');
  step->toString(data, max_data);
	addTchar(data, max_data, L')');
	return data;
}

TCHAR *CompositionMultiple::toString(TCHAR* &data, TCHAR *max_data) {
	addString(data, max_data, TEXT("comp("));
	data = argument->toString(data, max_data);
	addTchar(data, max_data, L',');
	data = var->toString(data, max_data);
	addTchar(data, max_data, L',');
  data = debut->toString(data, max_data);
	addTchar(data, max_data, L',');
  data = fin->toString(data, max_data);
	addTchar(data, max_data, L')');
  return data;
}

