%{
  /*
    Copyright 2014 Parker Michaelson

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
  */

  /*
    This is the yacc file for the syntax analysis phase of PCMCPSL.
  */

  #include<stdio.h>

  //Remove this later.
  //int here = 0;
%}



//			Keyword Token Group
%token ARRAY BEGINX CHR CONST DO DOWNTO
%token ELSE ELSEIF END FOR FORWARD FUNCTION
%token IF OF ORD PRED PROCEDURE READ
%token RECORD REPEAT RETURN STOP SUCC THEN
%token TO TYPE UNTIL VAR WHILE WRITE

//			Identifier Token
%token IDENTIFIER

//			Operator Tokens
%left OR AND
%right NOT
%nonassoc EQUAL DIAMOND LT LEQ GT GEQ
%left PLUS MINUS
%left TIMES DIVIDE MODULO
%right NEG
%token DOT COMMA COLON SEMI OPAREN CPAREN OBRACKET CBRACKET ASSIGN

//			Constant Tokens
%token OCTINTCONST HEXINTCONST DECINTCONST CHARCONST STRCONST

//			Specify Start Token
//			%start program

//			Fix Op Precedence Later

%%
// Program
program:
		const_decl_opt { printf("Program ConstDecl parsed.\n"); } type_decl_opt { printf("Program TypeDecl parsed.\n"); } var_decl_opt { printf("Program VarDecl parsed.\n"); } proc_or_func_decl_star { printf("Program ProcDecl and FuncDecl parsed.\n"); } block { printf("Program Block parsed.\n"); } DOT { printf("Program parsed.\n"); }
		;

const_decl_opt:
		%empty { printf("Program or Body has no ConstDecl.\n"); }
	|	const_decl
		;

type_decl_opt:
		%empty { printf("Program or Body has no TypeDecl.\n"); }
	|	type_decl
		;

var_decl_opt:
		%empty { printf("Program or Body has no VarDecl.\n"); }
	|	var_decl
		;


proc_or_func_decl_star:
		%empty
	|	proc_or_func_decl_star proc_decl { printf("Program has ProcDecl.\n"); }
	| 	proc_or_func_decl_star func_decl { printf("Program has FuncDecl.\n"); }
		;

// Declarations

// Constant Declarations

// ConstantDecl
const_decl:
		CONST const_decl_assign_list_plus { printf("ConstDecl parsed.\n"); }
		;

const_decl_assign_list_plus:
		IDENTIFIER EQUAL exp SEMI
	|	const_decl_assign_list_plus IDENTIFIER EQUAL exp SEMI
		;

// Procedure and Function Declarations

// ProcedureDecl, type name may be iffy.
proc_decl:
		PROCEDURE IDENTIFIER OPAREN formal_parameters CPAREN SEMI { printf("Procedure FormalParameters parsed.\n"); } SEMI FORWARD SEMI { printf("ProcDecl parsed.\n"); }
		// Place SEMI here for compliance.
		// File Github bug report.
	|	PROCEDURE IDENTIFIER OPAREN formal_parameters CPAREN SEMI { printf("Procedure FormalParameters parsed.\n"); } body SEMI { printf("ProcDecl parsed.\n"); }
		;

// FunctionDecl
func_decl:
		FUNCTION IDENTIFIER OPAREN formal_parameters CPAREN COLON typex SEMI FORWARD SEMI { printf("FuncDecl parsed.\n"); }
	|	FUNCTION IDENTIFIER OPAREN formal_parameters CPAREN COLON typex SEMI body SEMI { printf("FuncDecl parsed.\n"); }
		;

// FormalParameters
formal_parameters:
		%empty
	|	var_opt ident_list COLON typex { printf("FormalParameters parameter parsed.\n"); } remaining_fp_list_star { printf("FormalParameters parsed.\n"); };
		;

remaining_fp_list_star:
		%empty		
	|	remaining_fp_list_star SEMI var_opt ident_list COLON typex { printf("FormalParameters parameter parsed.\n"); }
		;

var_opt:	
		%empty
	|	VAR
		;

// Body
body:		
		const_decl_opt type_decl_opt var_decl_opt block { printf("Body parsed.\n"); }
		;

// Block
block:
		BEGINX statement_sequence END { printf("Block parsed.\n"); }
		;

// Type Declarations

// TypeDecl
type_decl:	
		TYPE type_decl_list_plus
		;

type_decl_list_plus:
		type_decl_list_plus IDENTIFIER EQUAL typex SEMI
	|	IDENTIFIER EQUAL typex SEMI
		;

// Type (do not confuse with the terminal TYPE)
typex:		
		simple_type
	|	record_type
	|	array_type
		;

// SimpleType
simple_type:	
		IDENTIFIER
		;

// RecordType
record_type:
		RECORD record_ident_type_list_star END
		;

record_ident_type_list_star:
		%empty
	|	record_ident_type_list_star ident_list COLON typex SEMI
		;

// ArrayType
array_type:	
		ARRAY OBRACKET exp COLON exp CBRACKET OF typex
		;

// IdentList, could combine with rule below.
ident_list:
		IDENTIFIER ident_list_remainder_star { printf("IdentList identifier parsed.\nIdentList parsed.\n"); }
		;

