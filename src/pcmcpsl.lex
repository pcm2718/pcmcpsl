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
    This is the Lex file for the lexical analysis phase of CPSL.
  */

  /*
    [^\n\t ]*                       { printf("Unknown lexeme detected on line %i: %s .\n", linenum, yytext); }
  */

  /*
    Declare the line counter and initalize it to zero.
  */
  unsigned int linenum = 1;
%}  
%%

'([ -\[]|[\]-~]|(\\[ -~]))'                                     { printf("Character constant detected: %s .\n", yytext); }

\"([ -!]|[#-\[]|[\]-~]|(\\([ -!]|[#-~])))*\"                    { printf("String constant detected: %s .\n", yytext); }

[\t ]+                                                          /* Ignore (consume) whitespace. */ ;

array |
ARRAY                                                           { printf("Keyword detected: ARRAY .\n"); }

begin |
BEGIN                                                           { printf("Keyword detected: BEGIN .\n"); }

chr |
CHR                                                             { printf("Keyword detected: CHR .\n"); }

const |
CONST                                                           { printf("Keyword detected: CONST .\n"); }

do |
DO                                                              { printf("Keyword detected: DO .\n"); }

downto |
DOWNTO                                                          { printf("Keyword detected: DOWNTO .\n"); }

else |
ELSE                                                            { printf("Keyword detected: ELSE .\n"); }

elseif |
ELSEIF                                                          { printf("Keyword detected: ELSEIF .\n"); }

end |
END                                                             { printf("Keyword detected: END .\n"); }

for |
FOR                                                             { printf("Keyword detected: FOR .\n"); }

forward |
FORWARD                                                         { printf("Keyword detected: FORWARD .\n"); }

function |
FUNCTION                                                        { printf("Keyword detected: FUNCTION .\n"); }

if |
IF                                                              { printf("Keyword detected: IF .\n"); }

of |
OF                                                              { printf("Keyword detected: OF .\n"); }

ord |
ORD                                                             { printf("Keyword detected: ORD .\n"); }

pred |
PRED                                                            { printf("Keyword detected: PRED .\n"); }

procedure |
PROCEDURE                                                       { printf("Keyword detected: PROCEDURE .\n"); }

read |
READ                                                            { printf("Keyword detected: READ .\n"); }

record |
RECORD                                                          { printf("Keyword detected: RECORD .\n"); }

repeat |
REPEAT                                                          { printf("Keyword detected: REPEAT .\n"); }

return |
RETURN                                                          { printf("Keyword detected: RETURN .\n"); }

stop |
STOP                                                            { printf("Keyword detected: STOP .\n"); }

succ |
SUCC                                                            { printf("Keyword detected: SUCC .\n"); }

then |
THEN                                                            { printf("Keyword detected: THEN .\n"); }

to |
TO                                                              { printf("Keyword detected: TO .\n"); }

type |
TYPE                                                            { printf("Keyword detected: TYPE .\n"); }

until |
UNTIL                                                           { printf("Keyword detected: UNTIL .\n"); }

var |
VAR                                                             { printf("Keyword detected: VAR .\n"); }

while |
WHILE                                                           { printf("Keyword detected: WHILE .\n"); }

write |
WRITE                                                           { printf("Keyword detected: WRITE .\n"); }

[a-zA-Z][0-9a-zA-Z_]*                                           { printf("Identifier detected: %s .\n", yytext); }

\+                                                              { printf("Operator or delimiter detected: + .\n"); }

\-                                                              { printf("Operator or delimiter detected: - .\n"); }

\*                                                              { printf("Operator or delimiter detected: * .\n"); }

\/                                                              { printf("Operator or delimiter detected: / .\n"); }

&                                                               { printf("Operator or delimiter detected: & .\n"); }

\                                                               { printf("Operator or delimiter detected: \\ .\n"); }

~                                                               { printf("Operator or delimiter detected: ~ .\n"); }

=                                                               { printf("Operator or delimiter detected: = .\n"); }

\<\>                                                            { printf("Operator or delimiter detected: <> .\n"); }

\<                                                              { printf("Operator or delimiter detected: < .\n"); }

\<=                                                             { printf("Operator or delimiter detected: <= .\n"); }

\>                                                              { printf("Operator or delimiter detected: > .\n"); }

\>=                                                             { printf("Operator or delimiter detected: >= .\n"); }

\.                                                              { printf("Operator or delimiter detected: . .\n"); }

,                                                               { printf("Operator or delimiter detected: , .\n"); }

:                                                               { printf("Operator or delimiter detected: : .\n"); }

;                                                               { printf("Operator or delimiter detected: ; .\n"); }

\(                                                              { printf("Operator or delimiter detected: ( .\n"); }

\)                                                              { printf("Operator or delimiter detected: ) .\n"); }

\[                                                              { printf("Operator or delimiter detected: [ .\n"); }

\]                                                              { printf("Operator or delimiter detected: ] .\n"); }

:=                                                              { printf("Operator or delimiter detected: := .\n"); }

%                                                               { printf("Operator or delimiter detected: %% .\n"); }

0[0-7]+                                                         { printf("Integer constant, octal, detected: %s .\n", yytext); }

0x[0-9a-fA-F]+                                                  { printf("Integer constant, hexadecimal, detected: %s .\n", yytext); }

[0-9]+                                                          { printf("Integer constant, decimal, detected: %s .\n", yytext); }

$[^\n]*                                                         { printf("Comment ignored: %s .\n", yytext); } 

\n                                                              { ++linenum; }

.                                                               { printf("Unknown lexeme detected on line %i: %s .\n", linenum, yytext); }
%%

main ()
{
  yylex();
}
