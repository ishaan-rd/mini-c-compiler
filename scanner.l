%{
#include <stdio.h>
int openMComment = 0, closedMComment = 0;
%}

skip        "<"|">"|"("|")"|"."|"{"|"}"|","
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
<<<<<<< HEAD
identifier  ({alpha}|und)({alpha}|{digit}|und){1,31}
slcomment   "//"(.)*[\n]$
mlcomment   \/\*(.|\n)*\*\/
=======
identifier  {alpha}({alpha}|{digit}|und)*
slcomment   "//"(.)*$
mlcomment   "/*"(.|\n)*"*/"
mlcommenterr ("/*"(.|\n)* | "*/")
>>>>>>> 304093c19c1e98e76ec1aec29ce8f83e467cb327
string      \"([^"])*\"
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"


%%
<<<<<<< HEAD

[;]             { printf ("Semicolon\n"); }
{preprocdir}    { printf ("Preprocessor: %s\n",yytext); }
{keyword}       { printf ("Keyword: %s\n",yytext); }
{datatype}      { printf ("Datatype %s\n",yytext); }
{slcomment}     { printf ("Single Line Comment %s\n",yytext); }
{mlcomment}     { printf ("Multi-line Comment \n"); }
{identifier}    { printf ("Identifier %s\n",yytext); }
[-32768-32767]  {printf("%s - Integer Constant\n");}
[0-9]+[\.][0-9]{1-6} {printf("%s - Floating Point Constant\n");}
[0-9]+[\.][0-9]{6-12} {printf("%s - Double\n");}
[0-65535] {printf("%s - Unsigned Integer Constant\n");}
[-2147483648-2147483647] {printf("%s - Long Integer\n");}
[0- 4294967295] {printf("%s - Unsigned Long Integer\n");}
{string}        { printf ("String %s\n",yytext); }

=======
[ \n\t]+        {;}
{skip}          {;}
[;]             { printf ("Semicolon\n\n"); }
{mlcomment}     { printf ("Multi Line Comment %s\n\n",yytext); }
{preprocdir}    { printf ("Preprocessor: %s\n\n",yytext); }
{keyword}       { printf ("Keyword: %s\n\n",yytext); }
{datatype}      { printf ("Datatype %s\n\n",yytext); }
{slcomment}     { printf ("Single Line Comment %s\n\n",yytext); }
{identifier}    { printf ("Identifier %s\n\n",yytext); }
[+-]?{digit}{1,5}   { printf ("Integer %s\n\n",yytext); }
[+-]?{digit}*"."{digit}{1,6} { printf ("Float %s\n\n",yytext); }
{string}        { printf ("String %s\n\n",yytext); }
>>>>>>> 304093c19c1e98e76ec1aec29ce8f83e467cb327
%%


int yywrap() { return 1; }


void main() {
    extern FILE *yyin, *yyout;
    yyin = fopen("test.c", "r"); 
    yylex();
}
