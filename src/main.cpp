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
  main.cpp contains the topmost logic for the compiler. Essentially,
  it handles user arguments and calls the code that actually does the
  compilation.
*/

#include <cstdio>
#include <argp.h>
//#include "compiler.hpp"

/*
  Everything from here to main is part of the argument parsing system.
*/
const char* argp_program_version = "pcmcpsl 0.9";
const char* argp_program_bug_address = "parker.michaelson@gmail.com";
static char doc[] = "P(arker's) C(ompiler), M(IPS), for C(ompiler) P(roject) S(ource) L(anguage)";
static char args_doc[] = "INFILE.cpsl OUTFILE.mips";

static struct argp_option options[] = 
  {
    {"parseropt",   'p', 0, 0, "Enable parse-time optimizations."},
    {"semanticopt", 's', 0, 0, "Enable normal (compile time) optimizations."},
    {"expopt",      'x', 0, 0, "Enable experimental optimizations."},
    {"annotate",    'a', 0, 0, "Enable annotated assembly code."},
    {0}
  };

struct arguments
{
  char* args[2];
  bool popt_p;
  bool sopt_p;
  bool xopt_p;
  bool annotate_p;
};

static error_t parse_opt(int key, char* arg, struct argp_state* state)
{
  struct arguments * args = (arguments *)state->input;

  switch (key)
    {
    case 'p':
      args->popt_p = true;
      break;
    case 's':
      args->sopt_p = true;
      break;
    case 'x':
      args->xopt_p = true;
      break;
    case 'a':
      args->annotate_p = true;
      break;

      /*
	Remainder of case statement is slightly modified boilerplate
	from Example 2 in the argp info pages. I don't exactly
	understand what's going on here, other than collecting
	non-option arguments and complaining if too few or too many
	exist.
      */
    case ARGP_KEY_ARG:
      if (state->arg_num >= 3) /* Too many arguments. */
	argp_usage (state);

      args->args[state->arg_num] = arg;

      break;

    case ARGP_KEY_END:
      if (state->arg_num < 2)
	/* Not enough arguments. */
	argp_usage (state);
      break;

    default:
      return ARGP_ERR_UNKNOWN;
    }

  return 0;
};

static struct argp argp = {options, parse_opt, args_doc, doc};



/*
  Main is exactly what it says on the tin.
*/
int main(int argc, char** argv)
{
  /*
    Declare the agruments struct for the compiler and initialize the
    contents to safe defaults.
  */
  struct arguments args;
  args.popt_p = false;
  args.sopt_p = false;
  args.xopt_p = false;
  args.annotate_p = false;

  /*
    Run the arguments parser.
  */
  argp_parse(&argp, argc, argv, 0, 0, &args);

  /*
    Determine the file availability of the infile and outfile. Should
    the program do incremental read and write or read and write all at
    once?
  */

  /*
    Print the parsed arguments.
  */
  printf("INFILE.cpsl: %s\nOUTFILE.cpsl: %s\n"
	 "popt_p: %s\nsopt_p: %s\nxopt_p: %s\n"
	 "annotate_p: %s\n",
	 args.args[0], args.args[1],
	 args.popt_p ? "true" : "false", args.sopt_p ? "true" : "false", args.xopt_p ? "true" : "false",
	 args.annotate_p ? "true" : "false");


    /*
  auto & compiler = Compiler();

  compiler.gen_ast(infile, popt_p);
  compiler.gen_int(opt_p, xopt_p);
  compiler.gen_out(outfile, annotate_p);
    */

  return 0;
};
