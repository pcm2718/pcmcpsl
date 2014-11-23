#ifndef EXPRESSIONS_HPP
#define EXPRESSIONS_HPP

#include <memory>
#include <stack>

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

void emitIfControl(Expr * a);
void emitElseIfLabel();
void emitElseIfControl(Expr * a);
void emitElseLabel();
void emitFiJump();
void emitFiLabel();

void emitRepeatLabel();
void emitRepeatControl(Expr * a);

void emitWhileTopLabel();
void emitWhileControl(Expr * a);
void emitWhileJump();
void emitWhileBottomLabel();

class ForLoop
{
public:

  static std::shared_ptr<ForLoop> get_instance();

  static void init();
  static void deinit();

  void emit_init(Expr* a);
  void emit_top_label();
  void emit_control(Expr* a);
  void emit_rement();
  void emit_jump();
  void emit_bottom_label();
  //void emit_deinit();


  static int forcounter;
  static std::stack<std::shared_ptr<ForLoop>> forcurrent;

  int fornum;
  std::string id;
  int dir;


private:

  ForLoop();
};
#endif
