#ifndef SYMBOL_TABLE_H_

#define SYMBOL_TABLE_H

#include "symboltable.h"

int return_int_val(symtable **table, char *token_name, int scope);

char return_char_val(symtable **table, char *token_name, int scope);

char *return_str_val(symtable **table, char *token_name, int scope);

void *return_point_val(symtable **table, char *token_name, int scope, int offset);

void add_int_val(symtable **table, char *token_name, int scope, int val);

void add_char_val(symtable **table, char *token_name, int scope, char val);

void add_str_val(symtable **table, char *token_name, int scope, char *val);

void add_point_val(symtable **table, char *token_name, int scope, char *token);

#endif