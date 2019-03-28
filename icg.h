#ifndef ICG_H
#define ICG_H

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

void type_check(int, int, int);
vector<int> merge(vector<int> &v1, vector<int> &v2);
void backpatch(vector<int> &, int);
void gencode(string);
void gencode_math(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op);
void gencode_rel(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op);
// void printlist(vector<int>);

#endif