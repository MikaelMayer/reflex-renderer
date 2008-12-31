/*******************************
 * Name:	functions.cpp
 * Author:	Mikaël Mayer
 * Purpose:	Implements the Function class
 * History: Work started 20070901
 *********************************/

#include "stdafx.h"
#include "functions.h"

//Function to be deleted after update.
cplx Function::evalFast() {
  return eval(Identity::current);
}

//FunctionUnary basic implementations.
FunctionUnary::FunctionUnary(Function* theArgument) {
	setArgument(theArgument);
}
//delete est seulement la destruction du noeud (pour les simplifications p.ex)
FunctionUnary::~FunctionUnary() {
}

Function* FunctionUnary::kill() {
  if(argument)
  	argument = argument->kill();
	delete this;
  return NULL;
}

void FunctionUnary::setArgument(Function* theArgument) {
	argument=(theArgument==NULL?Identity::get():theArgument);
}

bool FunctionUnary::simplifieArgFunctionUnary() {
	argument=argument->simplifie();
	return argument->isConstant();
}

Function *FunctionUnary::simplifie() {
	//Si la fonction est constante, on la simplifie.
	if(!simplifieArgFunctionUnary()) return this;
	//Ici, cela veut dire que l'argument est constant.
	//On fait donc simple... on garde la constante de l'argument, modifiée, et on se supprime.
	cplx res = this->eval((dynamic_cast<Constante*>(argument))->valeur);
	kill();//On tue récursivement le noeud et son fils.
	return new Constante(res);//Et on retourne une nouvelle constante.
}

//FunctionBinary basic implementations.
FunctionBinary::FunctionBinary(Function* theArgument, Function* theArgument2):FunctionUnary(theArgument) {
	setArgument2(theArgument2);
}
//delete just this node.
FunctionBinary::~FunctionBinary() {
}

Function* FunctionBinary::kill() {
	if(argument2)
  	argument2 = argument2->kill();
  return FunctionUnary::kill();
}

void FunctionBinary::setArgument2(Function *theArgument2) {
	argument2=(theArgument2==NULL?Identity::get():theArgument2);
}
bool FunctionBinary::simplifieArgFunctionBinary() {
	bool resultat = simplifieArgFunctionUnary();
	argument2 = argument2->simplifie();
	return resultat && argument2->isConstant();
}
Function *FunctionBinary::simplifie() {
	if(!simplifieArgFunctionBinary()) return this;
	cplx res = this->eval((dynamic_cast<Constante*>(argument))->valeur);
	kill();						//On tue récurivement le noeud et son fils.
	return new Constante(res);	//On récupère une nouvelle constante.
}

//Cas particulier de la fonction compose.
Function *Compose::simplifie() {
	simplifieArgFunctionBinary();
	if(argument->isConstant()) {//Le premier argument est constant.
		cplx res = dynamic_cast<Constante*>(argument)->valeur;
		kill();
		return new Constante(res);
	} else if(argument2->isConstant()) {
		cplx res = this->eval(cplx(0));//Peu importe l'endroit où on l'évalue.
		kill();
		return new Constante(res);
	} else if(argument == Identity::get()) {
		//une composition avec l'identité => c'est la deuxième fonction
		Function *f = argument2;
		delete this;
		return f;
	} else if(argument2 == Identity::get()) {
		//une composition avec l'identité => c'est la deuxième fonction
		Function *f = argument;
		delete this;
		return f;
	}
	return this;
}

cplx Identity::current=0;

