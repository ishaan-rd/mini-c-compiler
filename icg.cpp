#include "icg.h"
#include <fstream>
#include <string>

int is_declaration = 0;
int is_loop = 0;
int is_func = 0;
int func_type;
int param_list[10];
int p_idx = 0;
int p = 0;
int rhs = 0;
int nextinstr = 0;
int temp_var_number = 0;
vector<string> ICG;

using namespace std;

void gencode(string x)
{
    std::string instruction;

    instruction = std::to_string(nextinstr) + string(": ") + x;
    ICG.push_back(instruction);
    nextinstr++;
}

void gencode_rel(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op)
{
    lhs->data_type = arg1->data_type;

    lhs->truelist = {nextinstr};
    lhs->falselist = {nextinstr + 1};

    string code;

    code = string("if ") + arg1->addr + op + arg2->addr + string(" goto _");
    gencode(code);

    code = string("goto _");
    gencode(code);
}

void gencode_math(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op)
{
    lhs->addr = "t" + std::to_string(temp_var_number);
    std::string expr = lhs->addr + string(" = ") + arg1->addr + op + arg2->addr;
    lhs->code = arg1->code + arg2->code + expr;

    temp_var_number++;

    gencode(expr);
}

void backpatch(vector<int> &v1, int number)
{
    for (int i = 0; i < v1.size(); i++)
    {
        string instruction = ICG[v1[i]];

        if (instruction.find("_") < instruction.size())
        {
            instruction.replace(instruction.find("_"), 1, std::to_string(number));
            ICG[v1[i]] = instruction;
        }
    }
}

vector<int> merge(vector<int> &v1, vector<int> &v2)
{
    vector<int> concat;
    concat.reserve(v1.size() + v2.size());
    concat.insert(concat.end(), v1.begin(), v1.end());
    concat.insert(concat.end(), v2.begin(), v2.end());

    return concat;
}

void displayICG()
{
    ofstream outfile("ICG.code");

    for (int i = 0; i < ICG.size(); i++)
        outfile << ICG[i] << endl;

    outfile << nextinstr << ": exit";

    outfile.close();
}

// void printlist(vector<int> v)
// {
//     for (auto it : v)
//         cout << it << " ";
//     cout << "Next: " << nextinstr << endl;
// }