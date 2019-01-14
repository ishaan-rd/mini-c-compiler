%{
#include <stdio.h>
%}

keyword     main|if|else|while|for|"else if"|break|void
datatype    int|char|struct|float|double
operators   "<"|">"|"<="|">="|"="|"=="|"+"|"-"|"++"|"--"|"*"|"/"|"%"|"~"|"!"|"||"|"&&"
slcomment   "//"(.)*
mlcomment   "/*"(.|\n)*"*/"
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"

%%
{preprocdir}    { printf ("Preprocessor\n"); }
{keyword}       { printf ("Keyword!\n"); }
{datatype}      { printf ("Datatype!\n"); }
{operators}     { printf ("Operator!\n"); }
{slcomment}     { printf ("Single Line Comment\n"); }
{mlcomment}     { printf ("Multi-line Comment\n"); }
%%

int yywrap() { return 1; }

void main() {
    printf ("Enter input\n ");
    yylex();
}
