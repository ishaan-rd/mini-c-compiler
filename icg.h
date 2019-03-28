#ifndef ICG_H
#define ICG_H

#include "symboltable.h"
#include <iostream>
#include <vector>

using namespace std;
struct content_t
{
	vector<int> truelist;
	vector<int> falselist;
	vector<int> nextlist;
	vector<int> breaklist;
	vector<int> continuelist;
	string addr;
	string code;
	int data_type;
};

int is_declaration = 0;
int is_loop = 0;
int is_func = 0;
int func_type;
int param_list[10];
int p_idx = 0;
int p = 0;
int rhs = 0;

void type_check(int, int, int);
vector<int> merge(vector<int> &v1, vector<int> &v2);
void backpatch(vector<int> &, int);
void gencode(string);
void gencode_math(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op);
void gencode_rel(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op);
void printlist(vector<int>);

int nextinstr = 0;
int temp_var_number = 0;

vector<string> ICG;

#endif