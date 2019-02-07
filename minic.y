%{
	#include "symboltable.h"
	int cmnt_strt = 0, lineno = 1;
	char dtype[100];
%}

// Symbol table
%union {datatype token_type; char* token_name;}

// Data types
%token <token_type> INT LONG LLONG SHORT CHAR

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

%start program
%%

/* descriptions of expected inputs     corresponding actions (in C) */
program: declaration
		| function
		| program declaration
		| program function
		;

declaration:  type delarationlist ';'
		;

type:	INT 
		|LONG 
		|LLONG 
		|SHORT 
		|CHAR
		|type '*'
		;

declarationlist:
		|
		;

declaration: type identifier 		{}
		|
		;





%%                     /* C code */

int main (void) {
	init();
}
