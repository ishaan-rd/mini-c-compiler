#ifndef ICG_H
#define ICG_H

#include <iostream>
#include <vector>

using namespace std;

void gencode(string);

void gencode_math(string left, string fi, string se, string op);

void displayICG();

const char *generateTemp();
// void printlist(vector<int>);

#endif