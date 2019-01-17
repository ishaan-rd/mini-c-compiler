%{
#include <stdio.h>
void yyerror(char *s);
int lineNo=0,comment=0,lastCommentClosed=1,lastCommentOpen=1;
%}

keyword     main|if|else|while|for|"else if"|break|void
datatype    int|char|struct|float|double
operators   "<"|">"|"<="|">="|"="|"=="|"+"|"-"|"++"|"--"|"*"|"/"|"%"|"~"|"!"|"||"|"&&"|"|"|"&"|"^"
identifier  [a-zA-Z_][a-zA-z0-9_]*
digit       [0-9]
slcomment   "//"(.)*
mlcomment   "/*"(.|\n)*"*/"
string      "\""[^"]*"\""
preprocdir  "#include"|"#define"|"#"|"#if"|"#else"|"#elif"|"#ifndef"|"#ifdef"|"#pragma"|"#line"|"#undef"|"#error"
line        [\n]
%%
{line}          {lineNo++;}
{preprocdir}    { printf ("Preprocessor: %s\n",yytext); }
{keyword}       { printf ("Keyword: %s\n",yytext); }
{datatype}      { printf ("Datatype %s\n",yytext); }
[/][*] {  comment++;
          printf("OPEN COMMENT\t\t%s\n\n",yytext);
          lastCommentOpen = lineNo;
        }
[*][/] {  comment--;
          printf("CLOSE COMMENT\t\t%s\n\n",yytext);
        lastCommentClosed = lineNo;}
{operators}     { printf ("Operator %s\n",yytext); }
{identifier}    { printf ("Identifier %s\n",yytext);}
[;]             { printf ("Semicolon \n");}
[+-]?{digit}{1,5}   { printf ("Integer %s\n",yytext);}
[+-]?{digit}*"."{digit}{1,6} { printf ("Float %s\n",yytext);}
{string}        { printf ("String %s\n",yytext);}
[ \t]            {;}
%%
void yyerror(char* s)
{
    printf("%s",s);
}
int yywrap() { return 1; }

void main() {
    printf ("Enter input\n ");
    yylex();
    printf("lines %d",lineNo);
    if(comment>0)
    printf("Error : Comment opened at Line Number %d not closed\n", lastCommentOpen);
    if(comment<0)
    printf("Error : Extra comment close at Line number %d\n", lastCommentClosed);
}

/*
1. Error for nested and unmatched comments
2. "" in string
3.
*/