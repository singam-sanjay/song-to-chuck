%{
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

bool no_err = true;
int no_of_BARs = 0;
int bar_note_count = 0;

const float isaiyin_gain = 0.6;

void chuck_init_stmts();
%}

%token KEY DOT EXT chord bar tempo count
%start SONG

%%
TEMPO : tempo	      {
				chuck_init_stmts();
				printf("(60.0/%i)::second => dur tick;\n", $1);
		      }

COUNT : count		{
      				bar_note_count = $1;
				#ifdef DEBUG
				fprintf(stderr,"bar_note_count = %i\n", bar_note_count);
				#endif
			}

BAR   : bar UNITS bar { //Could add something to handle syntax errors
      			++no_of_BARs;
			no_err &= ( ($$=( $2==bar_note_count ? 1 : 0 )) == 1 );
			if( $2!=bar_note_count )
			{
      				printf("bar# %i: #ticks = %i\n", no_of_BARs, $2);
				exit(1);
			}
                      };

UNITS : UNITS UNIT    { $$ = $1 + $2;} 
        | UNIT        { $$ = $1;};

UNIT  :   NOTE        { $$ = $1;}
	| REST        { $$ = $1;}
	| CHORD       { $$ = 0;};

EXTS  :   EXTS EXT    { $$ = $1 + 1;}
	| EXT         { $$ = 1;};

NOTE  : KEY           { 
      			printf("Std.mtof(%i) => isai.freq; tick => now;\n",$1);
      			$$ = 1;
		      }
        | KEY EXTS    {
			printf("Std.mtof(%i) => isai.freq; %i*tick => now;\n", $1, $2 + 1);
			$$ = $2 + 1;
		      };

REST  : DOT           { 
      			printf("0.0 => isai.gain; tick => now; %f => isai.gain;\n", isaiyin_gain);
      			$$ = 1;
		      }
        | DOT EXTS    {
			$$ = $2 + 1;
			printf("0.0 => isai.gain; %i*tick => now; %f => isai.gain;\n", $$, isaiyin_gain);
		      };

CHORD : chord {
      		static int abs_note;
		abs_note = abs($1);
      		printf("Std.mtof(%i) => mic_1.freq; Std.mtof(%i) => mic_2.freq; Std.mtof(%i) => mic_3.freq;\n", abs_note, abs_note + 16 + ( $1 < 0 ? -1 : 0 ), abs_note + 7);
      		$$ = 0;
	      }
      		

BARS  : BARS BAR      { $$ = $1 + $2;} 
        | BAR         { $$ = $1;};

SONG  : TEMPO COUNT BARS {
      			if(no_err)
			{
		//		printf("The song was fully converted\n");// "fully converted" could be in green
		//		printf("No of bars: %d\n",$2);//Could add approximate duration
			}
			else
			{
		//		printf("The song was partially converted\n");// "partially converted" could be in red
		//		printf("%i out of %i BARs where accepted\n", $2, no_of_BARs );
			}
		   };
%%

void chuck_init_stmts()
{
	printf("// patch\n"
		"Clarinet isai => JCRev r => dac;\n"
		"%f => r.gain;\n"
		".1 => r.mix;\n\n"
		"0.258034 => isai.reed;\n"
		"0.744377 => isai.noiseGain;\n"
		"2.202460 => isai.vibratoFreq;\n"
		"0.083285 => isai.vibratoGain;\n"
		"0.497330 => isai.pressure;\n"
		"SinOsc mic_1 => JCRev r1 => dac;\n"
		"SinOsc mic_2 => JCRev r2 => dac;\n"
		"SinOsc mic_3 => JCRev r3 => dac;\n"
		"0.02 => mic_1.gain;\n"
		"0.02 => mic_2.gain;\n"
		"0.01 => mic_3.gain;\n"
		"0.1 => r2.mix;\n", isaiyin_gain);
}

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

