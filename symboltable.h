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

symtable ** table = NULL;

void init();

void yyerror (char *s);

int insert(char * token_name, datatype token_type);

int yylex();

int is_present(char * token_name);