ident_list_remainder_star: 
		%empty
	|	ident_list_remainder_star COMMA IDENTIFIER { printf("IdentList identifier parsed.\n"); }
		;

// Variable Declarations

// VarDecl
var_decl:
		VAR var_decl_list_plus { printf("VarDecl parsed.\n"); }
		;

var_decl_list_plus:
		ident_list COLON typex SEMI { printf("VarDecl group parsed.\n" ); }
	|	var_decl_list_plus ident_list COLON typex SEMI { printf("VarDecl group parsed.\n" ); }
		;

// CPSL Statements

// StatementSequence
statement_sequence:
		statement_sequence_star	statement SEMI { printf("StatementSequence statement parsed.\nStatementSequence parsed.\n"); }
		;

statement_sequence_star:
		%empty
	|	statement_sequence_star statement SEMI { printf("StatementSequence statement parsed.\n"); }
		;

// Statement, add internal comments.
statement:	
		// Assignment
		l_value ASSIGN exp { printf("Assignment parsed.\n"); }
		// IfStatement
	|	IF exp { printf("IfStatement conditional Expression parsed.\n"); } THEN statement_sequence { printf("IfStatement Statements parsed.\n"); } elseif_list_star { printf("IfStatement ElseIfStatement parsed.\n"); } else_statement_opt { printf("IfStatement ElseStatment parsed.\n"); } END { printf("IfStatement parsed.\n"); }
		// WhileStatement
	|	WHILE exp DO statement_sequence END { printf("WhileStatement parsed.\n"); }
		// RepeatStatement
	|	REPEAT statement_sequence UNTIL exp { printf("RepeatStatement parsed.\n"); }
		// ForStatement
	|	FOR IDENTIFIER ASSIGN exp to_or_downto exp DO statement_sequence END { printf("ForStatement parsed.\n"); }
		// StopStatement
	|	STOP { printf("StopStatement parsed.\n"); }
		// ReturnStatement
	|	RETURN exp_opt { printf("ReturnStatement parsed.\n"); }
		// ReadStatement
	|	READ OPAREN l_value rs_l_value_star CPAREN { printf("ReadStatement parsed.\n"); }
		// WriteStatement
	|	WRITE OPAREN exp wr_exp_star CPAREN { printf("WriteStatement parsed.\n"); }
		// ProcedureCall
	| 	IDENTIFIER OPAREN pc_exp_list_opt CPAREN { printf("ProcedureCall parsed.\n"); }
		// NullStatement
	|	%empty { printf("NullStatement parsed.\n"); }
		;

elseif_list_star:
		%empty
	|	elseif_list_star ELSEIF exp THEN statement_sequence { printf("ElseIfStatement Statement parsed.\n"); }
		;

else_statement_opt:
		%empty
	|	ELSE statement_sequence { printf("ElseStatement Statement parsed.\n"); }
		;

to_or_downto:
		TO
	|	DOWNTO
		;

exp_opt:	
		%empty
	|	exp
		;

rs_l_value_star:
		%empty
	|	rs_l_value_star COMMA l_value
		;

wr_exp_star:
		%empty
	|	wr_exp_star COMMA exp
		;

pc_exp_list_opt:
		%empty
	|	exp pc_exp_star
		;

pc_exp_star:
		%empty
	|	pc_exp_star COMMA exp
		;

// Expressions, fix the exp hack later.
exp:		
		e { printf("Expression parsed.\n"); }
	;
e:		
		exp OR exp
	|	exp AND exp
	|	exp EQUAL exp
	|	exp DIAMOND exp
	|	exp LEQ exp
	|	exp GEQ exp
	|	exp LT exp
	|	exp GT exp
	|	exp PLUS exp
	|	exp MINUS exp
	|	exp TIMES exp
	|	exp DIVIDE exp
	|	exp MODULO exp
	|	NOT exp
	|	MINUS %prec NEG exp
	|	OPAREN exp CPAREN
	|	IDENTIFIER OPAREN exp_star_opt CPAREN
	|	CHR exp
	|	ORD exp
	|	PRED exp
	|	SUCC exp
	|	l_value
		// The following are tentative.
	|	OCTINTCONST
	|	HEXINTCONST
	|	DECINTCONST
	|	CHARCONST
	|	STRCONST
		;

// LValue
l_value:	
		IDENTIFIER l_value_dot_star { printf("LValue parsed.\n"); }
	;

exp_star_opt:
		%empty
	|	exp exp_star
		;

exp_star:
		%empty
	|	exp_star COMMA exp
		;

l_value_dot_star:
		%empty
	|	l_value_dot_star dot_identifier_or_index
		;

dot_identifier_or_index:
		DOT IDENTIFIER
	|	OBRACKET exp CBRACKET
		;

// I need to remember to add the op precedence.

%%

//extern FILE* yyin;

main()
{
    yyparse();
}

yyerror(prbstr)
{
    // Put in a Haiku error later.
    printf("Error detected: %s .\n\n\tIf at first you don't succeed, give up and let a human handle it. -- PCMCPSL\n\n", prbstr);
}
