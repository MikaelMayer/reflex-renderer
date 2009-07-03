/*******************************
 * Name:	functions.h
 * Author:	Mikaël Mayer
 * Purpose:	The Function class enables to dynamically calculate
		expressions with complex-number.
			The Identity::get() is a substitute for calculating z.
 * History: Work started 20070901
 *********************************/

//To delete a node without deleting children, call the delete function.
//to completely delete a tree, call the kill function before.

#ifndef FUNCTIONS_H
#define FUNCTIONS_H
#include "complex.h"
class Variable;
class StringRendering;

enum STRING_TYPE {
  DEFAULT_TYPE,
  OPENOFFICE3_TYPE,
};

class Function {
	public:

		virtual bool isConstant() {return false;}
		virtual bool isVariable() {return false;}
		virtual Function* simplifie() {return this;}
		virtual cplx eval(cplx & z)=0;
    //TODO: When all functions will have evalFast implemented,
    //      make this method abstract
    virtual cplx evalFast()=0;
		virtual void toString(StringRendering &s)=0;

    TCHAR *toStringConst(TCHAR* const data, TCHAR *max_data, STRING_TYPE type=DEFAULT_TYPE);
		virtual Function* kill()=0;	//Fonction récursive.
		virtual int priorite()=0;
		virtual ~Function() {}
		Function() {}

};
//La priorité est utilisée pour mettre des parenthèses dans la fonction toString().
//si un argument a une priorité plus grande, pas la peine de le mettre en parenthèses.
//Sinon, parenthèses obligatoire.
// + a une priorité de 1
// - a une priorité de 2
// * a une priorité de 3
// / a une priorité de 4
// ^ a une priorité de 5
//sin a une priorité de 6 comme les autres fonctions.
//Les variables et constantes ont une priorité de 10 (pas besoin de parenthèses).
//Les constantes se mettent automatiquement des parenthèses.

//class singleton: Only One Identity
class Identity:public Function {
private:
	Identity  () {}
public:
	~Identity () {
		Id=0;
	}
	static Identity* get();
  static cplx current;
  static void setCurrentComplex(cplx _current) { current = _current; }
	static void killf ();
	cplx eval(cplx & z);
  cplx evalFast() {return current;}
	virtual void toString(StringRendering &s);
	Function* kill() { return NULL; }
	int priorite() { return 10; }
private:
	static Identity* Id;
};

class Identity_x:public Function {
private:
	Identity_x() {}
	~Identity_x () {}
public:
	static Identity_x* get();
	static void killf ();
	cplx eval(cplx & z);
  cplx evalFast() {return Identity::current.real();}
	virtual void toString(StringRendering &s);
	Function* kill() { return NULL; }
	int priorite() { return 10; }
private:
	static Identity_x* Id;
};

class Identity_y:public Function {
private:
	Identity_y() {}
	~Identity_y () {}
public:
	static Identity_y* get();
	static void killf ();
	cplx eval(cplx & z);
  cplx evalFast() {return Identity::current.imag();}
	virtual void toString(StringRendering &s);
	Function* kill() { return NULL; }
	int priorite() { return 10; }
private:
	static Identity_y* Id;
};

class FunctionUnary:public Function {
protected:
	Function* argument;	//Jamais NULL
public:
	FunctionUnary(Function* theArgument);
	virtual ~FunctionUnary();
	virtual Function* kill();
	void setArgument(Function* theArgument);
	virtual Function* simplifie();
  void toString_name(StringRendering &s, TCHAR* function_name, bool parenthesis = true);
	bool simplifieArgFunctionUnary();
};

class FunctionBinary:public FunctionUnary {
protected:
	Function* argument2;  //Jamais NULL
public:
	FunctionBinary(Function* theArgument, Function* theArgument2);
	virtual ~FunctionBinary();
	virtual Function* kill();
	void setArgument2(Function* theArgument2);
	virtual Function* simplifie();
  void toString_symbol(StringRendering &s, TCHAR *symbol, bool parentheses_possibles=true);
	bool simplifieArgFunctionBinary();
};

class Somme:public FunctionBinary {
public:
	Somme(Function* argument, Function* argument2):FunctionBinary(argument, argument2){}
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 1;}
};

class Multiplication:public FunctionBinary {
public:
	Multiplication(Function* argument, Function* argument2):FunctionBinary(argument, argument2){}
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 3;}
};

class Soustraction:public FunctionBinary {
public:
	Soustraction(Function* argument, Function* argument2):FunctionBinary(argument, argument2){}
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 2;}
};

class Division:public FunctionBinary {
public:
	Division(Function* argument, Function* argument2):FunctionBinary(argument, argument2){}
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 4;}
};

class Compose:public FunctionBinary {
public:
	Compose(Function* argument, Function* argument2):FunctionBinary(argument, argument2) {}
	virtual Function *simplifie();
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class ExposantComplexe:public FunctionBinary {
public:
	ExposantComplexe(Function* argument, Function* argument2):FunctionBinary(argument, argument2) {}
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 5;}
};

class Exposant:public FunctionUnary {
public:
	Exposant(Function* argument, int exposant):FunctionUnary(argument),exposant(exposant) {}
	int exposant;
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 5;}
};

