%{
	#include "symboltable.h"
	#include "icg.h"
	#include<iostream>

	using namespace std;

	void yyerror(string);

	struct exp {
		int type; 
		int val;
		char * code;
		char * expr;
	};

	symtable ** table = NULL;

	defn_table * DT = NULL;

	int current_dt;
	int scope = 0;
	int max_scope = -100;
	int ret_type = -100;
	int is_function_over = 1;
	int current_line;
	int add_to_buffer = 0;
	parameter * parameter_list = NULL;

	int max(int a, int b)
	{
		if(a>b)
			return a;
		return b;
	}

	int floorSqrt(int x) 
	{ 
		// Base cases
		if (x == 0 || x == 1) 
		return x; 
	
		// Staring from 1, try all numbers until 
		// i*i is greater than or equal to x. 
		int i = 1, result = 1; 
		while (result <= x) 
		{ 
		i++; 
		result = i * i; 
		} 
		return i - 1; 
	} 

	string S(char *str)
	{
		string temp(str);
		return temp;
	}

	string S(const char *str)
	{
		string temp(str);
		return temp;
	}

	string S(string x)
	{
		return x;
	}

	string S(char c)
	{
		char * temp = new char(2);
		temp[0] = c;
		temp[1] = '\0';
		string x(temp);
		return x;
	}

	string S(int x)
	{
		string temp = std::to_string(x);
		return temp;
	}

	void id_present(char * id)
	{
 		if(is_present(table, id, scope)==-1)
		{ 
			printf("\n%s does not exist\n", id); 
			yyerror("Undeclared variable\n"); 
		}
	}

	void check_type_arith(int tp1, int tp2)
	{
		if(tp1 != I)
		{
			yyerror("invalid type variable\n");
		}
		else if(tp1 != tp2)
		{
			yyerror("invalid type variable\n");
		}
	}

	int type_get(char * id)
	{
		return return_type(table, id, scope);
	}

	int type_get_fc(char * id)
	{
		return return_type(table, id, -1) / FUNCTION;
	}

	void check_type(char * id, int tp)
	{	
		if( tp!=return_type(table, id, scope) )
		{
			yyerror("invalid type variable\n");
		}
	}

	void check_both_type(int tp1, int tp2)
	{
		if( tp1!=tp2 )
		{
			yyerror("invalid type variable\n"); 
		}
	}

	vector<int>v;
	vector<int>for_start;
	vector<char *> parameterss;
%}


// Symbol table
%union {char* token_name; int int_val; char char_val; char * string_val; struct exp exp_type;}

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

%type <int_val> type function_call function_start

%type <exp_type> arithmetic_exp point_exp

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

program: gl_declaration			{/*set_scope("EXT");*/}
		| function				{/*set_scope("EXT");*/}	
		| function_definition	
		| program gl_declaration{/*set_scope("EXT");*/}
		| program function		{/*set_scope("EXT");*/}
		| program function_definition
		;

gl_declaration: type gl_delarationlist SEMICOLON
		;

type:	INT 					{$$ = I; current_dt = I;}
		| CHAR					{$$ = CH; current_dt = CH; }
		| VOID 					{$$ = VO; current_dt = VO;}
		| type OP_MUL			{current_dt =  $1 * $1; $$ = current_dt;}
		;

gl_delarationlist:
		| gl_declare
		| gl_delarationlist PUN_COM declare
		;

gl_declare: identifier								{ insert(table, $1, current_dt, -1); }
		| identifier PUN_SQO arithmetic_exp PUN_SQC		{ if($3.val <= 0 || $3.type != I){yyerror("Array size less than 1");} insertArray(table, $1, current_dt * current_dt, $3.val, -1);}
		| identifier OP_ASS function_call		{ 
													insert(table, $1, current_dt, -1); check_both_type(current_dt, $3);
													gencode(S($1) + " = call " + S(parameterss[0]));
													parameterss.clear();
												}
		| identifier OP_ASS arithmetic_exp		{ insert(table, $1, current_dt, -1); check_both_type(current_dt, $3.type);}
		| identifier OP_ASS OP_ADR identifier	{ insert(table, $1, current_dt, -1); int x = type_get($4); check_both_type(current_dt, x*x);}
		| identifier OP_ASS CONSTANT_CHAR		{ insert(table, $1, current_dt, scope); check_both_type(current_dt, CH);}
		;

