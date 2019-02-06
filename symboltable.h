#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define HT_SIZE 1000

typedef enum dt{INT, LONG, LLONG, SHORT, SIGNED, UNSIGNED, CHAR, FUNCTION} datatype; 

typedef struct sym_t{
    char * token_name;
    datatype token_type;
    struct sym_t * next;
} symtable;

int isPresent(char * token_name);
void updateSymbolVal(char symbol, int val);
void yyerror (char *s);
int yylex();