/*******************************
 * Name:	functions_tostring.cpp
 * Author:	Mikaël Mayer
 * Purpose:	Implements the toString methods of Function class
 * History: Work started 20070901
 *********************************/

#include "stdafx.h"
#include "functions.h"

TCHAR *Function::toStringConst(TCHAR* const data_const, TCHAR *max_data, STRING_TYPE string_type) {
  TCHAR* data = data_const;
  if(string_type == DEFAULT_TYPE) {
    StringRendering s(data_const, max_data);
    s << this;
    return s.data;

  } else { //if(string_type == OPENOFFICE3_TYPE){
    StringRenderingOpenOffice s(data_const, max_data);
    s << this;
    return s.data;
  }
}

void FunctionUnary::toString_name(StringRendering &s,
                                  TCHAR* function_name, bool parenthesis) {
  if(parenthesis)
    s << function_name << TEXT('(') << argument << TEXT(')');
  else if(s.type() == OPENOFFICE3_TYPE)
    s << function_name << TEXT('{') << argument << TEXT('}');
  else
    s << function_name << argument;
}

void FunctionBinary::toString_symbol(StringRendering &s, TCHAR* symbol) {
  if(argument->priorite() < priorite()) {
    s << TEXT('(') << argument << TEXT(')');
  } else if(s.type() == OPENOFFICE3_TYPE) {
    s << TEXT('{') << argument << TEXT('}');
  } else {
    s << argument;
  }

  s << symbol;

	if(argument2->priorite() <= priorite())
    s << TEXT('(') << argument2 << TEXT(')');
  else if(s.type() == OPENOFFICE3_TYPE)
    s << TEXT('{') << argument2 << TEXT('}');
  else
    s << argument2;
}
void Identity::toString(StringRendering &s) {
	s << TEXT('z');
}
void Identity_x::toString(StringRendering &s) {
	s << TEXT('x');
}
void Identity_y::toString(StringRendering &s) {
	s << TEXT('y');
}


// Les fonction toString:

void Somme::toString(StringRendering &s) {
  toString_symbol(s, TEXT("+"));
}

void Soustraction::toString(StringRendering &s) {
  toString_symbol(s, TEXT("-"));
}

void Multiplication::toString(StringRendering &s) {
	if(s.type() == OPENOFFICE3_TYPE)
  	toString_symbol(s, TEXT(" cdot ")); //TODO: ameliore
  else
  	toString_symbol(s, TEXT("*"));
}

void Division::toString(StringRendering &s) {
  if(s.type() == OPENOFFICE3_TYPE)
  	toString_symbol(s, TEXT(" over "));
  else
  	toString_symbol(s, TEXT("/"));
}

void ExposantComplexe::toString(StringRendering &s) {
	s << TEXT('(') << argument << TEXT(')');
  s << TEXT('^');
  if(s.type() == OPENOFFICE3_TYPE)
    s << TEXT('{') << argument2 << TEXT('}');
  else
	  s << TEXT('(') << argument2 << TEXT(')');
}

void Compose::toString(StringRendering &s) {
  s << TEXT("o");
  s << TEXT('(') << argument << TEXT(',') << argument2 << TEXT(')');
}

void CompositionRecursive::toString(StringRendering &s) {
  s << TEXT("oo");
  s << TEXT('(') << argument << TEXT(',') << nbCompose << TEXT(')');
}


void Exposant::toString(StringRendering &s) {
  s << TEXT('(');
	  s << argument;
  s << TEXT(')') << TEXT('^') << exposant;
}

void Constante::toString(StringRendering &s) {
	TCHAR nombre[256];
	valeur.toString(nombre);
  bool parenthesis = (_tcschr(nombre, TEXT('+'))!=NULL || _tcschr(nombre, TEXT('-'))!=NULL);
	if(parenthesis) s << TEXT('(');
  s << nombre;
	if(parenthesis) s << TEXT(')');
}

void Oppose::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("-"));
}

void Sin::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("sin"));
}

void Cos::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("cos"));
}
void Tan::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("tan"));
}

void Exp::toString(StringRendering &s) {
  if(s.type() == OPENOFFICE3_TYPE) {
    s << TEXT("e^{") << argument << TEXT("}");
  } else
    FunctionUnary::toString_name(s, TEXT("exp"));
}

void Cosh::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("cosh"));
}

void Sinh::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("sinh"));
}

void Tanh::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("tanh"));
}

void Ln::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("ln"));
}

void Sqrt::toString(StringRendering &s) {
  if(s.type() == OPENOFFICE3_TYPE) {
    s << TEXT("sqrt{") << argument << TEXT("}");
  } else
    FunctionUnary::toString_name(s, TEXT("sqrt"));
}

void Argsh::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("argsh"));
}