//Identities definition.
Identity* Identity::get() {
	if(Id == NULL)
		Id = new Identity();
	return Id;
}
void Identity::killf () {
	if (Id != NULL)
		delete Id;
}
cplx Identity::eval(cplx & z) {
	return z;
}
TCHAR *Identity::toString(TCHAR *espace, TCHAR *finEspace) {
	if(espace!=finEspace)
		*(espace++)=L'z'; return espace;
}
Identity_x* Identity_x::get() {
	if(Id == NULL)
		Id = new Identity_x();
	return Id;
}
void Identity_x::killf () {
	if (Id != NULL)
		delete Id;
}
cplx Identity_x::eval(cplx & z) {
	return z.realcplx();
}
TCHAR *Identity_x::toString(TCHAR *espace, TCHAR *finEspace) {
	if(espace!=finEspace) *(espace++)=L'x'; return espace;
}
Identity_y* Identity_y::get() {
	if(Id == NULL)
		Id = new Identity_y();
	return Id;
}
void Identity_y::killf () {
	if (Id != NULL)
		delete Id;
}
cplx Identity_y::eval(cplx & z) {
	return z.imagcplx();
}
TCHAR *Identity_y::toString(TCHAR *espace, TCHAR *finEspace) {
	if(espace!=finEspace) *(espace++)=L'y'; return espace;
}
Identity *Identity::Id=NULL;
Identity_x *Identity_x::Id=NULL;
Identity_y *Identity_y::Id=NULL;

//Some binary functions.
cplx Somme::eval(cplx & z)			      {return argument->eval(z)+argument2->eval(z);}
cplx Somme::evalFast()			          {return argument->evalFast()+argument2->evalFast();}
cplx Multiplication::eval(cplx & z)	  {return argument->eval(z)*argument2->eval(z);}
cplx Multiplication::evalFast()	      {return argument->evalFast()*argument2->evalFast();}
cplx Soustraction::eval(cplx & z)	    {return argument->eval(z)-argument2->eval(z);}
cplx Soustraction::evalFast()	        {return argument->evalFast()-argument2->evalFast();}
cplx Division::eval(cplx & z)		      {return argument->eval(z)/argument2->eval(z);}
cplx Division::evalFast()		          {return argument->evalFast()/argument2->evalFast();}
cplx Compose::eval(cplx & z)		      {return argument->eval(argument2->eval(z));}
//TODO: Comparer cette méthode avec celle de remplacer l'objet courant et de le restaurer
cplx Compose::evalFast()		          {return argument->eval(argument2->evalFast());}
cplx ExposantComplexe::eval(cplx & z) {return exp(argument2->eval(z)*ln(argument->eval(z)));}
cplx ExposantComplexe::evalFast()     {return exp(argument2->evalFast()*ln(argument->evalFast()));}

cplx CompositionRecursive::eval(cplx & z) {
	cplx resultat=z;
	int i=this->nbCompose;
	while(i>0) {resultat=argument->eval(resultat); i--;}//si i<0, on laisse l'identité (l'inverse n'est pas défini)
	return resultat;
}
cplx CompositionRecursive::evalFast() {
	cplx resultat = Identity::current;
  cplx current_sauv = resultat;
	int i=this->nbCompose;
	while(i>0) {
    Identity::setCurrentComplex(resultat);
    resultat = argument->evalFast();
    i--;
  }//si i<0, on laisse l'identité (l'inverse n'est pas défini)
  Identity::setCurrentComplex(current_sauv);
	return resultat;
}

Constante::Constante(double valeur):valeur(valeur) {
  if(this->valeur.real() != this->valeur.real()) {
    this->valeur = 1;
  }
}

Constante::Constante(cplx valeur):valeur(valeur) {
  if(this->valeur.real()!=this->valeur.real() || this->valeur.imag() != this->valeur.imag()) {
    this->valeur = 1;
  }
}

