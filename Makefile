#   Copyright 2014 Parker Michaelson
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

SHELL = /bin/sh

#./pcmcpsl_lex_dev < lexical_test.cpsl

all: bin/pcmcpsl_syntax_analysis_demo

test: pcmcpsl_syntax_analysis_demo_test

pcmcpsl_syntax_analysis_demo_test: all
#	$(info Testing with test/lexical_test.cpsl:)
#	$(info )
#	bin/pcmcpsl_syntax_analysis_demo < test/lexical_test.cpsl
#	$(info )
#	$(info )
#	$(info Testing with test/tictactoe.cpsl:)
	bin/pcmcpsl_syntax_analysis_demo < test/tictactoe.cpsl
#	$(info )
#	$(info )

bin/pcmcpsl_syntax_analysis_demo: src/pcmcpsl.yy.c src/pcmcpsl.tab.c src/pcmcpsl.tab.h
	mkdir -p bin
	gcc -lfl src/pcmcpsl.yy.c src/pcmcpsl.tab.c -o bin/pcmcpsl_syntax_analysis_demo

src/pcmcpsl.yy.c: src/pcmcpsl.lex src/pcmcpsl.tab.h
	flex -o src/pcmcpsl.yy.c src/pcmcpsl.lex

src/pcmcpsl.tab.c src/pcmcpsl.tab.h: src/pcmcpsl.y
	cd src; \
	bison -d pcmcpsl.y; \
	cd ..
