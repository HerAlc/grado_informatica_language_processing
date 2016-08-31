%{
#include <stdlib.h>
#include <string.h>
#include "tokens.h"
#define MAXLONBUFFER 200
char buffer[MAXLONBUFFER];
int lineaActual = 1;
%}

const_integer [0-9]+
const_float [0-9]+"."[0-9]*
string \"[^\"]+\"
const_char \'[^\']+\'
integer [0-9] 
identifier [a-zA-Z]([a-zA-Z]|[0-9])*
other .

%option noyywrap

%%

"Main" {printf("PRINCIPAL "); return INICIO_PROGRAMA;}
"iniVar" {printf("INIVAR "); return VARINI;}
"finVar" {printf("FINVAR "); return VARFIN;}
"{" {printf("LLAVEINI "); return LEFT_SQUARE_BRACKET;}
"}" {printf("LLAVEFIN "); return RIGHT_SQUARE_BRACKET;}
"entero" {printf("TYPE (0) "); return TYPE;}
"real" {printf("TYPE (1) "); return TYPE;}
"caracter" {printf("TYPE (2) "); return TYPE;}
"booleano" {printf("TYPE (3) "); return TYPE;}
"," {printf("COMA "); return COMMA;}
"("	{printf("PARENTINI "); return LEFT_BRACKET;}
")"	{printf("PARENTFIN "); return RIGHT_BRACKET;}
"=" {printf("IGUAL "); return EQUAL;}
";" {printf("PUNTOCOMA "); return SEMICOLON;}
"selecciona" {return SELECT;}
"caso" {return CASE;}
"romper" {return BREAK;}
"si" {printf("SI "); return IF;}
"sino" {printf("SINO "); return ELSE;}
"mientras" {printf("MIENTRAS "); return WHILE;}
"entrada" {printf("ENTRADA "); return ENTER;}
"salida" {printf("SALIDA "); return EXIT;}
"devolver" {printf("DEVOLVER "); return RETURN;}
"+"	{printf("MASMENOS (0) "); return PLUSLESS;}
"-"	{printf("MASMENOS (1) "); return PLUSLESS;}
"++" {printf("ANIADIR "); return UNARY_OPERATOR;}
"Verdadero" {printf("VALORBOOL (0) "); return BOOL;}
"Falso" {printf("VALORBOOL (1) "); return BOOL;}
"[" {printf("CORCHINI "); return LEFT_SQUARE_BRACKET;}
"]" {printf("CORCHFIN "); return RIGHT_SQUARE_BRACKET;}
"%" {printf("OPERBORRAR (1) "); return BINARY_OPERATOR;}
"xor" {printf("BINARY_OPERATOR (1) "); return BINARY_OPERATOR;}
"y" {printf("BINARY_OPERATOR (2) "); return BINARY_OPERATOR;}
"o" {printf("BINARY_OPERATOR (3) "); return BINARY_OPERATOR;}
"!=" {printf("BINARY_OPERATOR (4) "); return BINARY_OPERATOR;}
"==" {printf("BINARY_OPERATOR (5) "); return BINARY_OPERATOR;}
"<=" {printf("BINARY_OPERATOR (6) "); return BINARY_OPERATOR;}
">=" {printf("BINARY_OPERATOR (7) "); return BINARY_OPERATOR;}
"<" {printf("BINARY_OPERATOR (8) "); return BINARY_OPERATOR;}
">" {printf("BINARY_OPERATOR (9) "); return BINARY_OPERATOR;}
"*"	{printf("BINARY_OPERATOR (10) "); return BINARY_OPERATOR;}
"/"	{printf("BINARY_OPERATOR (11) "); return BINARY_OPERATOR;}
"!" {printf("OPERADORUNA "); return UNARY_OPERATOR;}
{const_integer} {printf("ENTERO "); return INT;}
{const_float} {printf("REAL "); return FLOAT;}
{const_char} {printf("CARACTER "); return CHAR;}
{string} {printf("CADENA "); return STRING;}
{identifier}	{printf("IDENTIFICADOR "); return IDENTIFIER;}
[ \t]+
\n	++linea_actual ;
{other}		printf ("\n(Linea %d) Error lexico: token %s\n", linea_actual, yytext);
%%
main () 
{
	int val;
	val= yylex() ;
	while (val != 0) 
	{
		printf ("%s -> Codigo: %d\n", yytext, val); 
		val= yylex() ;
	}
	exit (1); 
}
