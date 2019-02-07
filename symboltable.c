#include "symboltable.h"

symtable ** init(){
	symtable ** table = (symtable **)malloc(HT_SIZE * sizeof(symtable *));
	int i;
	for(i = 0; i < HT_SIZE; i++){
		table[i] = NULL;
	}
	return table;
}

int hash(char *token_name )
{
	size_t i;
	int hash = 0;

	for (i = 0; i < strlen(token_name); ++i ) {
		hash += token_name[i];
        hash += ( hash << 10 );
        hash ^= ( hash >> 6 );
    }

	hash += ( hash << 3 );
	hash ^= ( hash >> 11 );
    hash += ( hash << 15 );

	int h = hash % HT_SIZE;

	if(hash >= 0)
		return h;
	else
		return -h;
}

int is_present(symtable ** table, char * token_name){
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
	entry->token_name = (char *)malloc(sizeof(token_name) + 1);
	strcpy(entry->token_name, token_name);
	entry->token_type = token_type;
	entry->pred = NULL;
	return entry;
}

// Return 0 if no error else return 1
int insert(symtable ** table, char * token_name, datatype token_type){
	int h = is_present(table, token_name);

	if(h == -1){
		printf("%s already exists\n", token_name);
		fprintf (stderr, "\nRedeclared variable\n");
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

void display(symtable ** table){
	int i;
	printf("_______________________________________________________________________________\n");
	printf("|\t\tToken Name\t\t|\t\tType\t\t|\n");
	printf("_______________________________________________________________________________\n");
	for(i=0; i < HT_SIZE; i++){
		symtable * itr = table[i];
		while(itr!=NULL){
			printf("|\t\t%s\t\t\t|\t\t%d\t\t|\n", table[i]->token_name, table[i]->token_type);
			itr = itr->pred;
		}	
	}
	printf("_______________________________________________________________________________\n");
}