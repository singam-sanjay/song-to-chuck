lex.yy.c: lexer_file.lex parser_file.tab.h
	flex lexer_file.lex

parser_file.tab.c: parser_file.y
	bison parser_file.y -d

parser_file.tab.h: parser_file.y
	bison parser_file.y -d

lexer: lex.yy.c parser_file.tab.h
	gcc -g lex.yy.c -ll -g -o lexer

parser: parser_file.tab.c lex.yy.c
	gcc -g -o parser parser_file.tab.c lex.yy.c -ll

song.txt:
	@echo -en "\nPlease write a song and save it in "
	@tput bold
	@echo -e "song.txt\n"
	@tput sgr0
	@exit 1

chuck-song.ck: parser song.txt
	./parser < song.txt > chuck-song.ck

play: chuck-song.ck
	chuck chuck-song.ck

all: parser lexer chuck-song.ck

clean:
	rm lexer parser lex.yy.c parser_file.tab.c parser_file.tab.h
