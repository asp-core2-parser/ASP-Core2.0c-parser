all: parser

parser.tab.c parser.tab.h:	parser.y
	bison -t -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser: lex.yy.c parser.tab.c parser.tab.h
	gcc -o parser.out parser.tab.c lex.yy.c -g
