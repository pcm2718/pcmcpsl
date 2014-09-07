SHELL = /bin/sh

#./pcmcpsl_lex_dev < lexical_test.cpsl

all: bin/pcmcpsl_lex_demo

test: pcmcpsl_lex_demo_test

pcmcpsl_lex_demo_test: bin/pcmcpsl_lex_demo test/lexical_test.cpsl
	bin/pcmcpsl_lex_demo < test/lexical_test.cpsl

bin/pcmcpsl_lex_demo: src/pcmcpsl.yy.c
	gcc -lfl src/pcmcpsl.yy.c -o bin/pcmcpsl_lex_demo

src/pcmcpsl.yy.c: src/pcmcpsl.lex
	flex -o src/pcmcpsl.yy.c src/pcmcpsl.lex
