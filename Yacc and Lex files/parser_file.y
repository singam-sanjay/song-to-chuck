%{
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

bool no_err = true;
int no_of_BARs = 0;
%}

%token KEY DOT EXT CHORD bar TEMPO
%start SONG

%%
BAR   : bar UNITS bar { //Could add something to handle syntax errors
      			++no_of_BARs;
			no_err &= ( ($$=( $2==8 ? 1 : 0 )) == 1 );
			if( $2!=8 )
			{
      				printf("bar# %i: #ticks = %i\n", no_of_BARs, $2);
			}
                      };

UNITS : UNITS UNIT    { $$ = $1 + $2;} 
        | UNIT        { $$ = $1;};

UNIT  :   NOTE        { $$ = $1;}
	| REST        { $$ = $1;}
	| CHORD       { $$ = 0;};

EXTS  :   EXTS EXT    { $$ = $1 + 1;}
	| EXT         { $$ = 1;};

NOTE  : KEY           { $$ = 1;}
        | KEY EXTS    { $$ = $2 + 1;};

REST  : DOT           { $$ = 1;}
        | DOT EXTS    { $$ = $2 + 1;};

BARS  : BARS BAR      { $$ = $1 + $2;} 
        | BAR         { $$ = $1;};

SONG  : TEMPO BARS {
      			if(no_err)
			{
				printf("The song was fully converted\n");// "fully converted" could be in green
				printf("No of bars: %d\n",$2);//Could add approximate duration
			}
			else
			{
				printf("The song was partially converted\n");// "partially converted" could be in red
				printf("%i out of %i BARs where accepted\n", $2, no_of_BARs );
			}
		   };
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