cplx Exposant::eval(cplx & z) {	return argument->eval(z)^exposant;}
cplx Exposant::evalFast()   {	return argument->evalFast()^exposant;}
cplx Oppose::eval(cplx & z) { return -argument->eval(z); }
cplx Oppose::evalFast()   { return -argument->evalFast(); }
cplx Sin::eval(cplx & z)	{ return sin(argument->eval(z)); }
cplx Sin::evalFast()	    { return sin(argument->evalFast()); }
cplx Cos::eval(cplx & z)	{ return cos(argument->eval(z)); }
cplx Cos::evalFast()	    { return cos(argument->evalFast()); }
cplx Tan::eval(cplx & z)	{ return tan(argument->eval(z)); }
cplx Tan::evalFast()	      { return tan(argument->evalFast()); }
cplx Exp::eval(cplx & z)	{ return exp(argument->eval(z)); }
cplx Exp::evalFast()	    { return exp(argument->evalFast()); }
cplx Sinh::eval(cplx & z)	{ return sinh(argument->eval(z)); }
cplx Sinh::evalFast()	    { return sinh(argument->evalFast()); }
cplx Cosh::eval(cplx & z)	{ return cosh(argument->eval(z)); }
cplx Cosh::evalFast()	    { return cosh(argument->evalFast()); }
cplx Tanh::eval(cplx & z)	{ return tanh(argument->eval(z)); }
cplx Tanh::evalFast()	    { return tanh(argument->evalFast()); }
cplx Ln::eval(cplx & z)		{ return ln(argument->eval(z)); }
cplx Ln::evalFast()	    	{ return ln(argument->evalFast()); }
cplx Sqrt::eval(cplx & z)	{ return sqrt(argument->eval(z)); }
cplx Sqrt::evalFast()	    { return sqrt(argument->evalFast()); }
cplx Argsh::eval(cplx & z)	{ return argsh(argument->eval(z)); }
cplx Argsh::evalFast()	    { return argsh(argument->evalFast()); }
cplx Argch::eval(cplx & z)	{ return argch(argument->eval(z)); }
cplx Argch::evalFast()	    { return argch(argument->evalFast()); }
cplx Argth::eval(cplx & z)	{ return argth(argument->eval(z)); }
cplx Argth::evalFast()	    { return argth(argument->evalFast()); }

cplx Arcsin::eval(cplx & z)	{ return arcsin(argument->eval(z)); }
cplx Arcsin::evalFast()	    { return arcsin(argument->evalFast()); }
cplx Arccos::eval(cplx & z)	{ return arccos(argument->eval(z)); }
cplx Arccos::evalFast()	    { return arccos(argument->evalFast()); }
cplx Arctan::eval(cplx & z)	{ return arctan(argument->eval(z)); }
cplx Arctan::evalFast()	    { return arctan(argument->evalFast()); }

cplx Real::eval(cplx & z)   { return argument->eval(z).realcplx(); }
cplx Real::evalFast()       { return argument->evalFast().realcplx(); }
cplx Imag::eval(cplx & z)   { return argument->eval(z).imagcplx(); }
cplx Imag::evalFast()       { return argument->evalFast().imagcplx(); }
cplx Conj::eval(cplx & z)   { return argument->eval(z).conj(); }
cplx Conj::evalFast()       { return argument->evalFast().conj(); }
cplx Circle::eval(cplx & z) { cplx w=argument->eval(z); return w.conj()-w.invs(); }//Optimiser?
cplx Circle::evalFast()     { cplx w=argument->evalFast(); return w.conj()-w.invs(); }//Optimiser?

//Function with variables.
FunctionMultiple::FunctionMultiple(
    Function* _arg,      Variable *_var, Function *_debut, Function *_fin, Function* _step):
    FunctionUnary(_arg), var(_var),      debut(_debut),    fin(_fin),      step(_step) {
}
FunctionMultiple::FunctionMultiple(
  Function *_arg,     Variable *_var, Function *_debut, Function *_fin):
  FunctionUnary(_arg),var(_var),      debut(_debut),    fin(_fin),     step(new Constante(1.0))
 {
}
//delete est seulement la destruction du noeud (pour les simplifications p.ex)
FunctionMultiple::~FunctionMultiple() {
}