arithmetic_exp: arithmetic_exp OP_AND arithmetic_exp	   	{ 
																$$.type = I; check_type_arith($1.type, $3.type); 
																$$.val = $1.val && $3.val;
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "&&", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("&&") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "&&");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_OR arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type); 
																$$.val = $1.val || $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "||", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("||") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "||");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_LT arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type);  
																$$.val = $1.val < $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "<", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("<") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "<");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_GT arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type);  
																$$.val = $1.val > $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, ">", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen(">") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, ">");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_LE arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type);  
																$$.val = $1.val <= $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "<=", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("<=") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "<=");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_GE arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type);  
																$$.val = $1.val >= $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, ">=", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen(">=") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, ">=");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_EE arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type);  
																$$.val = $1.val == $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "==", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("==") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "==");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_SUB arithmetic_exp				{  
																$$.type = I; check_type_arith($1.type, $3.type);  
																$$.val = $1.val - $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "-", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("-") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "-");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_ADD arithmetic_exp				{   
																$$.type = I; check_type_arith($1.type, $3.type);   
																$$.val = $1.val + $3.val; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char)); strcpy($$.code, t);
																gencode_math($$.code, $1.code, "+", $3.code); 
																int len = strlen($1.expr) + strlen($3.expr) + strlen("+") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "+");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_MUL arithmetic_exp				{   
																$$.type = I; check_type_arith($1.type, $3.type);   
																$$.val = $1.val * $3.val;
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "*", $3.code); 
																int len = strlen($1.expr) + strlen($3.expr) + strlen("*") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "*");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_DIV arithmetic_exp				{   
																$$.type = I; check_type_arith($1.type, $3.type);   
																$$.val = $1.val / $3.val;	
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "/", $3.code); 
																int len = strlen($1.expr) + strlen($3.expr) + strlen("/") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "/");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| arithmetic_exp OP_MOD arithmetic_exp				{   
																$$.type = I; check_type_arith($1.type, $3.type);   
																$$.val = $1.val % $3.val;
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, $1.code, "%", $3.code);
																int len = strlen($1.expr) + strlen($3.expr) + strlen("%") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, $1.expr);
																strcat(instruction, "%");
																strcat(instruction, $3.expr);
																$$.expr = instruction;
															}
		| OP_SUB arithmetic_exp %prec UMINUS				{   
																$$.type = I; check_type_arith(I, $2.type);   
																$$.val = -$2.val;
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, "", "-", $2.code);
																int len = strlen("1") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, "1");
																$$.expr = instruction;
															}
		| OP_ADD arithmetic_exp %prec UMINUS				{   
																$$.type = I; check_type_arith(I, $2.type); 
																$$.val = +$2.val;
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, "", "+", $2.code);
																int len = strlen("1") + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, "1");
																$$.expr = instruction;
															}
		| PUN_BO arithmetic_exp PUN_BC						{   
																$$.type = I; check_type_arith(I, $2.type); 
																$$.val = ($2.val);
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t);
																gencode_math($$.code, "(", $2.code, ")");
																int len = strlen("(") + strlen(")") + strlen($2.expr) + 1; 
																char * instruction = (char *)malloc(sizeof(char) * len);
																instruction[0] = '\0';
																strcat(instruction, "(");
																strcat(instruction, $2.expr);
																strcat(instruction, ")");
																$$.expr = instruction;
															}
		| identifier										{ 
																id_present($1); $$.type = type_get($1); $$.val = 2;
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t); 
																gencode( S($$.code) + " = " + S($1));
																$$.expr = $$.code;
															}
		| CONSTANT_INT										{ 
																$$.type = I; 
																$$.val = $1; 
																const char * t = generateTemp();
																$$.code = (char *)malloc((strlen(t)+1)*sizeof(char));strcpy($$.code, t); 
																gencode( S($$.code) + " = " + S($1));
																$$.expr = $$.code;
															}
		;

