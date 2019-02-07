#ifndef SYMBOL_TABLE_H_

#define SYMBOL_TABLE_H

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define HT_SIZE 1000

typedef enum dt{I, L, LL, SH, CH, PTR, FUNCTION} datatype; 

typedef struct sym_t{
    char * token_name;
    datatype token_type;
    // char * token_type;
    struct sym_t * pred;
} symtable;

symtable ** init();

int insert(symtable ** table, char * token_name, datatype token_type);

int yylex();

int is_present(symtable ** table, char * token_name);

void display(symtable ** table);

#endif