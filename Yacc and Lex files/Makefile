lex.yy.c: lexer_file.lex y.tab.h
	flex lexer_file.lex

y.tab.c: parser_file.y
	yacc parser_file.y -d

y.tab.h: parser_file.y
	yacc parser_file.y -d

lexer: lex.yy.c y.tab.h
	gcc lex.yy.c -ll -o lexer

parser: y.tab.c lex.yy.c
	gcc -g -o parser lex.yy.c y.tab.c -ll
