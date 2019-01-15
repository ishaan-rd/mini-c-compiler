%{
#include <stdio.h>
%}

keyword     main|if|else|while|for|"else if"|break|void
datatype    int|char|struct|float|double
operators   "<"|">"|"<="|">="|"="|"=="|"+"|"-"|"++"|"--"|"*"|"/"|"%"|"~"|"!"|"||"|"&&"
identifier  [a-zA-Z][a-zA-z0-9_]*
digit       [0-9]
slcomment   "//"(.)*
mlcomment   "/*"(.|\n)*"*/"
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"

%%
{preprocdir}    { printf ("Preprocessor: %s\n",yytext); }
{keyword}       { printf ("Keyword: %s\n",yytext); }
{datatype}      { printf ("Datatype %s\n",yytext); }
{operators}     { printf ("Operator %s\n",yytext); }
{slcomment}     { printf ("Single Line Comment %s\n",yytext); }
{mlcomment}     { printf ("Multi-line Comment %s\n",yytext); }
{identifier}    { printf ("Identifier %s\n",yytext);}
";"             { printf ("Semicolon \n");}
%%

int yywrap() { return 1; }

void main() {
    printf ("Enter input\n ");
    yylex();
}
