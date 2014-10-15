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

extern "C"
{
        int yyparse(void);
}

#include <stdio.h>
#include <string>
//#include "gen.hpp"
%}



%union
{
			char* str;
			int intconst;
}

//			Keyword Token Group
%token			ARRAY BEGINX CHR CONST DO DOWNTO
%token			ELSE ELSEIF END FOR FORWARD FUNCTION
%token			IF OF ORD PRED PROCEDURE READ
%token			RECORD REPEAT RETURN STOP SUCC THEN
%token			TO TYPE UNTIL VAR WHILE WRITE

 //			Identifier Token
%token	<str>		IDENTIFIER

 //			Operator Tokens
%left			OR AND
%right			NOT
%nonassoc		EQUAL DIAMOND LT LEQ GT GEQ
%left			PLUS MINUS
%left			TIMES DIVIDE MODULO
%right			NEG
%token			DOT COMMA COLON SEMI OPAREN CPAREN OBRACKET CBRACKET ASSIGN

 //			Constant Tokens
%token	<int>		OCTINTCONST HEXINTCONST DECINTCONST CHARCONST STRCONST

 //			Specify Start Token
 //			%start program

 //			Fix Op Precedence Later

%%
 // Program
program:       	const_decl_opt type_decl_opt var_decl_opt proc_or_func_decl_star block DOT
		;

const_decl_opt:
	|	const_decl // { gen_const_decl($1); }
		;

type_decl_opt:
	|	type_decl // { gen_type_decl($1); }
		;

var_decl_opt:
	|	var_decl // { gen_var_decl($1); }
		;


proc_or_func_decl_star:
	|	proc_or_func_decl_star proc_decl // { gen_proc_decl($2); }
	| 	proc_or_func_decl_star func_decl // { gen_func_decl($2); }
		;

		// Declarations

		// Constant Declarations

		// ConstantDecl
const_decl:	CONST const_decl_assign_list_plus
		;

const_decl_assign_list_plus:
		IDENTIFIER EQUAL exp SEMI // { gen_const_decl_assign($1, $3); }
	|	const_decl_assign_list_plus IDENTIFIER EQUAL exp SEMI // { gen_const_decl_assign($2, $4); }
		;

		// Procedure and Function Declarations

		// ProcedureDecl, type name may be iffy.
proc_decl:	PROCEDURE IDENTIFIER OPAREN formal_parameters CPAREN SEMI SEMI FORWARD SEMI
		// Place SEMI here for compliance.
		// File Github bug report.
	|	PROCEDURE IDENTIFIER OPAREN formal_parameters CPAREN SEMI body SEMI
		;

// FunctionDecl
func_decl: 	FUNCTION IDENTIFIER OPAREN formal_parameters CPAREN COLON typex SEMI FORWARD SEMI
	|	FUNCTION IDENTIFIER OPAREN formal_parameters CPAREN COLON typex SEMI body SEMI
		;

// FormalParameters
formal_parameters:
	|	var_opt ident_list COLON typex remaining_fp_list_star
		;

remaining_fp_list_star:
	|	remaining_fp_list_star SEMI var_opt ident_list COLON typex
		;

var_opt:
	|	VAR
		;

// Body
body:		const_decl_opt type_decl_opt var_decl_opt block
		;

// Block
block:		BEGINX statement_sequence END
		;

// Type Declarations

// TypeDecl
type_decl:	TYPE type_decl_list_plus
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
simple_type:	IDENTIFIER
		;

// RecordType
record_type: 	RECORD record_ident_type_list_star END
		;

record_ident_type_list_star:
	|	record_ident_type_list_star ident_list COLON typex SEMI
;

// ArrayType
array_type:	ARRAY OBRACKET exp COLON exp CBRACKET OF typex
		;

// IdentList, could combine with rule below.
ident_list:	IDENTIFIER ident_list_remainder_star
		;

ident_list_remainder_star: 
	|	ident_list_remainder_star COMMA IDENTIFIER
;

// Variable Declarations

// VarDecl
var_decl:	VAR var_decl_list_plus
		;

var_decl_list_plus:
		ident_list COLON typex SEMI
	|	var_decl_list_plus ident_list COLON typex SEMI
;

// CPSL Statements

// StatementSequence
// May be bugged.
statement_sequence:
		statement_sequence_star	statement
		;

