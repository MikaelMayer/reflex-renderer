/*******************************
 * Name:	functionFactory.h
 * Author:	Mikaël Mayer
 * Purpose:	Creates functions factories for several functions.
 * History: Work started 20080910
 *********************************/


#ifndef FUNCTION_FACTORY_H
#define FUNCTION_FACTORY_H

#include "functions.h"

class FunctionFactory {
public:
  virtual Function* create(Function *argument1)=0;
};

class SinFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Sin(argument1); }
};

class CosFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Cos(argument1); }
};

class TanFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Tan(argument1); }
};

class ExpFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Exp(argument1); }
};

class SinhFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Sinh(argument1); }
};

class CoshFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Cosh(argument1); }
};

class TanhFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Tanh(argument1); }
};

class LnFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Ln(argument1); }
};

class SqrtFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Sqrt(argument1); }
};

class ArgshFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Argsh(argument1); }
};

class ArgchFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Argch(argument1); }
};

class ArgthFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Argth(argument1); }
};

class ArcsinFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Arcsin(argument1); }
};

class ArccosFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Arccos(argument1); }
};

class ArctanFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Arctan(argument1); }
};

class RealFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Real(argument1); }
};

class ImagFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Imag(argument1); }
};

class CircleFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Circle(argument1); }
};

class ConjFactory: public FunctionFactory {
  Function* create(Function *argument1) { return new Conj(argument1); }
};

#endif //FUNCTION_FACTORY_H