Function* FunctionMultiple::kill() {
  if(debut)
    debut = debut->kill();
  if(fin)
    fin = fin->kill();
  if(step)
    step = step->kill();
  return FunctionUnary::kill();
}

bool FunctionMultiple::simplifieArgFunctionMultiple() {
  bool result = simplifieArgFunctionUnary();
  debut = debut->simplifie();
  fin = fin->simplifie();
  if(step)
    step = step->simplifie();
  return result && debut->isConstant() && fin->isConstant() && (step ? step->isConstant() : TRUE);
}

Function* FunctionMultiple::simplifie() {
  if(!simplifieArgFunctionMultiple()) return this;
	//Ici, cela veut dire que l'argument est constant.
	//On fait donc simple... on garde la constante de l'argument, modifiée, et on se supprime.
	cplx res = this->eval((dynamic_cast<Constante*>(argument))->valeur);
	kill();//On tue récursivement le noeud et son fils.
	return new Constante(res);//Et on retourne une nouvelle constante.
}

SommeMultiple::SommeMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin, Function* theStep)
	:FunctionMultiple(argument, theVar, theDebut, theFin, theStep) {
}
SommeMultiple::SommeMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin)
	:FunctionMultiple(argument, theVar, theDebut, theFin) {
}
cplx SommeMultiple::eval(cplx & z) {
	cplx resultat = 0;
  double d = debut->eval(z).real();
  double f = fin->eval(z).real();
  double s = step->eval(z).real();
  if( d*s > f*s || s == 0)
    return resultat;
	for(double k=d; k<=f; k+=s) {
		var->set(cplx(k,0));//Effet de bord, les sous-fonctions vont voir la variable changer.
		resultat += argument->eval(z);
	}
	return resultat;
}
cplx SommeMultiple::evalFast() {
	cplx resultat = 0;
  double d = debut->evalFast().real();
  double f = fin->evalFast().real();
  double s = step->evalFast().real();
  if( d*s > f*s || s == 0)
    return resultat;
	for(double k=d; k<=f; k+=s) {
		var->set(cplx(k,0));//Effet de bord, les sous-fonctions vont voir la variable changer.
		resultat += argument->evalFast();
	}
	return resultat;
}

ProduitMultiple::ProduitMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin, Function* theStep)
	:FunctionMultiple(argument, theVar, theDebut, theFin, theStep) {
}
ProduitMultiple::ProduitMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin)
	:FunctionMultiple(argument, theVar, theDebut, theFin) {
}
cplx ProduitMultiple::eval(cplx & z) {
	cplx resultat(1.0);
  double d = debut->eval(z).real();
  double f = fin->eval(z).real();
  double s = step->eval(z).real();
  if( d*s > f*s || s == 0)
    return resultat;
	for(double k=d; k<=f; k+=s) {
		var->set(cplx(k,0)); //Effet de bord, les sous-fonctions vont voir la variable changer.
		resultat*= argument->eval(z);
	}
	return resultat;
}
cplx ProduitMultiple::evalFast() {
	cplx resultat(1.0);
  double d = debut->evalFast().real();
  double f = fin->evalFast().real();
  double s = step->evalFast().real();
  if( d*s > f*s || s == 0)
    return resultat;
	for(double k=d; k<=f; k+=s) {
		var->set(cplx(k,0)); //Effet de bord, les sous-fonctions vont voir la variable changer.
		resultat*= argument->evalFast();
	}
	return resultat;
}

CompositionMultiple::CompositionMultiple(Function* argument, Variable *theVar, Function* theDebut, Function* theFin)
	:FunctionMultiple(argument, theVar, theDebut, theFin, NULL) {
}
cplx CompositionMultiple::eval(cplx & z) {
  var->set(debut->eval(z));
  double count = fin->eval(z).real();
  while (count > 0) {
    var->set(argument->eval(z));
    count--;
  }
	return var->evalFast();
}
cplx CompositionMultiple::evalFast() {
  var->set(debut->evalFast());
  double count = fin->evalFast().real();
  while (count > 0) {
    var->set(argument->evalFast());
    count--;
  }
	return var->evalFast();
}

