%{
    #include "a.tab.h"
%}

%%
"+"                 {return PL;}
"-"                 {return MINUS;}
"*"                 {return MUL;}
"/"                 {return DIV;}
"%"                 {return MOD;}
">"                 {return GT;}
">="                {return GTEQ;}
"<"                 {return LT;}
"<="                {return LTEQ;}
"<>"                {return NTEQ;}
":="                {return ASSIGN;}
"+="                {return PLASSIGN;}
"-="                {return MINUSASSIGN;}
"*="                {return MULASSIGN;}
"/="                {return DIVASSIGN;}
"%="                {return MODASSIGN;}
"("                                         {return OB;}
")"                                         {return CB;}
","                                         {return COMMA;}
";"                                         {return SEMICOLON;}
"{"                                         {return COB;}
"}"                                         {return CCB;}
"@"                                         {return AT;}
":"                                         {return COLON;}
\'                                          {return APOS;}
\"                                          {return DAPOS;}
"["                                         {return SOB;}
"]"                                         {return SCB;}
"print"                                     {return PRINT;}
"scan"                                      {return SCAN;}
"begin                                      {return BEGIN;}
"end"                                       {return END;}
"if"                                        {return IF;}
"else"                                      {return ELSE;}
"while"                                     {return WHILE;}
"for"                                       {return FOR;}
"do"                                        {return DO;}
"int"                                       {return INT;}
"char"                                      {return CHAR;}
"main"                                      {return MAIN;}
"program"                                   {return PROGRAM;}
"inc"                                       {return INC;}
"dec"                                       {return DEC;}
\n                                          {return NL;}
[ \t]+                                      {return TAB;}
[a-z][0-9a-zA-Z]+/_/[0-9a-zA-Z]+            {yylval = yytext;return ID;}
%%  