void Argch::toString(StringRendering &s) {
  FunctionUnary::toString_name(s, TEXT("argch"));
}

void Argth::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("argth"));
}

void Arcsin::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("arcsin"));
}

void Arccos::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("arccos"));
}

void Arctan::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("arctan"));
}


void Real::toString(StringRendering &s) {
  if(s.type() == OPENOFFICE3_TYPE) {
    s << TEXT("Re(") << argument << TEXT(")");
  } else
	  FunctionUnary::toString_name(s, TEXT("real"));
}

void Imag::toString(StringRendering &s) {
	if(s.type() == OPENOFFICE3_TYPE) {
    s << TEXT("Im(") << argument << TEXT(")");
  } else
	  FunctionUnary::toString_name(s, TEXT("imag"));
}

void Conj::toString(StringRendering &s) {
	if(s.type() == OPENOFFICE3_TYPE) {
    s << TEXT("Bar{") << argument << TEXT("}");
  } else
	  FunctionUnary::toString_name(s, TEXT("conj"));
}

void Circle::toString(StringRendering &s) {
	FunctionUnary::toString_name(s, TEXT("circle"));
}

void Variable::toString(StringRendering &s) {
  s << nom;
}

void FunctionMultiple::toString_multiple(StringRendering s, TCHAR* function_name) {
  if(s.type() == OPENOFFICE3_TYPE) {
    s << function_name << TEXT(" from {");
    s << var << TEXT("=") << debut;
    if(!(step->isConstant() && step->evalFast().real() == 1 && step->evalFast().imag() == 0)) {
      s << var << TEXT("+=") << step;
    }
    s << TEXT("} to {");
    s << fin;
    s << TEXT("} {");
    s << argument;
    s << TEXT("}");
    return;
  }
	s << function_name;
  s << TEXT('(');
    s << argument;
  s << TEXT(',');
	  s << var;
	s << TEXT(',');
    s << debut;
	s << TEXT(',');
    s << fin;
	s << TEXT(',');
    s << step;
	s << TEXT(')');
}

void SommeMultiple::toString(StringRendering &s) {
  //sum from{i=1} to{3} {}
  if(s.type() == OPENOFFICE3_TYPE)
    toString_multiple(s, TEXT("sum"));
  else
    toString_multiple(s, TEXT("sum"));
}

void ProduitMultiple::toString(StringRendering &s) {
  if(s.type() == OPENOFFICE3_TYPE)
    toString_multiple(s, TEXT("prod"));
  else
    toString_multiple(s, TEXT("prod"));
}

//Open Office model?
void CompositionMultiple::toString(StringRendering &s) {
	s << TEXT("comp");
  s << TEXT('(');
    s << argument;
	s << TEXT(',');
	  s << var;
	s << TEXT(',');
    s << debut;
	s << TEXT(',');
    s << fin;
	s << TEXT(')');
}

StringRendering::StringRendering(TCHAR* const data_, TCHAR* const max_data_):
  data(data_), max_data(max_data_)
 {
}

bool StringRendering::notReachedEnd() {
  return data != max_data;
}

StringRendering& StringRendering::operator<<(Function* const f) {
  if(f) f->toString(*this);
  return *this;
}

StringRendering& StringRendering::operator<<(TCHAR tch) {
  if(notReachedEnd()) {
    *(data++) = tch;
  }
  return *this;
}

StringRendering& StringRendering::operator<<(TCHAR* str) {
  size_t required_tchars = _tcslen(str);
  while(required_tchars > 0) {
    *this << *(str++);
    required_tchars--;
  }
  return *this;
}

StringRendering& StringRendering::operator<<(int number) {
  TCHAR number_string[256];
	_stprintf_s(number_string, TEXT("%d"), number);
  *this << number_string;
  return *this;
}
StringRendering& StringRendering::operator<<(double number) {
  TCHAR number_string[256];
	_stprintf_s(number_string, TEXT("%g"), number);
  *this << number_string;
  return *this;
}

StringRenderingOpenOffice::StringRenderingOpenOffice(
  TCHAR* const data, TCHAR* const max_data):
    StringRendering(data, max_data) {
}

StringRendering& StringRenderingOpenOffice::operator<<(Function* const f) {
  StringRendering::operator <<(f);
  return *this;
}

StringRendering& StringRenderingOpenOffice::operator<<(TCHAR tch) {
  if(notReachedEnd()) {
    if(tch == TEXT('(')) {
      StringRendering::operator <<(TEXT(" left "));
      StringRendering::operator <<(TEXT('('));
    } else if(tch == TEXT(')')) {
      StringRendering::operator <<(TEXT(" right "));
      StringRendering::operator <<(TEXT(')'));
    } else {
      *(data++) = tch;
    }
  }
  return *this;
}