assignment_exp:  identifier OP_ASS arithmetic_exp			{
																id_present($1); 
																check_type($1, $3.type);
																gencode_math(S($1), S($3.code), "", "");
															}
		| identifier OP_ASS CONSTANT_CHAR					{
																id_present($1); 
																check_type($1, CH);
																const char * t1 = generateTemp();
																char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
																strcpy(temp, t1);
																gencode_math(S(temp), S($3), "", "");
																gencode_math(S($1), S(temp), "", "");
															}
		| identifier OP_ASS function_call					{
																id_present($1); 
																check_type($1, $3);
																gencode(S($1) + " = call " + S(parameterss[0]));
																parameterss.clear();
															}
		| identifier OP_ASS OP_ADR identifier				{
																id_present($1); 
																id_present($4); int x =  type_get($4); check_type($1, x * x);
																const char * t1 = generateTemp();
																char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
																strcpy(temp, t1);
																gencode(S(temp) + " = addr(" + S($4) + ")");
																gencode(S($1) + " = " + S(temp));
															}
		| identifier OP_ASS identifier PUN_SQO arithmetic_exp PUN_SQC  { 
																id_present($1); id_present($3);
																int t = isArray(table, $3, scope);
																if(t==0)
																{
																	t = isArray(table, $3, -1);
																}
																if($5.val < 0 || $5.type != I || $5.val >= t)
																	{yyerror("Array index invalid dimension");} 
																int x = type_get($1); 
																check_type($3, x * x);
																const char * t1 = generateTemp();
																char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
																strcpy(temp, t1);
																gencode(S(temp) + " = addr(" + S($3) + ")");
																gencode(S($1) + " = " + S(temp) + "[" + S($5.code) + "]");
															}
		| identifier OP_ASS point_exp						{
																id_present($1);
																check_type($1, $3.type);
																int x = $3.val;
																const char * t = generateTemp();
																char * tempPrev = (char *)malloc((strlen($3.code) + 1) * sizeof(char));
																strcpy(tempPrev, $3.code);
																char * temp = (char *)malloc((strlen(t) + 1) * sizeof(char));
																strcpy(temp, t);
																gencode(S(temp) + " = *" + S(tempPrev));
																while(x-1)
																{
																	const char * t = generateTemp();
																	temp = (char *)malloc((strlen(t) + 1) * sizeof(char));
																	strcpy(temp, t);
																	gencode(S(temp) + " = *" + S(tempPrev));
																	tempPrev = (char *)malloc((strlen(temp) + 1) * sizeof(char));
																	strcpy(tempPrev, temp);
																	x--;
																}
																gencode(S($1) + " = " + S(temp));
															}
		| identifier OP_INC									{
																id_present($1); 
																check_type($1, I);
																const char * t1 = generateTemp();
																char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
																strcpy(temp, t1);
																gencode(S(t1) + " = " + S($1));
																const char * t2 = generateTemp();
																char * temp2 = (char *)malloc((strlen(t2) + 1) * sizeof(char));
																strcpy(temp2, t2);
																gencode(S(t2) + " = " + "1");
																gencode(S($1) + " = " + S(temp) + " + " + S(temp2));
															}
		| identifier OP_DEC									{
																id_present($1); check_type($1, I);
																const char * t1 = generateTemp();
																char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
																strcpy(temp, t1);
																gencode(S(t1) + " = " + S($1));
																const char * t2 = generateTemp();
																char * temp2 = (char *)malloc((strlen(t2) + 1) * sizeof(char));
																strcpy(temp2, t2);
																gencode(S(t2) + " = " + "1");
																gencode(S($1) + " = " + S(temp) + " - " + S(temp2));
															}
		| identifier PUN_SQO arithmetic_exp PUN_SQC OP_ASS arithmetic_exp { 
																id_present($1); 
																int t = isArray(table, $1, scope);
																if(t==0)
																{
																	t = isArray(table, $1, -1);
																}
																if($3.val < 0 || $3.type != I || $3.val >= t){yyerror("Array index invalid dimension");} 
																int x = $6.type; check_type($1, x * x);
																const char * t1 = generateTemp();
																gencode(S(t1) + " = addr(" + S($1) + ")");
																string instruction = S(t1) + "[" + S($3.code) + "]" + " = " + S($6.code);
																gencode(instruction);
															}
		;

