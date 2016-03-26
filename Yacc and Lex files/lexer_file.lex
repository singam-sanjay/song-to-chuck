%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int line_num = 1;
%}

key ([cdefgabCDEFGAB]|([cdfgaCDFGA][#]))

%%
{key} return KEY;
[$]{key}(m)? return CHORD;
[.] return DOT;
[|] return bar;
[1-9][0-9]* return TEMPO;
[,] return EXT;
[\n] line_num++;
[ \t] {}
. { printf("Invalid token @ line %i\n", line_num); exit(1); }
%%
