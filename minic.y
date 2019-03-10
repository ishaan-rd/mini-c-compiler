%{
	#include "symboltable.h"
	
	void yyerror(char *);

	symtable ** table = NULL;
	symtable ** stable = NULL;

	int current_dt;
	char * scope;
%}

// Symbol table
%union {char* token_name; int int_val, char char_val, char * string_val}

%token SEMICOLON

// Data types
%token INT LONG LLONG SHORT CHAR VOID

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

// Constants
%token <int_val> CONSTANT_INT 

%token <char_val> CONSTANT_CHAR 

%token <string_val> CONSTANT_STR

%type <token_name> identifier

%left PUN_COM
%left OP_OR OP_AND
%left OP_EE OP_NE
%left OP_LT OP_GT OP_LE OP_GE
%left OP_ADD OP_SUB
%left OP_MUL OP_DIV OP_MOD

%right OP_ASS

%nonassoc UMINUS
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start program



// | LONG 					{current_dt = L;}
// | LLONG 				{current_dt = LL;}
// | SHORT 				{current_dt = SH;}

%%

program: declaration			{strcpy(scope, "EXT")}
		| function				{strcpy(scope, "EXT")}		
		| program declaration	{strcpy(scope, "EXT")}
		| program function		{strcpy(scope, "EXT")}
		;

declaration: type delarationlist SEMICOLON
		;

type:	INT 					{$$ = I; current_dt = I}
		| CHAR					{$$ = current_dt; current_dt = CH;}
		| VOID 					{$$ = current_dt; current_dt = VO;}
		| type OP_MUL			{$$ = current_dt; current_dt =  $1 * $1;}
		;

delarationlist:
		| declare
		| delarationlist PUN_COM declare
		;

declare: identifier								{ insert(table, $1, current_dt); }
		| identifier PUN_SQO exp PUN_SQC		{ insert(table, $1, current_dt); }
		| identifier OP_ASS function_call		{ insert(table, $1, current_dt); }
		| identifier OP_ASS arithmetic_exp		{ insert(table, $1, current_dt); }
		| identifier OP_ASS OP_ADR identifier	{ if(is_present(table, $4)!=-1){ printf("\n%s does not exist\n", $4); yyerror("Undeclared variable\n"); } else insert(table, $1, current_dt); }
		;

exp:	arithmetic_exp
		| assignment_exp
		;

arithmetic_exp: arithmetic_exp OP_AND arithmetic_exp	   	{ $$ = $1 && $2;}
		| arithmetic_exp OP_OR arithmetic_exp				{ $$ = $1 || $2;}
		| arithmetic_exp OP_LT arithmetic_exp				{ $$ = $1 < $2;}
		| arithmetic_exp OP_GT arithmetic_exp				{ $$ = $1 > $2;}
		| arithmetic_exp OP_LE arithmetic_exp				{ $$ = $1 <= $2;}
		| arithmetic_exp OP_GE arithmetic_exp				{ $$ = $1 >= $2;}
		| arithmetic_exp OP_EE arithmetic_exp				{ $$ = $1 == $2;}
		| arithmetic_exp OP_SUB arithmetic_exp				{ $$ = $1 - $2;}
		| arithmetic_exp OP_ADD arithmetic_exp				{ $$ = $1 + $2;}
		| arithmetic_exp OP_MUL arithmetic_exp				{ $$ = $1 * $2;}
		| arithmetic_exp OP_DIV arithmetic_exp				{ $$ = $1 / $2;}
		| arithmetic_exp OP_MOD arithmetic_exp				{ $$ = $1 % $2;}
		| OP_SUB arithmetic_exp %prec UMINUS				{ $$ = -$1;}
		| OP_ADD arithmetic_exp %prec UMINUS				{ $$ = +$1;}
		| PUN_BO arithmetic_exp PUN_BC						{ $$ = ($1);}
		| identifier										{ if(is_present(table, $1)!=-1){ printf("\n%s does not exist\n", $1); yyerror("Undeclared variable\n"); } }
		| CONSTANT_INT										{ $$ = $1;}
		;

assignment_exp:  identifier OP_ASS arithmetic_exp
		| identifier OP_ASS CONSTANT_CHAR
		| identifier OP_ASS function_call
		| identifier OP_ASS OP_ADR identifier
		| identifier OP_ASS identifier PUN_SQO exp PUN_SQC  { if(is_present(table, $3)!=-1){ printf("\n%s does not exist\n", $3); yyerror("Undeclared variable\n"); } }
		| identifier OP_ASS point_exp
		| identifier OP_INC
		| identifier OP_DEC
		;

point_exp: OP_MUL identifier
		| OP_MUL point_exp
		;

function_call: identifier PUN_BO untyped_parameterlist PUN_BC {addIfNotPresent(table, $1, FUNCTION);}
		| identifier PUN_BO PUN_BC
		;

identifier: ID				{$$ = strdup($1);}
		;

untyped_parameterlist: identifier
		| CONSTANT_INT
		| CONSTANT_CHAR
		| CONSTANT_STR
		| point_exp
		| untyped_parameterlist PUN_COM identifier
		| untyped_parameterlist PUN_COM CONSTANT_INT
		| untyped_parameterlist PUN_COM CONSTANT_CHAR
		| untyped_parameterlist PUN_COM CONSTANT_STR
		| untyped_parameterlist PUN_COM point_exp
		;

function: type identifier functionparameters scoped_statements	{insert(table, strdup($2), FUNCTION);}
		;

functionparameters: PUN_BO typed_parameterlist PUN_BC
		|PUN_BO PUN_BC
		;

typed_parameterlist: type identifier				{addIfNotPresent(table, $2, current_dt);}
		| typed_parameterlist PUN_COM identifier
		;

scoped_statements: PUN_FO statements PUN_FC
		;

statements: statement
		| statements statement
		;

assignment_list: assignment_exp
		| assignment_list PUN_COM assignment_exp
		;	

statement: if
		| for
		| while
		| RETURN SEMICOLON
		| RETURN exp SEMICOLON
		| CONTINUE SEMICOLON
		| BREAK SEMICOLON
		| function_call SEMICOLON
		| declaration
		| assignment_list SEMICOLON
		;

scoped_unscoped_statements: scoped_statements
		| statement
		;

if:		IF PUN_BO exp PUN_BC scoped_unscoped_statements %prec LOWER_THAN_ELSE
		|IF PUN_BO exp PUN_BC scoped_unscoped_statements ELSE scoped_unscoped_statements
    	;


for:	FOR PUN_BO for_exp for_exp exp PUN_BC scoped_unscoped_statements	
		|FOR PUN_BO for_exp for_exp PUN_BC scoped_unscoped_statements
		;

for_exp: exp SEMICOLON
		| SEMICOLON
		;

while:	WHILE PUN_BO exp PUN_BC scoped_unscoped_statements
		;

%%                     /* C code */

#include "lex.yy.c"

void yyerror (char *s) {fprintf (stderr, "Line %d: %s\n", lineno, s);} 

int main (int argc, char * argv[]) {
	table = init();

	yyin = fopen(argv[1], "r");

	int x = yyparse();

	display(table);

	fclose(yyin);
}
