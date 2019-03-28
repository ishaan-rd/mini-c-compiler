#ifndef FUNC_H

#define FUNC_H

#include "symboltable.h"

typedef struct vl
{
	int intval;
	char charval;
	char *strval;
} val;

int return_int_val(symtable **table, char *token_name, int scope);

char return_char_val(symtable **table, char *token_name, int scope);

char *return_str_val(symtable **table, char *token_name, int scope);

void *return_point_val(symtable **table, char *token_name, int scope, int offset);

void add_int_val(symtable **table, char *token_name, int scope, int val);

void add_char_val(symtable **table, char *token_name, int scope, char val);

void add_str_val(symtable **table, char *token_name, int scope, char *val);

void add_point_val(symtable **table, char *token_name, int scope, char *token);

#endif