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
/* [+\-]?{digit}{1,5}"."{digit}{1,6} {return CONSTANT_FLOAT;}*/

%x CMNT
%x INCLUDE
%x DEFINE

%%

"int"                             {return INT;}
"long"                            {return LONG;}
"long long"                       {return LLONG;}
"short"                           {return SHORT;}
"char"                            {return CHAR;}

"for"                             {return FOR;}
"while"                           {return WHILE;}
"break"                           {return BREAK;}
"continue"                        {return CONTINUE;}
"return"                          {return RETURN;}
"if"                              {return IF;}
"else"                            {return ELSE;}

{ws}                              ;

{identifier}                      {yyval.token_name = yytext; return ID;}

[+\-]?[0][x|X]{hex}               {return CONSTANT_HEX;}
[+\-]?{digit}{1,5}                {return CONSTANT_INT;}
['].[']                           {return CONSTANT_CHAR;}
["].["]                           {return CONSTANT_STR;}


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

"--"			                        {return OP_DEC;}
"++"			                        {return OP_INC;}
"->"			                        {return OP_SPT;}
"&&"			                        {return OP_AND;}
"||"			                        {return OP_OR;}
"<"				                        {return OP_LT;}
">"				                        {return OP_GT;}
"<="			                        {return OP_LE;}
">="			                        {return OP_GE;}
"=="			                        {return OP_EE;}
"!="			                        {return OP_NE;}
"="				                        {return OP_ASS;}
"-"				                        {return OP_SUB;}
"+"				                        {return OP_ADD;}
"*"				                        {return OP_MUL;}
"/"		                            {return OP_DIV;}
"%"				                        {return OP_MOD;}

"&"                               {return OP_ADR;}

","				                        {return PUN_COM;}
"("				                        {return PUN_BO;}
")"				                        {return PUN_BC;}
"{"			                          {return PUN_FO;}  
"}"			                          {return PUN_FC;}
"["				                        {return PUN_SQO;}
"]"				                        {return PUN_SQC;}

.                                 {printf("ERROR %d : Illegal character %s\n",lineno,yytext);yyterminate();}
%%

int yywrap() { return 1; }

int main()
{
  yyin=fopen("test.c","r");
  yylex();
}