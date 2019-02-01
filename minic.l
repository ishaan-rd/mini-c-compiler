%{
#include <stdlib.h>
#include <stdio.h>
int cmnt_strt = 0, lineno = 1;
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
"for"                             {printf("looping        : %s\n",yytext);}
"while"                           {printf("looping        : %s\n",yytext);}
"break"                           {printf("keyword        : %s\n",yytext);}
"continue"                        {printf("keyword        : %s\n",yytext);}
"if"                              {printf("conditional    : %s\n",yytext);}
"else"                            {printf("conditional    : %s\n",yytext);}
"return"                          {printf("keyword        : %s\n",yytext);}
{identifier}                      {printf("identifier     : %s\n", yytext);}
{ws}                              ;
[+\-]?[0][x|X]{hex}               {printf("hex literal    : %s\n", yytext);}
[+\-]?{digit}{1,5}                {printf("int literal    : %s\n", yytext);}
[+\-]?{digit}{1,5}"."{digit}{1,6} {printf("float literal  : %s\n", yytext);}
['].[']                           {printf("char literal   : %s\n", yytext);}
"/*"                              {printf("Multiline comment start at lineno %d\n", lineno); cmnt_strt = lineno; BEGIN CMNT;}
<CMNT>.|{ws}                      ;
<CMNT>\n                          {lineno++;}
<CMNT>"*/"                        {printf("Multiline comment end at lineno %d\n", lineno); BEGIN INITIAL;}
<CMNT><<EOF>>                     {printf("ERROR %d : Invalid comments\n", cmnt_strt); yyterminate();}
^"#"[ ]*"include"                 {printf("preprocessor   : #include\n"); BEGIN INCLUDE;}
<INCLUDE>"<"[^<>\n]+">"           {printf("header file    : %s\n",yytext);}
<INCLUDE>{ws}                     ;
<INCLUDE>\"[^"\n]+\"              {printf("%s\n",yytext);}
<INCLUDE>\n                       {lineno++; BEGIN INITIAL;}
<INCLUDE>.                        {printf("ERROR %d : header name not valid \n",lineno);yyterminate();}
^"#"[ ]*"define"                  {printf("preprocessor   : #define\n");BEGIN DEFINE;}
<DEFINE>{ws}                      ;
<DEFINE>{identifier}              {printf("macro id       : %s\n", yytext);}
<DEFINE>{constant}                {printf("macro constant : %s\n", yytext); BEGIN INITIAL;}
"//".*                            {printf("Single line comment at lineno %d\n", lineno);};
"*/"                              {printf("ERROR %d : Invalid comments\n",lineno); yyterminate();}
\"(\\.|[^"\\])*\"                 {printf("string         : %s\n",yytext);}
\"[^\"\n]*$                       {printf("ERROR %d : Unterminated string %s\n",lineno,yytext);yyterminate();}
{digit}+({letter}|_)+	            {printf("ERROR %d : Illegal identifier name %s\n",lineno,yytext);yyterminate();}
\n                                {lineno++;}
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
","				                        {printf("Punctuator     : %s\n",yytext);}
"{"			                          {printf("Punctuator     : %s\n",yytext);}  
"}"			                          {printf("Punctuator     : %s\n",yytext);}
"("				                        {printf("Punctuator     : %s\n",yytext);}
")"				                        {printf("Punctuator     : %s\n",yytext);}
"["				                        {printf("Punctuator     : %s\n",yytext);}
"]"				                        {printf("Punctuator     : %s\n",yytext);}
.                                 {printf("ERROR %d : Illegal character %s\n",lineno,yytext);yyterminate();}
%%

int yywrap() { return 1; }

int main()
{
  yyin=fopen("test.c","r");
  yylex();
}