//Implementation of variables.
void Variable::setNom(const TCHAR* theNom) {
	//Copy the name to the buffer.
	size_t taille = _tcslen(theNom);
	nom = new TCHAR[taille+1];
	memcpy(nom, theNom, sizeof(TCHAR)*taille);
	*(nom+taille)=L'\0';
}

Variable::~Variable() {
	delete [] nom;
}

VariableListe* VariableListe::get() {
	if(varList==NULL) {
		varList=new VariableListe();
	}
	return varList;
}

void VariableListe::killf() {
	if(!varList) return;
	Variable* temp=varList->tete;
	while(temp) {
		Variable *suivante=temp->prev();
		delete temp;	//il n'y a qu'ici qu'on a le droit de détruire les variables
		temp=suivante;
	}
	delete varList;
}

Variable* VariableListe::getVariable(TCHAR *nom){
	Variable* temp=varList->tete;
	while(temp) {
		if(_tcscmp(temp->nom, nom)==0)
			return temp;
		temp = temp->prec;
	}
	//Not found: lets create it.
	temp = new Variable(nom);
	temp->prec = varList->tete;
	varList->tete = temp;
	return temp;
}

VariableListe *VariableListe::varList=NULL;

// Les fonction toString:


TCHAR *Somme::toString(TCHAR *espace, TCHAR *finEspace) {
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L'+';
	espace = this->argument2->toString(espace, finEspace);
	return espace;
}