class CompositionRecursive:public FunctionUnary {
public:
	CompositionRecursive(Function* argument, int nbCompose):FunctionUnary(argument),nbCompose(nbCompose) {}
	int nbCompose;
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};


class Constante:public Function {
public:
	cplx valeur;
	bool isConstant() {return true;}
	Constante(double valeur);
	Constante(cplx valeur);
	void setCplx(cplx c) {valeur = c;}
	void setReal(double re) {valeur.setreal(re);}
	void setImag(double im) {valeur.setimag(im);}
	Function* kill() { delete this; return NULL; }
	cplx eval(cplx & z) {return valeur;}
  cplx evalFast() {return valeur;}
	virtual void toString(StringRendering &s);
	int priorite() {return 10;}
};

class Oppose:public FunctionUnary {
public:
	Oppose(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx &z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 0;}
};

class Sin:public FunctionUnary {
public:
	Sin(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};


class Cos:public FunctionUnary {
public:
	Cos(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Tan:public FunctionUnary {
public:
	Tan(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Exp:public FunctionUnary {
public:
	Exp(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Sinh:public FunctionUnary {
public:
	Sinh(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Cosh:public FunctionUnary {
public:
	Cosh(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Tanh:public FunctionUnary {
public:
	Tanh(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Ln:public FunctionUnary {
public:
	Ln(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Sqrt:public FunctionUnary {
public:
	Sqrt(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Argsh:public FunctionUnary {
public:
	Argsh(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Argch:public FunctionUnary {
public:
	Argch(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Argth:public FunctionUnary {
public:
	Argth(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Arcsin:public FunctionUnary {
public:
	Arcsin(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Arccos:public FunctionUnary {
public:
	Arccos(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Arctan:public FunctionUnary {
public:
	Arctan(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Real:public FunctionUnary {
public:
	Real(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Imag:public FunctionUnary {
public:
	Imag(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Conj:public FunctionUnary {
public:
	Conj(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class Circle:public FunctionUnary {
public:
	Circle(Function* argument):FunctionUnary(argument) {};
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

//Variable réelle. Implémentation en fait d'une liste cachée
class Variable:public Function {
private:
	cplx val;
	TCHAR *nom;
	Variable *prec;
	Variable(TCHAR* theNom):val(0) {setNom(theNom);}
	Variable(cplx & theValeur, TCHAR* theNom):val(theValeur) {setNom(theNom);}
	~Variable();
	void setNom(const TCHAR* theNom);
	Variable *prev() {return prec;}
	void setPrev(Variable *prev) {prec=prev;}
public:
	bool isVariable() {return true;}
	cplx eval(cplx & z) {return val;}
  cplx evalFast() {return val;}
	virtual void toString(StringRendering &s);
	int priorite() {return 10;}
	Function* kill() { return NULL; }
	void set(cplx & z) {val=z;}
	friend class VariableListe;
};


class FunctionMultiple:public FunctionUnary {
protected:
  Variable *var;
	Function *debut;  //Jamais NULL
  Function *fin;    //Jamais NULL
  Function *step;   //Jamais NULL
public:
	FunctionMultiple(Function* _arg, Variable *_var, Function *_debut, Function *_fin, Function* _step);
	FunctionMultiple(Function* _arg, Variable *_var, Function *_debut, Function *_fin);
	virtual ~FunctionMultiple();
	virtual Function* kill();
	virtual Function* simplifie();
  void toString_multiple(StringRendering s, TCHAR* symbol);
	bool simplifieArgFunctionMultiple();
};


class SommeMultiple:public FunctionMultiple {
public:
	SommeMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin, Function* theStep);
	SommeMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin);
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

class ProduitMultiple:public FunctionMultiple {
public:
	ProduitMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin, Function* theStep);
	ProduitMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin);
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};

//theFin must give an integer to know up to which portion we will compute mandebrot.
//theStep is ignored.
class CompositionMultiple:public FunctionMultiple {
public:
	CompositionMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin);
	cplx eval(cplx & z);
  cplx evalFast();
	virtual void toString(StringRendering &s);
	int priorite() {return 6;}
};


//List of variables and their name.
class VariableListe {
private:
	VariableListe() {tete=NULL;count=0;}
	~VariableListe() {}
	Variable *tete;
	int count;
	static VariableListe* varList;
public:
	static VariableListe* get();
	static void killf();
	//If the variable doesn't exist, it is created.
	Variable* getVariable(TCHAR* nom);
};

class StringRendering {
public:
  TCHAR* data;
  const TCHAR* max_data;

  StringRendering(TCHAR* const data, TCHAR* const max_data);
  bool notReachedEnd();
  virtual StringRendering& operator<<(Function *const f);
  virtual StringRendering& operator<<(TCHAR tch);
  virtual StringRendering& operator<<(TCHAR* tch);
  virtual StringRendering& operator<<(int number);
  virtual StringRendering& operator<<(double number);
  virtual STRING_TYPE type() { return DEFAULT_TYPE; }
};

class StringRenderingOpenOffice:public StringRendering {
public:
  StringRenderingOpenOffice(TCHAR* const data, TCHAR* const max_data);

  /// Override
  StringRendering& operator<<(Function *const f);
  StringRendering& operator<<(TCHAR tch);
  STRING_TYPE type() { return OPENOFFICE3_TYPE; }
};

#endif
