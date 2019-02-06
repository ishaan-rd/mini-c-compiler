%{
	#include "symboltable.h"
	int cmnt_strt = 0, lineno = 1;
	char dtype[100];
%}

// Symbol table
%union {int num; char id;}
%start line
%token print
%token <num> number
%token <id> identifier
%type <num> line exp term 
%type <id> assignment
%token INT CHAR FLOAT DOUBLE VOID
%token IF ELSE
%token FOR WHILE
%token INCLUDE
%token STRUCT RETURN

%%

/* descriptions of expected inputs     corresponding actions (in C) */
includestatement:	'#' INCLUDE LT ID GT
					| '#' INCLUDE LT ID '.' ID GT
					;

include:	includestatement
			;

functiondef:	dtype ID PUN_FO PUN_FC
				;

line:	assignment ';'		{;}
		| print exp ';'			{printf("Value is %d\n", $2);}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("Value is %d\n", $3);}
        ;

assignment:	identifier '=' exp  { updateSymbolVal($1,$3); }
			;
exp:	term                  {$$ = $1;}
       	| exp '+' term          {$$ = $1 + $3;}
       	| exp '-' term          {$$ = $1 - $3;}
       	;
term:	number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
        ;

%%                     /* C code */

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}
