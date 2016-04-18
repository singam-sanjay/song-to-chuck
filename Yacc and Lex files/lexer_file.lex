%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "parser_file.tab.h"

int yylval;

int line_num = 1;
#define octave 5

#if octave < 2
	message("octave < 2");
#endif
%}

key ([cdefgabCDEFGAB]|([cdfgaCDFGA][#]))
chord_key ([CDEFGAB]|([CDFGA][#]))

%%
{key} {
	switch( tolower(yytext[0]) )
	{
		case 'c' : yylval = 0; break;
		case 'd' : yylval = 2; break;
		case 'e' : yylval = 4; break;
		case 'f' : yylval = 5; break;
		case 'g' : yylval = 7; break;
		case 'a' : yylval = 9; break;
		case 'b' : yylval = 11; break;
	}

	yylval += ( isupper( yytext[0] ) ? 12 : 0 );
	yylval += ( yytext[1] == '#' ? 1 : 0 );
	yylval += octave*12;
	
	#ifdef DEBUG
	printf("KEY:%s code:%i\n",yytext,yylval);
	#endif
	return KEY;
      }
[$]{chord_key}(m)?	{
				switch( tolower(yytext[1]) )
				{
					case 'c' : yylval = 0; break;
					case 'd' : yylval = 2; break;
					case 'e' : yylval = 4; break;
					case 'f' : yylval = 5; break;
					case 'g' : yylval = 7; break;
					case 'a' : yylval = 9; break;
					case 'b' : yylval = 11; break;
				}
				
				yylval += ( yytext[2] == '#' ? 1 : 0 );
				yylval += ( octave-2 )*12;
				yylval *= ( yytext[3]=='m' ? -1 : 1 );
				 
				#ifdef DEBUG
				printf("CHORD: %s\n",yytext);
				#endif
				return chord;
			}
[.] {	
	#ifdef DEBUG
	printf("REST\n");
	#endif
	return DOT;
    }

[|] {
	#ifdef DEBUG
	printf("bar\n");
	#endif
	return bar;
   }

[1-9][0-9]* { 
		#ifdef DEBUG
		printf("tempo\n");
		#endif
		yylval = atoi(yytext); return tempo;
	    }
[,] {
	#ifdef DEBUG
	printf("EXT\n");
	#endif
	return EXT;
    }
[\n] line_num++;
[ \t] {}
. { fprintf(stderr,"Invalid token @ line %i\n", line_num); exit(1); }
%%
