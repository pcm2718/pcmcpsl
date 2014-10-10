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
    This is the Lex file for the lexical analysis phase of PCMCPSL.
  */

  /*
    [^\n\t ]*                       { printf("Unknown lexeme detected on line %i: %s .\n", linenum, yytext); }
  */

  /*
    Include the yacc generated header.
  */
  #include "pcmcpsl.tab.h"

  /*
    Declare the line counter and initalize it to zero.
  */
  unsigned int linenum = 1;
%}  
%%

'([ -\[]|[\]-~]|(\\[ -~]))'                                     { return CHARCONST; }

\"([ -!]|[#-\[]|[\]-~]|(\\([ -!]|[#-~])))*\"                    { return STRCONST; }

[\t ]+                                                          /* Ignore (consume) whitespace. */ ;

array |
ARRAY                                                           { return ARRAY; }

begin |
BEGIN                                                           { return BEGINX; }

chr |
CHR                                                             { return CHR; }

const |
CONST                                                           { return CONST; }

do |
DO                                                              { return DO; }

downto |
DOWNTO                                                          { return DOWNTO; }

else |
ELSE                                                            { return ELSE; }

elseif |
ELSEIF                                                          { return ELSEIF; }

end |
END                                                             { return END; }

for |
FOR                                                             { return FOR; }

forward |
FORWARD                                                         { return FORWARD; }

function |
FUNCTION                                                        { return FUNCTION; }

if |
IF                                                              { return IF; }

of |
OF                                                              { return OF; }

ord |
ORD                                                             { return ORD; }

pred |
PRED                                                            { return PRED; }

procedure |
PROCEDURE                                                       { return PROCEDURE; }

read |
READ                                                            { return READ; }

record |
RECORD                                                          { return RECORD; }

repeat |
REPEAT                                                          { return REPEAT; }

return |
RETURN                                                          { return RETURN; }

stop |
STOP                                                            { return STOP; }

succ |
SUCC                                                            { return SUCC; }

then |
THEN                                                            { return THEN; }

to |
TO                                                              { return TO; }

type |
TYPE                                                            { return TYPE; }

until |
UNTIL                                                           { return UNTIL; }

var |
VAR                                                             { return VAR; }

while |
WHILE                                                           { return WHILE; }

write |
WRITE                                                           { return WRITE; }

[a-zA-Z][0-9a-zA-Z_]*                                           { return IDENTIFIER; }

\+                                                              { return PLUS; }

\-                                                              { return MINUS; }

\*                                                              { return TIMES; }

\/                                                              { return DIVIDE; }

&                                                               { return AND; }

\|                                                              { return OR; }

~                                                               { return NOT; }

=                                                               { return EQUAL; }

\<\>                                                            { return DIAMOND; }

\<                                                              { return LT; }

\<=                                                             { return LEQ; }

\>                                                              { return GT; }

\>=                                                             { return GEQ; }

\.                                                              { return DOT; }

,                                                               { return COMMA; }

:                                                               { return COLON; }

;                                                               { return SEMI; }

\(                                                              { return OPAREN; }

\)                                                              { return CPAREN; }

\[                                                              { return OBRACKET; }

\]                                                              { return CBRACKET; }

:=                                                              { return ASSIGN; }

%                                                               { return MODULO; }

0[0-7]+                                                         { return OCTINTCONST; }

0x[0-9a-fA-F]+                                                  { return HEXINTCONST; }

[0-9]+                                                          { return DECINTCONST; }

$[^\n]*                                                         { } 

\n                                                              { ++linenum; }

.                                                               { printf("Unknown lexeme detected on line %i: %s .\n", linenum, yytext); yyerror(yytext); }
%%
