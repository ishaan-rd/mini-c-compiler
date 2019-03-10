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

typedef struct vl
{
	int intval;
	char charval;
	char *strval;
} val;

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
	char *scope;
	val value;
	struct sym_t *pred;
} symtable;

symtable **init();

int insert(symtable **table, char *token_name, int token_type, char *scope);

int addIfNotPresent(symtable **table, char *token_name, int token_type, char *scope);

int return_type(symtable **table, char *token_name, char *scope);

int yylex();

int is_present(symtable **table, char *token_name, char *scope);

void display(symtable **table);

parameter * add_parameter(parameter *parameter_list, char *id, int type);

void parameter_to_symtable(symtable ** table, parameter *parameter_list, char *scope);

#endif