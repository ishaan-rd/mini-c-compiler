#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define HT_SIZE 1000

typedef enum dt{INT, LONG, LLONG, SHORT, SIGNED, UNSIGNED, CHAR, FUNCTION} datatype; 

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