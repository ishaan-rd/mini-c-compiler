%{
#include <stdio.h>
%}


alpha       [a-zA-Z]
digit       [0-9]
und         "_"
keyword     main|if|else|while|for|"else if"|break|void
datatype    int|char|struct|float|double
LT          "<"
GT          ">"
LE          "<="
GE          ">="
Assign      "="
EqualTo     "=="
Addition    "+"
Minus       "-"
Division    "/"
Multiplication  "*"
Inc         "++"
Dec         "--"
Mod         "%"
Not         "~"|"!"
LogOR       "||"
BitOR       "|"
LogAND      "&&"
BitAND      "&"
XOR         "^"
identifier  {alpha}({alpha}|{digit}|und)*
slcomment   "//"(.)*[\n]$
mlcomment   \/\*(.|\n)*\*\/
string      \"([^"])*\"
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"


%%

[;]             { printf ("Semicolon\n"); }
{preprocdir}    { printf ("Preprocessor: %s\n",yytext); }
{keyword}       { printf ("Keyword: %s\n",yytext); }
{datatype}      { printf ("Datatype %s\n",yytext); }
{slcomment}     { printf ("Single Line Comment %s\n",yytext); }
{mlcomment}     { printf ("Multi-line Comment \n"); }
{identifier}    { printf ("Identifier %s\n",yytext); }
[+-]?{digit}{1,5}   { printf ("Integer %s\n",yytext); }
[+-]?{digit}*"."{digit}{1,6} { printf ("Float %s\n",yytext); }
{string}        { printf ("String %s\n",yytext); }

%%


int yywrap() { return 1; }


void main() {
    printf ("Enter input\n");
    yylex();
}
<<<<<<< HEAD

/*
1. Error for nested and unmatched comments
2. "" in string
*/
=======
>>>>>>> 3627157e8119d4b154ebc59317ae3a3eb41943e8