point_exp: OP_MUL identifier								{
																if(type_get($2) == I || type_get($2) == CH)
																		yyerror("Invalid type");

																$$.type = floorSqrt(type_get($2));
																$$.val = 1;
																$$.code = new char(strlen($2)+1);
																strcpy($$.code, $2);
															}
		| OP_MUL point_exp									{
																if($2.type == I || $2.type == CH)
																		yyerror("Invalid type");

																$$.type = floorSqrt($2.type);														
																$$.val = $2.val + 1;
																$$.code = new char(strlen($2.code)+1);
																strcpy($$.code, $2.code);
															}
		;

function_call: identifier PUN_BO untyped_parameterlist PUN_BC 	{
																	id_present($1); $$ = type_get_fc($1); check_params(table, $1, parameter_list); parameter_list = NULL;
																	int len = 0;
																	int i;
																	for(i=0; i < parameterss.size(); i++)
																	{
																		len += 1 + strlen(parameterss[i]);
																	}
																	len += strlen($1) + 1;
																	len++;
																	char * parameter = (char *)malloc(sizeof(char)*len);
																	parameter[0] = '\0';
																	strcat(parameter, $1);
																	strcat(parameter, "(");
																	for(i=0; i < parameterss.size(); i++)
																	{
																		strcat(parameter, parameterss[i]);
																		if(i == parameterss.size()-1)
																			strcat(parameter, ")");
																		else
																			strcat(parameter, ",");
																	}
																	parameterss.clear();
																	parameterss.push_back(parameter);				
																}
		| identifier PUN_BO PUN_BC							{id_present($1); $$ = type_get_fc($1); check_params(table, $1, parameter_list); parameter_list = NULL;
															
																int len = 0;
																len += strlen($1) + 2;
																len++;
																char * parameter = (char *)malloc(sizeof(char)*len);
																parameter[0] = '\0';
																strcat(parameter, $1);
																strcat(parameter, "2");	
																parameterss.clear();
																parameterss.push_back(parameter);												
															}
		;

identifier: ID												{$$ = strdup($1);}
		;

untyped_parameterlist: arithmetic_exp						{
																parameter_list = add_parameter(parameter_list, (char *)"P", $1.type);
																char * parameter = (char *)malloc(sizeof(char)*(strlen($1.code) + 1));
																strcpy(parameter, $1.code);
																parameterss.push_back(parameter);
															}
		| untyped_parameterlist PUN_COM arithmetic_exp		{
																parameter_list = add_parameter(parameter_list, (char *)"P", $3.type);
																char * parameter = (char *)malloc(sizeof(char)*(strlen($3.code) + 1));
																strcpy(parameter, $3.code);
																parameterss.push_back(parameter);
															}
		;

function_definition: type identifier function_defn_parameters SEMICOLON	{ DT = add_to_defn(DT, $2, parameter_list); parameter_list = NULL;}
		;

function_defn_parameters: functionparameters
		|typeparalist
		;

typeparalist: PUN_BO type_list PUN_BC
		;

type_list: type									{parameter_list = add_parameter(parameter_list, (char *)"P", $1);}
		| type_list PUN_COM type				{parameter_list = add_parameter(parameter_list, (char *)"P", $3);}
		;

function_start: type identifier functionparameters 	{
														scope = max(max_scope, scope) + 1; int i = parameter_to_symtable(table, parameter_list, scope + 1); 
														insert_func(table, strdup($2), FUNCTION * $1, -1, i, parameter_list); 
														gencode(S($2) + " :");
														while(parameter_list != NULL)
														{
															gencode("arg " + S(parameter_list->id));
															parameter_list = parameter_list->next;
														}
														parameter_list = NULL; 
														$$ = $1;	
													} 
		;

function: function_start scoped_statements			{if((is_function_over == 0 && $1 != ret_type) || (is_function_over == 1 && $1 != VO)){printf("%d", $1); yyerror("INVAID RETURN TYPE");} is_function_over = 1;}
		;

functionparameters: PUN_BO typed_parameterlist PUN_BC
		|PUN_BO PUN_BC
		;

typed_parameterlist: type identifier							{parameter_list = add_parameter(parameter_list, $2, current_dt);}
		| typed_parameterlist PUN_COM type identifier			{parameter_list = add_parameter(parameter_list, $4, current_dt);}
		;

scoped_statements: scoped_statements_start statements PUN_FC	{--scope;}
		;

scoped_statements_start: PUN_FO									{++scope; if(scope > max_scope) max_scope = scope;}
		;

statements: statement
		| statements statement
		;

