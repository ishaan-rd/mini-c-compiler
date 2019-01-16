%{
#include <stdio.h>
void yyerror(char *s);
int lineno=0;
%}

keyword     main|if|else|while|for|"else if"|break|void
datatype    int|char|struct|float|double
operators   "<"|">"|"<="|">="|"="|"=="|"+"|"-"|"++"|"--"|"*"|"/"|"%"|"~"|"!"|"||"|"&&"
identifier  [a-zA-Z_][a-zA-z0-9_]*
digit       [0-9]
slcomment   "//"(.)*
mlcomment   "/*"(.|\n)*"*/"
string      "\""[^"]*"\""
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"

%%
{preprocdir}    { printf ("Preprocessor: %s\n",yytext); }
{keyword}       { printf ("Keyword: %s\n",yytext); }
{datatype}      { printf ("Datatype %s\n",yytext); }
{slcomment}     { printf ("Single Line Comment %s\n",yytext); }
{mlcomment}     { printf ("Multi-line Comment %s\n",yytext); }
{operators}     { printf ("Operator %s\n",yytext); }
{identifier}    { printf ("Identifier %s\n",yytext);}
";"             { printf ("Semicolon \n");}
[+-]?{digit}{1,5}   { printf ("Integer %s\n",yytext);}
[+-]?{digit}*"."{digit}{1,6} { printf ("Float %s\n",yytext);}
{string}        { printf ("String %s\n",yytext);}
[\n]            { line++;}
[ \t]            {;}
 [$]            { return(0);}
 .               {yyerror("error");}
%%
void yyerror(char* s)
{
    printf("%s",s);
}
int yywrap() { return 1; }

void main() {
    printf ("Enter input\n ");
    yylex();
    printf("lines %d",line);
}

/*
1. Error for nested and unmatched comments
2. "" in string
*/
