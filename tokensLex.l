%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#define MAXLONBUFFER 200
char buffer[MAXLONBUFFER];
%}

const_integer  [0-9]+
const_float    [0-9]+"."[0-9]*
string         \"[^\"]+\"
const_char     \'[^\']+\'
integer        [0-9] 
identifier     [a-zA-Z]([a-zA-Z]|[0-9])*
other          .

%option noyywrap

%%

"Principal"     {return INICIO_PROGRAMA;}
"iniVar"        {return VARINI;}
"finVar"        {return VARFIN;}
"{"             {return LEFT_CURLY;}
"}"             {return RIGHT_CURLY;}
"entero"        {yylval.lexema = strdup (yytext); yylval.atrib = 0; yylval.tipo = entero;   return TYPE;}
"real"          {yylval.lexema = strdup (yytext); yylval.atrib = 1; yylval.tipo = real;     return TYPE;}
"caracter"      {yylval.lexema = strdup (yytext); yylval.atrib = 2; yylval.tipo = caracter; return TYPE;}
"booleano"      {yylval.lexema = strdup (yytext); yylval.atrib = 3; yylval.tipo = booleano; return TYPE;}
","             {return COMMA;}
":"             {return COLON;}
"("             {return LEFT_BRACKET;}
")"             {return RIGHT_BRACKET;}
"="             {return EQUAL;}
";"             {return SEMICOLON;}
"selecciona"    {return SELECT;}
"caso"          {return CASE;}
"romper"        {return BREAK;}
"si"            {return IF;}
"sino"          {return ELSE;}
"mientras"      {return WHILE;}
"entrada"       {return ENTER;}
"salida"        {return EXIT;}
"devolver"      {return RETURN;}
"+"             {return OP_PLUSLESS;}
"-"             {return OP_PLUSLESS;}
"++"            {return UNARY_OPERATOR;}
"Verdadero"     {return BOOL;}
"Falso"         {return BOOL;}
"["             {return LEFT_SQUARE_BRACKET;}
"]"             {return RIGHT_SQUARE_BRACKET;}
"%"             {return OP_MUL;}
"xor"           {return OP_XOR;}
"y"             {return OP_AND;}
"o"             {return OP_OR;}
"!="            {return OP_NEQ_EQ;}
"=="            {return OP_NEQ_EQ;}
"<="            {return OP_REL;}
">="            {return OP_REL;}
"<"             {return OP_REL;}
">"             {return OP_REL;}
"*"             {return OP_MUL;}
"/"             {return OP_MUL;}
"!"             {return UNARY_OPERATOR;}
{const_integer} {return INT;}
{const_float}   {return FLOAT;}
{const_char}    {return CHAR;}
{string}        {return STRING;}
{identifier}	{return IDENTIFIER;}
[ \t]+
\n	        ++linea_actual ;
{other}		printf ("\n\n(Linea %d) ERROR LÉXICO: TOKEN %s\n\n", linea_actual, yytext);

%%

// main () 
// {
// 	int val;
// 	val= yylex() ;
// 	while (val != 0) 
// 	{
// 		printf ("%s -> Código: %d\n", yytext, val); 
// 		val= yylex() ;
// 	}
// 	exit (1); 
// }