assignment_list: assignment_exp
		| assignment_list PUN_COM assignment_exp
		;	

statement: if
		| for
		| RETURN SEMICOLON							{if(is_function_over == 1){is_function_over = 0; ret_type = VO;} else if(ret_type != VO){ yyerror("INVALID RETURN TYPE");}}
		| RETURN identifier SEMICOLON				{if(is_function_over == 1){is_function_over = 0; ret_type = type_get($2);} else if(ret_type != type_get($2)){ yyerror("INVALID RETURN TYPE");}}
		| RETURN CONSTANT_INT SEMICOLON				{if(is_function_over == 1){is_function_over = 0; ret_type = I;} else if(ret_type != I){ yyerror("INVALID RETURN TYPE");}}
		| CONTINUE SEMICOLON
		| BREAK SEMICOLON
		| function_call SEMICOLON					{
														gencode("call " + S(parameterss[0]));
														parameterss.clear();
													}
		| declaration
		| assignment_list SEMICOLON
		;

declaration: type delarationlist SEMICOLON
		;

delarationlist:
		| declare
		| delarationlist PUN_COM declare
		;

declare: identifier								{ insert(table, $1, current_dt, scope); }
		| identifier PUN_SQO arithmetic_exp PUN_SQC		{ if($3.val <= 0 || $3.type != I){yyerror("Array size less than 1");} insertArray(table, $1, current_dt * current_dt, $3.val, scope);}
		| identifier OP_ASS function_call		{ 
													insert(table, $1, current_dt, scope); check_both_type(current_dt, $3);
													gencode(S($1) + " = call " + S(parameterss[0]));
													parameterss.clear();
												}
		| identifier OP_ASS arithmetic_exp		{ 
													insert(table, $1, current_dt, scope); check_both_type(current_dt, $3.type);
													gencode_math(S($1), S($3.code), "", "");
												}
		| identifier OP_ASS OP_ADR identifier	{ 
													insert(table, $1, current_dt, scope); int x = type_get($4); check_both_type(current_dt, x*x);
													const char * t1 = generateTemp();
													char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
													strcpy(temp, t1);
													gencode(S(temp) + " = addr(" + S($4) + ")");
													gencode(S($1) + " = " + S(temp));
												}
		| identifier OP_ASS CONSTANT_CHAR		{ 
													insert(table, $1, current_dt, scope); check_both_type(current_dt, CH);
													const char * t1 = generateTemp();
													char * temp = (char *)malloc((strlen(t1) + 1) * sizeof(char));
													strcpy(temp, t1);													
													gencode_math(S(temp), S($3), "", "");
													gencode_math(S($1), S(temp), "", "");
												}
		;

scoped_unscoped_statements: scoped_statements	{}
		| statement
		;


if_start: IF PUN_BO arithmetic_exp PUN_BC		{
													gencode("if !" + S($3.expr) + " goto _:");
													v.push_back(line_no()-1);
												}
		;

if:	if_start scoped_unscoped_statements %prec LOWER_THAN_ELSE
												{
													back_track(v, line_no());
												}
	|if_start scoped_unscoped_statements else
												{
													back_track(v, line_no());
													
												}
	;

else: ELSE scoped_unscoped_statements
												{
													back_track(v, line_no());
													gencode(" goto _:");
													v.push_back(line_no()-1);
												}
	;

for:for_start scoped_unscoped_statements 	{
												merge();
												int x = for_start.back();
												for_start.pop_back();
												gencode("goto " + S(x) + ":");
												back_track(v, line_no());												
											}
	;

for_start:	FOR PUN_BO assignment_exp SEMICOLON arithmetic_exp  SEMICOLON { addToBuffer(); } assignment_exp PUN_BC 
												{
													stopBuffer();
													gencode("if !" + S($5.expr) + " goto _:");
													v.push_back(line_no()-1);
													for_start.push_back(line_no()-1);		
												}
		;

%%


// while:	WHILE PUN_BO exp PUN_BC scoped_unscoped_statements
// 		;

#include "lex.yy.c"

void yyerror (string s) { cerr << "Line :" << lineno << ":" << s << endl;} 

int main (int argc, char * argv[]) {
	table = init();

	yyin = fopen(argv[1], "r");

	int x = yyparse();

	display(table);

	displayICG();
	// display_dt(DT);

	fclose(yyin);
}
