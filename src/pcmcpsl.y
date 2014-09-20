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

  //#include<stdio.h>

  //Remove this later.
  //int here = 0;
%}

//			Keyword Token Group
%token ARRAY BEGIN CHR CONST DO DOWNTO
%token ELSE ELSEIF END FOR FORWARD FUNCTION
%token IF OF ORD PRED PROCEDURE READ
%token RECORD REPEAT RETURN STOP SUCC THEN
%token TO TYPE UNTIL VAR WHILE WRITE

//			Identifier Token
%token IDENTIFIER

//			Operator Tokens
%token PLUS MINUS TIMES DIVIDE AND OR NOT EQUAL
%token DIAMOND LT LEQ GT GEQ DOT COMMA COLON
%token SEMI OPAREN CPAREN OBRACKET CBRACKET ASSIGN

//			Constant Tokens
%token OCTINTCONST HEXINTCONST DECINTCONST CHARCONST STRCONST

%%
// Program
program:
		const_decl_opt type_decl_opt var_decl_opt proc_or_func_decl_star block
		;

const_decl_opt:
		const_decl
	|	
		;

type_decl_opt:
		type_decl
	|
		;

var_decl_opt:
		var_decl
	|
		;


proc_or_func_decl_star:
		proc_or_func_decl_star proc_decl
	| 	proc_or_func_decl_star func_decl
	| 
		;

// Declarations

// Constant Declarations

// ConstantDecl
const_decl:
		CONST const_decl_assign_list_plus
		;

const_decl_assign_list_plus:
		const_decl_assign_list_plus IDENTIFIER EQUAL expression SEMI
	|	IDENTIFIER EQUAL expression COMMA
		;

// Procedure and Function Declarations

// ProcedureDecl, type name may be iffy.
proc_decl:	
		PROCEDURE IDENTIFIER OPAREN formal_parameters CPAREN SEMI FORWARD SEMI
	|	PROCEDURE IDENTIFIER OPAREN formal_parameters CPAREN SEMI body SEMI
	;

// FunctionDecl
func_decl:	
		FUNCTION IDENTIFIER OPAREN formal_parameters CPAREN COLON type SEMI FORWARD SEMI
	|	FUNCTION IDENTIFIER OPAREN formal_parameters CPAREN COLON type SEMI body SEMI
	;

// FormalParameters
formal_parameters:
		var_opt ident_list COLON type remaining_fp_list_star
	|	
	;

remaining_fp_list_star:
		remaining_fp_list_star SEMI var_opt ident_list COLON type
	|	
	;

var_opt:	
		VAR
	|	
	;

// Body
body:		
		const_decl_opt type_decl_opt var_decl_opt block
	;

// Block
block:		
		BEGIN statement_sequence END
	;

// Type Declarations

// TypeDecl
type_decl:	
		TYPE type_decl_list_plus
	;

type_decl_list_plus:
		type_decl_list_plus IDENTIFIER EQUAL type SEMI
	|	IDENTIFIER EQUAL type SEMI
	;

// Type (do not confuse with the terminal TYPE)
type:		
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
		record_ident_type_list_star ident_list COLON type SEMI
	|	
	;

// ArrayType
array_type:	
		ARRAY OBRACKET expression COLON expression CBRACKET OF type
	;

// IdentList
ident_list:	
		IDENTIFIER ident_list_remainder_star
	;

ident_list_remainder_star:
		ident_list_remainder_star COMMA IDENTIFIER
	;

// Variable Declarations

// VarDecl
var_decl:	
		VAR var_decl_list_plus
	;

var_decl_list_plus:
		var_decl_list_plus ident_list COLON type SEMI
	|	ident_list COLON type SEMI
	;

// CPSL Statements

// StatementSequence
statement_sequence:
		statement statement_sequence_remainder_star
	;

statement_sequence_remainder_star:
		statement_sequence_remainder_star SEMI statement
	|	
	;

// Statement
statement:	
		assignment
	|	if_statement
	|	while_statement
	|	repeat_statement
	|	for_statement
	|	stop_statement
	|	return_statement
	|	read_statement
	|	write_statement
	|	procedure_call
	|	null_statement
		;

// Assignment
assignment:	
		l_value ASSIGN expression
	;

// IfStatement
if_statement:	
		IF expression THEN statement_sequence elseif_list_star else_statement_opt END
	;

elseif_list_star:
		elseif_list_star ELSEIF expression THEN statement_sequence
	|	
	;

else_statement_opt:
		ELSE statement_sequence
	|	
	;

// WhileStatement
while_statement:
		WHILE expression DO statement_sequence END
	;

// RepeatStatement
repeat_statement:
		REPEAT statement_sequence UNTIL expression
	;

// ForStatement
for_statement:	
		FOR IDENTIFIER ASSIGN expression to_or_downto expression DO statement_sequence END
	;

to_or_downto:
		TO
	|	DOWNTO
	;

// StopeStatement
stop_statement:	
		STOP
	;

// ReturnStatement
return_statement:
		RETURN expression_opt
	;

expression_opt:	
		expression
	|	
	;

// ReadStatement
read_statement:	
		READ OPAREN l_value read_statement_l_value_remainder_star CPAREN
	;

read_statement_l_value_remainder_star:
		read_statement_l_value_remainder_star COMMA l_value
	|	
	;

// WriteStatement, move all other statement to new list notation.
write_statement:
		WRITE OPAREN expression wr_expression_star CPAREN
	;

wr_expression_star:
		wr_expression_star COMMA expression
	|	
	;

// ProcedureCall
procedure_call:	
		IDENTIFIER OPAREN pc_expression_list_opt CPAREN
	;

pc_expression_list_opt:
		expression pc_expression_star
	|	
	;

pc_expression_star:
		pc_expression_star COMMA expression
	|	
	;

// NullStatement
null_statement:	
		
	;
%%

//extern FILE* yyin;

main()
{
  yyparse();
}

yyerror(prbstr)
{
    // Put in a Haiku error later.
    printf("Error detected.\n\n\tIf at first you don't succeed, give up and let a human handle it. -- PCMCPSL");
}
