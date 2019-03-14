#include "symboltable.h"

symtable **init()
{
	symtable **table = (symtable **)malloc(HT_SIZE * sizeof(symtable *));
	int i;
	for (i = 0; i < HT_SIZE; i++)
	{
		table[i] = NULL;
	}
	return table;
}

int hash(char *token_name)
{
	size_t i;
	int hash = 0;

	for (i = 0; i < strlen(token_name); ++i)
	{
		hash += token_name[i];
		hash += (hash << 10);
		hash ^= (hash >> 6);
	}

	hash += (hash << 3);
	hash ^= (hash >> 11);
	hash += (hash << 15);

	int h = hash % HT_SIZE;

	if (hash >= 0)
		return h;
	else
		return -h;
}

int is_not_present(symtable **table, char *token_name)
{
	int h = hash(token_name);
	symtable *ptr = table[h];
	while (ptr != NULL)
	{
		printf("%s\n", ptr->token_name);
		if (strcmp(ptr->token_name, token_name) == 0)
			break;
		ptr = ptr->pred;
	}

	if (ptr == NULL)
		return h;
	else
		return -1;
}

int is_present(symtable **table, char *token_name)
{
	int h = hash(token_name);
	symtable *ptr = table[h];
	while (ptr != NULL)
	{
		if (strcmp(ptr->token_name, token_name) == 0)
			break;
		ptr = ptr->pred;
	}

	if (ptr == NULL)
		return -1;
	else
		return h;
}

// symtable *create_entry(char *token_name, int token_type, val value)
symtable *create_entry(char *token_name, int token_type)
{
	symtable *entry = (symtable *)malloc(sizeof(symtable));
	entry->token_name = (char *)malloc(sizeof(token_name) + 1);
	strcpy(entry->token_name, token_name);
	// entry->scope = (char *)malloc(sizeof(scope) + 1);
	// strcpy(entry->scope);
	// entry->value = value;
	entry->token_type = token_type;
	entry->pred = NULL;
	return entry;
}

// Return 0 if no error else return 1
// int insert(symtable **table, char *token_name, int token_type, val value)
int insert(symtable **table, char *token_name, int token_type)
{
	int h = is_not_present(table, token_name);

	if (h == -1)
	{
		printf("\n%s already exists. ", token_name);
		fprintf(stderr, "Redeclared variable\n\n");
		return 1;
	}

	if (table[h] == NULL)
		table[h] = create_entry(token_name, token_type);
	else
	{
		symtable *entry = create_entry(token_name, token_type);
		symtable *ptr = table[h];
		entry->pred = ptr;
		table[h] = entry;
	}

	return 0;
}

// int addIfNotPresent(symtable **table, char *token_name, int token_type, val value)
int addIfNotPresent(symtable **table, char *token_name, int token_type)
{
	int h = is_not_present(table, token_name);

	if(h!=-1)
		if (table[h] == NULL)
			table[h] = create_entry(token_name, token_type);
		else
		{
			symtable *entry = create_entry(token_name, token_type);
			symtable *ptr = table[h];
			entry->pred = ptr;
			table[h] = entry;
		}

	return 0;
}

int return_type(symtable **table, char *token_name)
{
	int h = is_present(table, token_name);
	symtable *ptr = table[h];

	if(h == -1)
		return -1;

	while (ptr != NULL)
	{
		if (strcmp(ptr->token_name, token_name) == 0)
		{
			break;
		}
		ptr = ptr->pred;
	}
	return ptr->token_type;
}

void display(symtable **table)
{
	int i;
	printf("_________________________________________\n");
	printf("|\tToken Name\t|\tType\t|\n");
	printf("_________________________________________\n");
	for (i = 0; i < HT_SIZE; i++)
	{
		symtable *itr = table[i];
		while (itr != NULL)
		{
			printf("|\t%s\t\t|\t%d\t|\n", table[i]->token_name, table[i]->token_type);
			itr = itr->pred;
		}
	}
	printf("_________________________________________\n");
}

parameter * create_parameter(char *id, int type)
{
	parameter * temp = (parameter *)malloc(sizeof(parameter));
	temp->id = (char *)malloc(sizeof(char)*(strlen(id)+1));
	strcpy(temp->id, id);
	temp->type = type;
	temp->next = NULL;
	return temp;
}

parameter * add_parameter(parameter *parameter_list, char *id, int type)
{
	if(parameter_list == NULL)
		return create_parameter(id, type);
	
	parameter * temp = parameter_list;
	
	while(temp->next != NULL)
		temp = temp->next;
	
	temp->next = create_parameter(id, type);

	return parameter_list;
}

void parameter_to_symtable(symtable ** table, parameter *parameter_list)
{
	while(parameter_list != NULL)
	{
		addIfNotPresent(table, parameter_list->id, parameter_list->type);
	}
}
