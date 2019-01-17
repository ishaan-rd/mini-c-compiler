%{
#include <stdio.h>

int lineNo = 0;
%}

alpha       [a-zA-Z]
digit       [0-9]
und         "_"
keyword     main|if|else|while|for|"else if"|break|void|return
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
slcomment   "//"(.)*$
string      \"([^"])*\"
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"
mlcomment   "/*"([^*]|\*+[^*/])*\*+"/"
mlcommenterr ("/*"(.|\n)*|.*"*/")

%%
{mlcomment}     { printf ("Multi Line Comment %s\n\n",yytext); }
[ \n\t]+        {;}
[;]             { printf ("Semicolon\n\n"); }
{slcomment}     { printf ("Single Line Comment %s\n\n",yytext); }
{preprocdir}.*$    { printf ("Preprocessor: %s\n\n",yytext); }
{keyword}       { printf ("Keyword: %s\n\n",yytext); }
{datatype}      { printf ("Datatype %s\n\n",yytext); }
{identifier}    { printf ("Identifier %s\n\n",yytext); }
[+-]?{digit}{1,5}   { printf ("Integer %s\n\n",yytext); }
[+-]?{digit}*"."{digit}{1,6} { printf ("Float %s\n\n",yytext); }
{string}        { printf ("String %s\n\n",yytext); }
%%


int yywrap() { return 1; }


void main() {
    extern FILE *yyin, *yyout;
    yyin = fopen("test.c", "r"); 
    yylex();
}
