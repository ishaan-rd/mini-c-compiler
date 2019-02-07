#include "symboltable.h"

void init(){
	table = (symtable **)malloc(HT_SIZE * sizeof(symtable *));
	
	for(int i = 0; i < HT_SIZE; i++){
		table[i] = NULL;
	}
}

int hash( char *token_name )
{
	size_t i;
	int hash;
	
	for ( hash = i = 0; i < strlen(token_name); ++i ) {
        hash += token_name[i];
        hash += ( hash << 10 );
        hash ^= ( hash >> 6 );
    }

	hash += ( hash << 3 );
	hash ^= ( hash >> 11 );
    hash += ( hash << 15 );

	return hash % HT_SIZE;
}

int is_present(char * token_name){
	int h = hash(token_name);

	symtable * ptr = table[h];
	while(ptr!=NULL){
		if(strcmp(ptr->token_name, token_name) == 0)
			break;
	}

	if(ptr == NULL)
		return h;
	else
		return -1;
}

symtable * create_entry(char * token_name, datatype token_type){
	symtable * entry = (symtable *)malloc(sizeof(symtable));
	strcpy(entry->token_name, token_name);
	entry->token_type = token_type;
	entry->pred = NULL;
	return entry;
}

// Return 0 if no error else return 1
int insert(char * token_name, datatype token_type, int lineno){
	int h = is_present(token_name);
	
	if(h == -1){
		printf("Line %d: %s already exists\n", lineno, token_name);
		yyerror("Redeclared variable");
		return 1;
	}

	if(table[h] == NULL)
		table[h] = create_entry(token_name, token_type);
	else{
		symtable * entry = create_entry(token_name, token_type);
		symtable * ptr = table[h];
		entry->pred = ptr;
		table[h] = entry;
	}

	return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 