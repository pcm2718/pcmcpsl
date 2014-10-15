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
  compiler.cpp contains the implementation of the Compiler class.
*/

// #include <iostream>
#include "compiler.hpp"



void Compiler::gen_ast()
{};



void Compiler::gen_int()
{};



void Compiler::gen_asm()
{};



Compiler::Compiler(std::string incode, bool popt_p, bool sopt_p,
		   bool xopt_p, bool annotate_p)
  : incode (incode), outcode (std::string()), popt_p (popt_p),
    sopt_p (sopt_p), xopt_p (xopt_p), annotate_p (annotate_p)
{
  // Debugging
  // std::cout << outcode << popt_p << sopt_p << xopt_p << annotate_p << std::endl;
};



int Compiler::compile()
{
  /*
    Run yyparse on incode. If an error occurs, terminate the
    compilation and return 1 to indicate failure.
  */
  if (yyparse())
    return 1;

  return 0;
};
