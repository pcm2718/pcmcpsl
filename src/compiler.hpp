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
  compiler.hpp provides the declaration for the Compiler class.
*/

#include <string>



/*
  Compiler is a class encapsulating all of the proper compiler
  functionality of PCMCPSL.
*/

class Compiler
{
private:

  /*
    String storing the input source code.
  */
  std::string incode;


  /*
    String storing the output mips code.
  */
  std::string outcode;

  /*
    The flag indicating whether parsing-phase optimization is
    enabled.
  */
  bool popt_p;

  /*
    The flag indicating whether normal (semantic-phase) optimization
    is enabled.
  */
  bool sopt_p;

  /*
    The flag indicating whether experimental optimizations are
    enabled.
  */
  bool xopt_p;

  /*
    The flag indicating whether outcode should be annotated with
    machine generated comments.
  */
  bool annotate_p;

  // AST
  // ASTNode & ;

  // ASTNode should perhaps have a wrapper at the top level called
  // AST, which would provide some sort of iterator. This may
  // interfere with optimization.

  // Intermediate Representation

  // Input File

  // Output File

  // Annotation

  //auto semantic_analysis();

  //auto build_symbol_table();

  void gen_ast();

  void gen_int();

  void gen_asm();



public:

  Compiler(std::string incode, bool popt_p, bool sopt_p, bool xopt_p, bool annotate_p);

  // Rule of Three/Five fix later.
  // ~Compiler();

  int compile();
};
