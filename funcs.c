// #include "func.h"

// int return_int_val(symtable **table, char *token_name, int scope)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}
// 	return ptr->value.intval;
// }

// char return_char_val(symtable **table, char *token_name, int scope)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}
// 	return ptr->value.charval;
// }

// char *return_str_val(symtable **table, char *token_name, int scope)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}
// 	return ptr->value.strval;
// }

// void *return_point_val(symtable **table, char *token_name, int scope, int offset)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}

// 	ptval *start = ptr->value.ptrval->ptr;

// 	int i = offset;
// 	while (i--)
// 	{
// 		if (start == NULL)
// 		{
// 			fprintf(stderr, "Array dimension exceeded");
// 		}
// 		start = start->next;
// 	}

// 	switch (ptr->token_type)
// 	{
// 		case I*I:
// 				return (int *)start->ptr;
// 			break;
	
// 		default:
// 			break;
// 	}
// }

// void add_int_val(symtable **table, char *token_name, int scope, int val)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}

// 	ptr->value.intval = val;
// 	ptval *temp = (ptval *)malloc(sizeof(ptval));
// 	temp->next = NULL;
// 	temp->ptr = (void *)&ptr->value.intval;
// 	ptr->value.ptrval = temp;
// }

// void add_char_val(symtable **table, char *token_name, int scope, char val)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}

// 	ptval *temp = (ptval *)malloc(sizeof(ptval));
// 	temp->next = NULL;
// 	temp->ptr = (void *)&ptr->value.charval;
// 	ptr->value.ptrval = temp;
// }

// void add_str_val(symtable **table, char *token_name, int scope, char *val)
// {
// 	int h = hash(token_name);
// 	symtable *ptr = table[h];
// 	while (ptr != NULL)
// 	{
// 		if (strcmp(ptr->token_name, token_name) == 0 && (ptr->scope == scope || ptr->token_type % FUNCTION == 0))
// 			break;
// 		ptr = ptr->pred;
// 	}
// 	char *tempc = (char *)malloc(sizeof(char) * (strlen(val) + 1));
// 	strcpy(tempc, val);
// 	ptr->value.strval = tempc;

// 	ptval *temp = (ptval *)malloc(sizeof(ptval));
// 	temp->next = NULL;
// 	temp->ptr = (void *)&ptr->value.strval;
// 	ptr->value.ptrval = temp;
// }

// void add_point_var(symtable **table, char *token_name, int scope, char *token)
// {
// 	int h = hash(token_name);
// 	symtable *ptr1 = table[h];
// 	while (ptr1 != NULL)
// 	{
// 		if (strcmp(ptr1->token_name, token_name) == 0 && (ptr1->scope == scope || ptr1->token_type % FUNCTION == 0))
// 			break;
// 		ptr1 = ptr1->pred;
// 	}

// 	h = hash(token);
// 	symtable *ptr2 = table[h];
// 	while (ptr2 != NULL)
// 	{
// 		if (strcmp(ptr2->token_name, token_name) == 0 && (ptr2->scope == scope || ptr2->token_type % FUNCTION == 0))
// 			break;
// 		ptr2 = ptr2->pred;
// 	}

// 	ptval *temp = (char *)malloc(sizeof(ptval));
// 	temp->next = NULL;
// 	temp->ptr = (void *)&(ptr2->value.ptrval->ptr);
// }