statement_sequence_star:
	|	statement_sequence_star SEMI statement
;

		// Statement, add internal comments.
statement:
		// Assignment
		l_value ASSIGN exp { printf("Assignment parsed.\n"); }
		// IfStatement
	|	IF exp THEN statement_sequence elseif_list_star else_statement_opt END
		// WhileStatement
	|	WHILE exp DO statement_sequence END
		// RepeatStatement
	|	REPEAT statement_sequence UNTIL exp
		// ForStatement
	|	FOR IDENTIFIER ASSIGN exp to_or_downto exp DO statement_sequence END
		// StopStatement
	|	STOP
		// ReturnStatement
	|	RETURN exp_opt
		// ReadStatement
	|	READ OPAREN l_value rs_l_value_star CPAREN
		// WriteStatement
	|	WRITE OPAREN exp wr_exp_star CPAREN
		// ProcedureCall
	| 	IDENTIFIER OPAREN pc_exp_list_opt CPAREN
		// NullStatement
	|
		;

elseif_list_star:
	|	elseif_list_star ELSEIF exp THEN statement_sequence
		;

else_statement_opt:
	|	ELSE statement_sequence
		;

to_or_downto:	TO
	|	DOWNTO
		;

exp_opt:	
	|	exp
		;

rs_l_value_star:
	|	rs_l_value_star COMMA l_value
		;

wr_exp_star:
	|	wr_exp_star COMMA exp
		;

pc_exp_list_opt:
	|	exp pc_exp_star
		;

pc_exp_star:
	|	pc_exp_star COMMA exp
		;

// Expressions
exp:		exp OR exp
		//		{ gen_exp_or($1, $3); }

	|	exp AND exp
		//		{ gen_exp_and($1, $3); }

	|	exp EQUAL exp
		//{ gen_exp_equal($1, $3); }

	|	exp DIAMOND exp
		//{ gen_exp_diamond($1, $3); }

	|	exp LEQ exp
		//{ gen_exp_leq($1, $3); }

	|	exp GEQ exp
		//{ gen_exp_geq($1, $3); }

	|	exp LT exp
		//{ gen_exp_lt($1, $3); }

	|	exp GT exp
		//{ gen_exp_gt($1, $3); }

	|	exp PLUS exp
		//{ gen_exp_plus($1, $3); }

	|	exp MINUS exp
		//{ gen_exp_minus($1, $3); }

	|	exp TIMES exp
		//{ gen_exp_times($1, $3); }

	|	exp DIVIDE exp
		//{ gen_exp_divide($1, $3); }

	|	exp MODULO exp
		//{ gen_exp_modulo($1, $3); }

	|	NOT exp
		//{ gen_exp_not($2); }

	|	MINUS %prec NEG exp
		//{ gen_exp_neg($2); }

	|	OPAREN exp CPAREN
		// { gen_exp_paren($2); }

		// Function/Procedure Call
	|	IDENTIFIER OPAREN exp_star_opt CPAREN
		// { gen_exp_or($1, $3); }

	|	CHR exp
	// { gen_exp_chr($2); }

	|	ORD exp
	// { gen_exp_ord($2); }

	|	PRED exp
	// { gen_exp_pred($2); }

	|	SUCC exp
	// { gen_exp_succ($2); }

	|	l_value
		//{ gen_l_value($1); }

// The following are tentative.
	|	OCTINTCONST
		//{ gen_octintconst($1); }

	|	HEXINTCONST
		//{ gen_hexintconst($1); }

	|	DECINTCONST
		//{ gen_decintconst($1); }

	|	CHARCONST
		//{ gen_charconst($1); }

	|	STRCONST
		//{ gen_strconst($1); }
;

// LValue
l_value:
		IDENTIFIER l_value_dot_star
		;

exp_star_opt:
	|	exp exp_star
		;

exp_star:
	|	exp_star COMMA exp
		;

l_value_dot_star:
	|	l_value_dot_star dot_identifier_or_index
		;

dot_identifier_or_index:
		DOT IDENTIFIER
	|	OBRACKET exp CBRACKET
;

// I need to remember to add the op precedence.

%%

//extern FILE* yyin;

yyerror(prbstr)
{
    // Put in a Haiku error later.
    printf("Error detected: %s .\n\n\tIf at first you don't succeed, give up and let a human handle it. -- PCMCPSL\n\n", prbstr);
}
