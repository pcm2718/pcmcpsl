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

//#include <cstdio>
#include <argp.h>
#include <string>
#include <fstream>
#include <sstream>
#include "compiler.hpp"



/*
  Everything from here to main is part of the argument parsing system.
*/
const char* argp_program_version = "pcmcpsl 0.9";
const char* argp_program_bug_address = "parker.michaelson@gmail.com";
static char doc[] = "P(arker's) C(ompiler), M(IPS), for C(ompiler) P(roject) S(ource) L(anguage)";
static char args_doc[] = "INFILE.cpsl OUTFILE.mips";

static struct argp_option options[] = 
  {
    {"parseropt",   'p', 0, 0, "Enable parse-time optimizations. Not implmented."},
    {"semanticopt", 's', 0, 0, "Enable normal (compile time) optimizations. Not implmented."},
    {"expopt",      'x', 0, 0, "Enable experimental optimizations. Not implmented."},
    {"annotate",    'a', 0, 0, "Enable annotated assembly code. Not implmented."},
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
  main is exactly what you would expect; it sets some defaults for the
  flags calls arp_parse to grab the user's flags, input file and
  output file. After making sure the input and output files are valid,
  it passes the flags and files on to Compiler so it can do the *real*
  compilation.
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
    Run the argument parser.
  */
  argp_parse(&argp, argc, argv, 0, 0, &args);



  /*
    Print the parsed arguments. Commented code retained for debugging purposes.
  */
  /*
  printf("INFILE.cpsl: %s\nOUTFILE.cpsl: %s\n"
	 "popt_p: %s\nsopt_p: %s\nxopt_p: %s\n"
	 "annotate_p: %s\n",
	 args.args[0], args.args[1],
	 args.popt_p ? "true" : "false", args.sopt_p ? "true" : "false", args.xopt_p ? "true" : "false",
	 args.annotate_p ? "true" : "false");
  */



  /*
    Test the readability of INFILE.cpsl, then read INFILE.cpsl into
    std::string & incode . std::string conversion courtesy of:
    https://stackoverflow.com/questions/116038/what-is-the-best-way-to-slurp-a-file-into-a-stdstring-in-c .
  */
  // Add some error handling here.
  std::string incode;
  std::ifstream infile (args.args[0], std::ios::in | std::ios::binary);
  if (infile)
  {
    infile.seekg(0, std::ios::end);
    incode.resize(infile.tellg());
    infile.seekg(0, std::ios::beg);
    infile.read(&incode[0], incode.size());

  }
  infile.close();
  //throw(errno);



  /*
    Make sure we can create and write to OUTFILE.mips . Also, declare
    and initialize std::string & outcode .
  */
  // Implement this later, add error handling.
  std::string outcode = std::string();



  /*
    Compiler, on screen!

    Get an instance of Compiler, passing the incode and outcode
    strings to the constuctor, along with the flag settings struct.
  */
  // I should probably alter args to be passed by reference.
  // Compiler may also be a singleton in the future.
  Compiler compiler (incode, args.popt_p, args.sopt_p, args.xopt_p, args.annotate_p);

  /*
    Engage!

    Finally, just do the compiling already!
  */
  // Add error, handling.
  if (compiler.compile())
    return 1;
  // compiler.gen_ast();
  // compiler.gen_int();
  // compiler.gen_out();



  /*
    Actual compiling is now done, all we need to do now is write
    outcode to OUTPUT.mips.
  */
  std::ofstream outfile (args.args[1], std::ios::out | std::ios::binary);
  // There may be a better way to do this with blocks or somthing.
  outfile << outcode;
  outfile.close();



  /*
    We made it this far, return 0.

    Also, RTS style Millitary equipment.
  */
  return 0;
};
