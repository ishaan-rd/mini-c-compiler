%{
	#include "symboltable.h"
	int cmnt_strt = 0, lineno = 1;
	char dtype[100];
%}

// Symbol table
%union {datatype token_type; char* token_name;}

// Data types
%token <token_type> INT LONG LLONG SHORT SIGNED UNSIGNED CHAR INTPTR CHARPTR

// Identifiers
%token <token_name> ID

// Keywords
%token FOR WHILE BREAK CONTINUE RETURN IF ELSE

// Operators
// 1 line
%token OP_DEC OP_INC

// pointer
%token OP_SPT

// LOGICAL
%token OP_AND OP_OR

// Comparision
%token OP_LT OP_GT OP_LE OP_GE OP_EE OP_NE

// Arithmetic
%token OP_ASS OP_SUB OP_ADD OP_MUL OP_DIV OP_MOD

// Address
%token OP_ADR

// Punctuators
%token PUN_COM PUN_BO PUN_BC PUN_FO PUN_FC PUN_SQO PUN_SQC

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQ NOT_EQ
%left '<' '>' LS_EQ GR_EQ
%left '+' '-'
%left '*' '/' '%'
%right '!'


%nonassoc UMINUS
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

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
	init();
}
