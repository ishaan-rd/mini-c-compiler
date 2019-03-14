%{
	#include "symboltable.h"
	
	void yyerror(char *);

	symtable ** table = NULL;
	symtable ** stable = NULL;

	int current_dt;
	char * scope;
	parameter * parameter_list = NULL;

	void set_scope(char * scp)
	{
		scope = (char *)malloc(sizeof(char)*(strlen(scp)+1));
		strcpy(scope, scp);
	}

	val value;

	// void set_int(int val)
	// {
	// 	value.intval = val;
	// }

	// void set_char(char val)
	// {
	// 	value.charval = val;
	// }

	// void set_str(char * val)
	// {
	// 	value.str_val = (char *)malloc(sizeof(char)*(strlen(val)+1));
	// 	strcpy(value.str_val, val);
	// }

	void id_present(char * id)
	{
 		if(is_present(table, id)==-1)
		{ 
			printf("\n%s does not exist\n", id); 
			yyerror("Undeclared variable\n"); 
		} 
	}

	int type_get(char * id)
	{
		return 1;
		// return return_type(table, id);
	}

	int type_get_fc(char * id)
	{
		return 1;
		// return return_type(table, id) / FUNCTION;
	}

	void check_type(char * id, int tp)
	{	
		if( tp!=return_type(table, id) )
		{
			yyerror("invalid type variable\n"); 
		}
	}

	void check_both_type(int tp1, int tp2)
	{
		// if( tp1!=tp2 )
		// {
		// 	yyerror("invalid type variable\n"); 
		// }
	}

%}

// Symbol table
%union {char* token_name; int int_val; char char_val; char * string_val;}

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

%type <int_val> type arithmetic_exp function_call point_exp

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



// | LONG 				{current_dt = L;}
// | LLONG 				{current_dt = LL;}
// | SHORT 				{current_dt = SH;}

%%

program: declaration			{set_scope("EXT");}
		| function				{set_scope("EXT");}		
		| program declaration	{set_scope("EXT");}
		| program function		{set_scope("EXT");}
		;

declaration: type delarationlist SEMICOLON
		;

type:	INT 					{$$ = I; current_dt = I;}
		| CHAR					{$$ = current_dt; current_dt = CH;}
		| VOID 					{$$ = current_dt; current_dt = VO;}
		| type OP_MUL			{$$ = current_dt; current_dt =  $1 * $1;}
		;

delarationlist:
		| declare
		| delarationlist PUN_COM declare
		;

declare: identifier								{ insert(table, $1, current_dt); }
		| identifier PUN_SQO arithmetic_exp PUN_SQC		{insert(table, $1, current_dt * current_dt); if($3 <= 0){yyerror("Array size less than 1");}}
		| identifier OP_ASS function_call		{ insert(table, $1, current_dt); check_both_type(current_dt, $3);}
		| identifier OP_ASS arithmetic_exp		{ insert(table, $1, current_dt); check_both_type(current_dt, I);}
		| identifier OP_ASS OP_ADR identifier	{ insert(table, $1, current_dt); int x = type_get($4); check_both_type(current_dt, x*x);}
		;

exp:	arithmetic_exp
		| assignment_exp
		;

arithmetic_exp: arithmetic_exp OP_AND arithmetic_exp	   	{ $$ = $1 && $3;}
		| arithmetic_exp OP_OR arithmetic_exp				{ $$ = $1 || $3;}
		| arithmetic_exp OP_LT arithmetic_exp				{ $$ = $1 < $3;}
		| arithmetic_exp OP_GT arithmetic_exp				{ $$ = $1 > $3;}
		| arithmetic_exp OP_LE arithmetic_exp				{ $$ = $1 <= $3;}
		| arithmetic_exp OP_GE arithmetic_exp				{ $$ = $1 >= $3;}
		| arithmetic_exp OP_EE arithmetic_exp				{ $$ = $1 == $3;}
		| arithmetic_exp OP_SUB arithmetic_exp				{ $$ = $1 - $3;}
		| arithmetic_exp OP_ADD arithmetic_exp				{ $$ = $1 + $3;}
		| arithmetic_exp OP_MUL arithmetic_exp				{ $$ = $1 * $3;}
		| arithmetic_exp OP_DIV arithmetic_exp				{ $$ = $1 / $3;}
		| arithmetic_exp OP_MOD arithmetic_exp				{ $$ = $1 % $3;}
		| OP_SUB arithmetic_exp %prec UMINUS				{ $$ = -$2;}
		| OP_ADD arithmetic_exp %prec UMINUS				{ $$ = +$2;}
		| PUN_BO arithmetic_exp PUN_BC						{ $$ = ($2);}
		| identifier										{ $$ = 2; id_present($1); check_type($1, I); }
		| CONSTANT_INT										{ $$ = $1;}
		;

assignment_exp:  identifier OP_ASS arithmetic_exp			{id_present($1); check_type($1, I);}
		| identifier OP_ASS CONSTANT_CHAR					{id_present($1); check_type($1, CH);}
		| identifier OP_ASS function_call					{id_present($1); check_type($1, $3);}
		| identifier OP_ASS OP_ADR identifier				{id_present($1); id_present($4); int x =  type_get($4); check_type($1, x * x);}
		| identifier OP_ASS identifier PUN_SQO arithmetic_exp PUN_SQC  { id_present($1); id_present($3); if($5 < 0){yyerror("Array index less than 0");} int x = type_get($1); printf("Chutiya\n"); check_type($3, x * x);}
		| identifier OP_ASS point_exp						{id_present($1); check_type($1, $3);}
		| identifier OP_INC									{id_present($1); check_type($1, I);}
		| identifier OP_DEC									{id_present($1); ($1, I);}
		;

point_exp: OP_MUL identifier								{$$ = type_get($2) * type_get($2);}
		| OP_MUL point_exp									{$$ = $2 * $2;}
		;

function_call: identifier PUN_BO untyped_parameterlist PUN_BC 	{id_present($1); $$ = type_get_fc($1);}
		| identifier PUN_BO PUN_BC							{id_present($1); $$ = type_get_fc($1);}
		;

identifier: ID												{$$ = strdup($1);}
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

function: type identifier functionparameters scoped_statements	{insert(table, strdup($2), FUNCTION * $1); set_scope($2); /*parameter_to_symtable(table, parameter_list); parameter_list = NULL;*/}
		;

functionparameters: PUN_BO typed_parameterlist PUN_BC
		|PUN_BO PUN_BC
		;

typed_parameterlist: type identifier							{/*parameter_list = add_parameter(parameter_list, $2, $1);*/}
		| typed_parameterlist PUN_COM type identifier			{/*parameter_list = add_parameter(parameter_list, $4, $3);*/}
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

%%

#include "lex.yy.c"

void yyerror (char *s) {fprintf (stderr, "Line %d: %s\n", lineno, s);} 

int main (int argc, char * argv[]) {
	table = init();

	yyin = fopen(argv[1], "r");

	int x = yyparse();

	display(table);

	fclose(yyin);
}
