#include "icg.h"
#include <string.h>
#include <fstream>
#include <string>

int nextinstr = 0;
int temp_var_number = 0;
int toBuffer = 0;
vector<string> ICG;
vector<string> Buffer;

using namespace std;

void addToBuffer()
{
    toBuffer = 1;
}

void stopBuffer()
{
    toBuffer = 0;
}

void merge()
{
    for (int i = 0; i < Buffer.size(); i++)
    {
        gencode(Buffer[i]);
    }
    Buffer.clear();
}

void gencode(string x)
{
    std::string instruction;

    instruction = std::to_string(nextinstr) + string(": ") + x;
    if (!toBuffer){
        ICG.push_back(instruction);
        nextinstr++;
    }
    else
        Buffer.push_back(x);
}

void gencode_math(string left, string fi, string op, string se)
{
    std::string instruction;
    instruction = left + " = " + fi + " " + op + " " + se;
    gencode(instruction);
}

const char *generateTemp()
{
    string temp = "t" + std::to_string(temp_var_number);
    temp_var_number++;
    return temp.c_str();
}

void back_track(vector<int> &x, int line_no)
{
    for (int i = 0; i < x.size(); i++)
    {
        string instruction = ICG[x[i]];

        if (instruction.find("_") < instruction.size())
        {
            instruction.replace(instruction.find("_"), 1, to_string(line_no));
            ICG[x[i]] = instruction;
        }
    }
    x.clear();
}

int line_no()
{
    return nextinstr;
}

// void gencode_rel(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op)
// {
//     lhs->data_type = arg1->data_type;

//     lhs->truelist = {nextinstr};
//     lhs->falselist = {nextinstr + 1};

//     string code;

//     code = string("if ") + arg1->addr + op + arg2->addr + string(" goto _");
//     gencode(code);

//     code = string("goto _");
//     gencode(code);
// }

// void gencode_math(content_t *&lhs, content_t *arg1, content_t *arg2, const string &op)
// {
//     lhs->addr = "t" + std::to_string(temp_var_number);
//     std::string expr = lhs->addr + string(" = ") + arg1->addr + op + arg2->addr;
//     lhs->code = arg1->code + arg2->code + expr;

//     temp_var_number++;

//     gencode(expr);
// }

// void backpatch(vector<int> &v1, int number)
// {
//     for (int i = 0; i < v1.size(); i++)
//     {
//         string instruction = ICG[v1[i]];

//         if (instruction.find("_") < instruction.size())
//         {
//             instruction.replace(instruction.find("_"), 1, std::to_string(number));
//             ICG[v1[i]] = instruction;
//         }
//     }
// }

// vector<int> merge(vector<int> &v1, vector<int> &v2)
// {
//     vector<int> concat;
//     concat.reserve(v1.size() + v2.size());
//     concat.insert(concat.end(), v1.begin(), v1.end());
//     concat.insert(concat.end(), v2.begin(), v2.end());

//     return concat;
// }

void displayICG()
{
    ofstream outfile("icg.code");

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