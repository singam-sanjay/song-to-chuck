%{
#include<stdio.h>
#include<stdlib.h>
%}

%token KEY DOT EXT CHORD bar TEMPO
%start SONG

%%
BAR   : bar UNITS bar;
UNITS : UNITS UNIT | UNIT;
UNIT  :   NOTE
	| REST
	| CHORD;
EXTS  :   EXTS EXT 
	| EXT; 
NOTE  : KEY
        | KEY EXTS;
REST  : DOT 
        | DOT EXTS;
BARS  : BARS BAR 
        | BAR;
SONG  : TEMPO BARS { printf("Song identified !\n"); };
%%

int yyerror( char *err_str )
{
	printf("Error : %s\n", err_str );
	return 1;
}

int main()
{
	yyparse();
	return 0;
}
