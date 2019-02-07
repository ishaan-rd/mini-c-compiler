%{
	#include "symboltable.h"
	#define yywrap() 1
	
	datatype current_dt;
%}

// Symbol table
%union {char* token_name;}

// Data types
%token INT LONG LLONG SHORT CHAR

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
%token CONSTANT_HEX CONSTANT_INT CONSTANT_CHAR CONSTANT_STR

%type <token_name> identifier

%left PUN_COM
%right OP_ASS
%left OP_OR OP_AND
%left EQ NOT_EQ
%left OP_LT OP_GT OP_LE OP_GE
%left OP_ADD OP_SUB
%left OP_MUL OP_DIV OP_MOD

%nonassoc UMINUS
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start program
%%

program: declaration
		| function
		| program declaration
		| program function
		;

declaration: type delarationlist ';'
		;

type:	INT 					{current_dt = I;}
		| LONG 					{current_dt = L;}
		| LLONG 				{current_dt = LL;}
		| SHORT 				{current_dt = SH;}
		| CHAR					{current_dt = CH;}
		| type OP_MUL			{current_dt = PTR;}
		;

delarationlist:
		| declare
		| delarationlist PUN_COM declare
		;

declare: identifier								{ insert($1.token_name, lineno); }
		| identifier PUN_SQO exp PUN_SQC		{ insert($1.token_name, lineno); }
		| identifier OP_ASS arithmetic_exp		{ insert($1.token_name, lineno); }
		| identifier OP_ASS OP_AND identifier	{ if(is_present($4.token_name)==-1){ printf("Line %d: %s does not exist\n", lineno, $4.token_name); yyerror("Undeclared variable\n"); } insert($1.token_name, lineno); }
		;

exp:	arithmetic_exp
		| assignment_exp
		;

arithmetic_exp: arithmetic_exp OP_AND arithmetic_exp
		| arithmetic_exp OP_OR arithmetic_exp
		| arithmetic_exp OP_LT arithmetic_exp
		| arithmetic_exp OP_GT arithmetic_exp		
		| arithmetic_exp OP_LE arithmetic_exp
		| arithmetic_exp OP_GE arithmetic_exp
		| arithmetic_exp OP_EE arithmetic_exp
		| arithmetic_exp OP_SUB arithmetic_exp
		| arithmetic_exp OP_ADD arithmetic_exp
		| arithmetic_exp OP_MUL arithmetic_exp
		| arithmetic_exp OP_DIV arithmetic_exp
		| arithmetic_exp OP_MOD arithmetic_exp
		| OP_SUB arithmetic_exp %prec UMINUS
		| OP_ADD arithmetic_exp %prec UMINUS
		| PUN_BO arithmetic_exp PUN_BC
		| identifier										{ if(is_present($1.token_name)==-1){ printf("Line %d: %s does not exist\n", lineno, $1.token_name); yyerror("Undeclared variable\n"); } }
		| constant
		;

assignment_exp:  identifier OP_ASS arithmetic_exp
		| identifier OP_ASS function_call
		| identifier OP_ASS identifier PUN_SQO exp PUN_SQC  { if(is_present($3.token_name)==-1){ printf("Line %d: %s does not exist\n", lineno, $3.token_name); yyerror("Undeclared variable\n"); } }
		;

function_call: identifier PUN_BO untyped_parameterlist PUN_BC
		;

identifier: ID				{$$ = $1.token_name;}
		;

constant: CONSTANT_CHAR
		| CONSTANT_HEX
		| CONSTANT_INT
		;

untyped_parameterlist: identifier
		| constant
		| untyped_parameterlist PUN_COM identifier
		| untyped_parameterlist PUN_COM constant
		;

function: type identifier typed_parameterlist scoped_statements
		;

typed_parameterlist: type identifier
		| type constant
		| typed_parameterlist PUN_COM identifier
		| typed_parameterlist PUN_COM constant
		;

scoped_statements: PUN_FO statements PUN_FC
		;

statements: statement
		| statements statement
		;

statement: if
		| for
		| while
		| RETURN ';'
		| RETURN exp ';'
		| CONTINUE ';'
		| BREAK ';'
		| function_call ';'
		;

scoped_unscoped_statements: scoped_statements
		| statements
		;

if:		IF PUN_BO exp PUN_BC scoped_unscoped_statements %prec LOWER_THAN_ELSE
		|IF PUN_BO exp PUN_BC scoped_unscoped_statements ELSE scoped_unscoped_statements
    	;


for:	FOR PUN_BO for_exp for_exp exp PUN_BC scoped_unscoped_statements
		|FOR PUN_BO for_exp for_exp PUN_BC scoped_unscoped_statements
		;

for_exp: exp ';'
		| ';'
		;

while:	WHILE PUN_BO exp PUN_BC scoped_unscoped_statements
		;

%%                     /* C code */

#include "lex.yy.c"

int main (void) {
	init();

	yyin = fopen(argv[1], "r");

	yyparse();

	fclose(yyin);
}