TCHAR *Soustraction::toString(TCHAR *espace, TCHAR *finEspace) {
	if(argument->priorite()<priorite() && espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(argument->priorite()<priorite() && espace!=finEspace) *(espace++)=L')';
	if(espace!=finEspace) *(espace++)=L'-';
	if(argument2->priorite()<=priorite() && espace!=finEspace) *(espace++)=L'(';
	espace = this->argument2->toString(espace, finEspace);
	if(argument2->priorite()<=priorite() && espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Multiplication::toString(TCHAR *espace, TCHAR *finEspace) {
	if(argument->priorite()<priorite() && espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(argument->priorite()<priorite() && espace!=finEspace) *(espace++)=L')';
	if(espace!=finEspace) *(espace++)=L'*';
	if(argument2->priorite()<priorite() && espace!=finEspace) *(espace++)=L'(';
	espace = this->argument2->toString(espace, finEspace);
	if(argument2->priorite()<priorite() && espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Division::toString(TCHAR *espace, TCHAR *finEspace) {
	if(argument->priorite()<priorite() && espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(argument->priorite()<priorite() && espace!=finEspace) *(espace++)=L')';
	if(espace!=finEspace) *(espace++)=L'/';
	if(argument2->priorite()<=priorite() && espace!=finEspace) *(espace++)=L'(';
	espace = this->argument2->toString(espace, finEspace);
	if(argument2->priorite()<=priorite() && espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *ExposantComplexe::toString(TCHAR *espace, TCHAR *finEspace) {
	if(espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	if(espace!=finEspace) *(espace++)=L'^';
	if(espace!=finEspace) *(espace++)=L'(';
	espace = this->argument2->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Compose::toString(TCHAR *espace, TCHAR *finEspace) {
	if(espace!=finEspace) *(espace++)=L'o';
	if(espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
	espace = this->argument2->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *CompositionRecursive::toString(TCHAR *espace, TCHAR *finEspace) {
	TCHAR nombre[256];
	if(espace!=finEspace) *(espace++)=L'o';
	if(espace!=finEspace) *(espace++)=L'o';
	if(espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
	_stprintf(nombre, TEXT("%d"), nbCompose);
	if(2*_tcslen(nombre)<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace,nombre);
	espace += _tcslen(nombre);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}


TCHAR *Exposant::toString(TCHAR *espace, TCHAR *finEspace) {
	TCHAR nombre[256];
	if(espace!=finEspace) *(espace++)=L'(';
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	if(espace!=finEspace) *(espace++)=L'^';
	_stprintf(nombre, TEXT("%d"), this->exposant);
	if(2*_tcslen(nombre)<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace,nombre);
	espace += _tcslen(nombre);
	return espace;
}

TCHAR *Constante::toString(TCHAR *espace, TCHAR *finEspace) {
	TCHAR nombre[256];
	this->valeur.toString(nombre);
  // if(_tcschr(nombre, L'#') != NULL) {
  //   *(espace++)=L'1';
  //   return espace;
  // }
	if((_tcschr(nombre, L'+')!=NULL || _tcschr(nombre, L'-')!=NULL)
      && espace != finEspace) *(espace++)=L'(';
	if(2*_tcslen(nombre)<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, nombre);
	espace+=_tcslen(nombre);
	if((_tcschr(nombre, L'+')!=NULL || _tcschr(nombre, L'-')!=NULL)
      && espace != finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Oppose::toString(TCHAR *espace, TCHAR *finEspace) {
	if(2*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("-("));
	espace+=2;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Sin::toString(TCHAR *espace, TCHAR *finEspace) {
	if(4*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("sin("));
	espace+=4;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Cos::toString(TCHAR *espace, TCHAR *finEspace) {
	if(4*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("cos("));
	espace+=4;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}
TCHAR *Tan::toString(TCHAR *espace, TCHAR *finEspace) {
	if(4*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("tan("));
	espace+=4;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Exp::toString(TCHAR *espace, TCHAR *finEspace) {
	if(4*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("exp("));
	espace+=4;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Cosh::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("cosh("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Sinh::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("sinh("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Tanh::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("tanh("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Ln::toString(TCHAR *espace, TCHAR *finEspace) {
	if(3*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("ln("));
	espace+=3;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Sqrt::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("sqrt("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Argsh::toString(TCHAR *espace, TCHAR *finEspace) {
	if(6*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("argsh("));
	espace+=6;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Argch::toString(TCHAR *espace, TCHAR *finEspace) {
	if(6*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("argch("));
	espace+=6;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Argth::toString(TCHAR *espace, TCHAR *finEspace) {
	if(6*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("argth("));
	espace+=6;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Arcsin::toString(TCHAR *espace, TCHAR *finEspace) {
	if(7*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("arcsin("));
	espace+=7;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Arccos::toString(TCHAR *espace, TCHAR *finEspace) {
	if(7*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("arccos("));
	espace+=7;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Arctan::toString(TCHAR *espace, TCHAR *finEspace) {
	if(7*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("arctan("));
	espace+=7;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Real::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("real("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Imag::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("imag("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Conj::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("conj("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Circle::toString(TCHAR *espace, TCHAR *finEspace) {
	if(7*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("circle("));
	espace+=7;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *Variable::toString(TCHAR *espace, TCHAR *finEspace) {
	if(2*_tcslen(this->nom)<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, nom);
	espace+=_tcslen(this->nom);
	return espace;
}

TCHAR *SommeMultiple::toString(TCHAR *espace, TCHAR *finEspace) {
	if(4*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("sum("));
	espace+=4;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
	espace = this->var->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->debut->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->fin->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->step->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *ProduitMultiple::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("prod("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
	espace = this->var->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->debut->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->fin->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->step->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
	return espace;
}

TCHAR *CompositionMultiple::toString(TCHAR *espace, TCHAR *finEspace) {
	if(5*2<(unsigned int)finEspace-(unsigned int)espace) _tcscpy(espace, TEXT("comp("));
	espace+=5;
	espace = this->argument->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
	espace = this->var->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->debut->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L',';
  espace = this->fin->toString(espace, finEspace);
	if(espace!=finEspace) *(espace++)=L')';
  return espace;
}