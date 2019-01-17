%{

#include <stdlib.h>
#include <stdio.h>
int cmnt_strt = 0, yylineno = 0;
%}

letter [a-zA-Z]
digit [0-9]
ws  [ \t\r\f\v]+
identifier (_|{letter})({letter}|{digit}|_){0,31}
hex [0-9a-f]
constant  {digit}+|{digit}+"."{digit}+|["].*["]|['].[']

 /* Exclusive states */
%x CMNT
%x INCLUDE
%x DEFINE

%%
";"   	                          {printf("semicolon\n");}
"int"                             {printf("datatype       : %s\n",yytext);}
"long"                            {printf("datatype       : %s\n",yytext);}
"long long"                       {printf("datatype       : %s\n",yytext);}
"short"                           {printf("datatype       : %s\n",yytext);}
"signed"                          {printf("datatype       : %s\n",yytext);}
"unsigned"                        {printf("datatype       : %s\n",yytext);}
"char"                            {printf("datatype       : %s\n",yytext);}
"for"                             {printf("keyword        : %s\n",yytext);}
"break"                           {printf("keyword        : %s\n",yytext);}
"continue"                        {printf("keyword        : %s\n",yytext);}
"if"                              {printf("keyword        : %s\n",yytext);}
"else"                            {printf("keyword        : %s\n",yytext);}
"return"                          {printf("keyword        : %s\n",yytext);}
{identifier}                      {printf("identifier     : %s\n", yytext);}
{ws}                              ;
[+\-]?[0][x|X]{hex}               {printf("literal        : %s\n", yytext);}
[+\-]?{digit}                     {printf("literal        : %s\n", yytext);}
"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;}
<CMNT>.|{ws}                      ;
<CMNT>\n                          {yylineno++;}
<CMNT>"*/"                        {BEGIN INITIAL;}
<CMNT>"/*"                        {printf("%d: Invalid comments\n",yylineno);}
<CMNT><<EOF>>                     {printf("%d: Invalid comments\n", cmnt_strt); yyterminate();}
^"#"[ ]*"include"                 {printf("preprocessor   : #include\n"); BEGIN INCLUDE;}
<INCLUDE>"<"[^<>\n]+">"           {printf("header file    : %s\n",yytext);}
<INCLUDE>{ws}                     ;
<INCLUDE>\"[^"\n]+\"              {printf("%s\n",yytext);}
<INCLUDE>\n                       {yylineno++; BEGIN INITIAL;}
<INCLUDE>.                        {printf("%d: header name not valid \n",yylineno);}
^"#"[ ]*"define"                  {printf("preprocessor   : #define\n");BEGIN DEFINE;}
<DEFINE>{ws}                      ;
<DEFINE>{identifier}              {printf("macro id       : %s\n", yytext);}
<DEFINE>{constant}                {printf("macro constant : %s\n", yytext); BEGIN INITIAL;}
"//".*                            ;
\"(\\.|[^"\\])*\"                 {printf("string\n");}
\"[^\"\n]*$                       {printf("%d: Unterminated string %s\n",yylineno,yytext);}
{digit}+({letter}|_)+	            {printf("%d: Illegal identifier name %s\n",yylineno,yytext);}
\n                                {yylineno++;}
"--"			                        {printf("operator       : %s\n",yytext);}
"++"			                        {printf("operator       : %s\n",yytext);}
"->"			                        {printf("operator       : %s\n",yytext);}
"&&"			                        {printf("operator       : %s\n",yytext);}
"||"			                        {printf("operator       : %s\n",yytext);}
"<="			                        {printf("operator       : %s\n",yytext);}
">="			                        {printf("operator       : %s\n",yytext);}
"=="			                        {printf("operator       : %s\n",yytext);}
"!="			                        {printf("operator       : %s\n",yytext);}
"-"				                        {printf("operator       : %s\n",yytext);}
"+"				                        {printf("operator       : %s\n",yytext);}
"*"				                        {printf("operator       : %s\n",yytext);}
"/"		                            {printf("operator       : %s\n",yytext);}
"%"				                        {printf("operator       : %s\n",yytext);}
"<"				                        {printf("operator       : %s\n",yytext);}
">"				                        {printf("operator       : %s\n",yytext);}
"="				                        {printf("operator       : %s\n",yytext);}
","				                        {printf("comma          : %s\n",yytext);}
"{"			                          {printf("paranthesis    : %s\n",yytext);}  
"}"			                          {printf("paranthesis    : %s\n",yytext);}
"("				                        {printf("paranthesis    : %s\n",yytext);}
")"				                        {printf("paranthesis    : %s\n",yytext);}
"["				                        {printf("paranthesis    : %s\n",yytext);}
"]"				                        {printf("paranthesis    : %s\n",yytext);}
.                                 {printf("%d: Illegal character %s\n",yylineno,yytext);}

%%

int yywrap() { return 1; }

int main()
{
  yyin=fopen("test.c","r");
  yylex();
}