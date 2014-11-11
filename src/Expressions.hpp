#ifndef EXPRESSIONS_HPP
#define EXPRESSIONS_HPP

#include <memory>

class Register;
class Type;

struct Expr
{
  std::shared_ptr<Type> type;
  std::shared_ptr<Register> reg;
};

struct MemoryLocation
{
  int offset;
  std::shared_ptr<Register> base;
  std::shared_ptr<Type> type;
};

Expr * emitOr(Expr * a, Expr * b);
Expr * emitAnd(Expr * a, Expr * b);
Expr * emitEq(Expr * a, Expr * b);
Expr * emitNeq(Expr * a, Expr * b);
Expr * emitLte(Expr * a, Expr * b);
Expr * emitGte(Expr * a, Expr * b);
Expr * emitLt(Expr * a, Expr * b);
Expr * emitGt(Expr * a, Expr * b);
Expr * emitAdd(Expr * a, Expr * b);
Expr * emitSub(Expr * a, Expr * b);
Expr * emitMult(Expr * a, Expr * b);
Expr * emitDiv(Expr * a, Expr * b);
Expr * emitMod(Expr * a, Expr * b);
Expr * emitNot(Expr * a);
Expr * emitNeg(Expr * a);
Expr * chr(Expr * a);
Expr * ord(Expr * a);
Expr * pred(Expr * a);
Expr * succ(Expr * a);
Expr * load(MemoryLocation * a);
Expr * load(char * a);
Expr * load(char a);
Expr * load(int a);
void store(MemoryLocation * loc, Expr * val);
void write(Expr * a);
void read(MemoryLocation * loc);

void emitRepeatLabel();
void emitRepeatControl(Expr * a);

void emitWhileTopLabel();
void emitWhileControl(Expr * a);
void emitWhileJump();
void emitWhileBottomLabel();

void emitIfControl(Expr * a);
void emitElseIfControl(Expr * a);
void emitElseLabel();
void emitFiJump();
void emitFiLabel();
#endif
