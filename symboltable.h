#ifndef SYMBOL_TABLE_H_

#define SYMBOL_TABLE_H

#include <stdio.h> /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define HT_SIZE 1000

#define I 2
#define CH 3
#define VO 5
#define FUNCTION 7

typedef struct pl
{
	char *id;
	int type;
	struct pl *next;
} parameter;

typedef struct sym_t
{
	char *token_name;
	int token_type;
	int scope;
	int * funs;
	int nos;
	struct sym_t *pred;
	int size;
} symtable;

typedef struct deft
{
	char *fn_name;
	int types[100];
	int count;
	struct deft *next;
} defn_table;

symtable **init();

int insert(symtable **table, char *token_name, int token_type, int scope);

int addIfNotPresent(symtable **table, char *token_name, int token_type, int scope);

int return_type(symtable **table, char *token_name, int scope);

int yylex();

int is_present(symtable **table, char *token_name, int scope);

void display(symtable **table);

void display_dt(defn_table *table);

parameter *add_parameter(parameter *parameter_list, char *id, int type);

int parameter_to_symtable(symtable **table, parameter *parameter_list, int scope);

defn_table *add_to_defn(defn_table *table, char *function_name, parameter *parameter_list);

int insert_func(symtable **table, char *token_name, int token_type, int scope, int i, parameter * parameter_list);

void check_params(symtable ** table, char * token_name, parameter * parameter_list);

int insertArray(symtable **table, char *token_name, int token_type, int size, int scope);

int isArray(symtable **table, char *token_name, int scope);

#endif