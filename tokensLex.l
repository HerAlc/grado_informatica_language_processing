%{
#include <stdlib.h>
#include <string.h>
//#include "tokens.h"
#define MAXLONBUFFER 200
char buffer[MAXLONBUFFER];
int lineaActual = 1;
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

"Principal"     {printf("PRINCIPAL \n");            return INICIO_PROGRAMA;}
"iniVar"        {printf("INIVAR \n");               return VARINI;}
"finVar"        {printf("FINVAR \n");               return VARFIN;}
"{"             {printf("LLAVEINI \n");             return LEFT_CURLY;}
"}"             {printf("LLAVEFIN \n");             return RIGHT_CURLY;}
"entero"        {printf("TYPE (0) \n");             return TYPE;}
"real"          {printf("TYPE (1) \n");             return TYPE;}
"caracter"      {printf("TYPE (2) \n");             return TYPE;}
"booleano"      {printf("TYPE (3) \n");             return TYPE;}
","             {printf("COMA \n");                 return COMMA;}
":"             {printf("COLON \n");                return COLON;}
"("             {printf("PARENTINI \n");            return LEFT_BRACKET;}
")"             {printf("PARENTFIN \n");            return RIGHT_BRACKET;}
"="             {printf("IGUAL \n");                return EQUAL;}
";"             {printf("PUNTOCOMA \n");            return SEMICOLON;}
"selecciona"    {printf("SELECCIONA \n");           return SELECT;}
"caso"          {printf("CASO \n");                 return CASE;}
"romper"        {printf("ROMPER \n");               return BREAK;}
"si"            {printf("SI \n");                   return IF;}
"sino"          {printf("SINO \n");                 return ELSE;}
"mientras"      {printf("MIENTRAS \n");             return WHILE;}
"entrada"       {printf("ENTRADA \n");              return ENTER;}
"salida"        {printf("SALIDA \n");               return EXIT;}
"devolver"      {printf("DEVOLVER \n");             return RETURN;}
"+"             {printf("MASMENOS (0) \n");         return OP_PLUSLESS;}
"-"             {printf("MASMENOS (1) \n");         return OP_PLUSLESS;}
"++"            {printf("ANIADIR \n");              return UNARY_OPERATOR;}
"Verdadero"     {printf("VALORBOOL (0) \n");        return BOOL;}
"Falso"         {printf("VALORBOOL (1) \n");        return BOOL;}
"["             {printf("CORCHINI \n");             return LEFT_SQUARE_BRACKET;}
"]"             {printf("CORCHFIN \n");             return RIGHT_SQUARE_BRACKET;}
"%"             {printf("OPERBORRAR (1) \n");       return OP_MUL;}
"xor"           {printf("BINARY_OPERATOR (1) \n");  return OP_XOR;}
"y"             {printf("BINARY_OPERATOR (2) \n");  return OP_AND;}
"o"             {printf("BINARY_OPERATOR (3) \n");  return OP_OR;}
"!="            {printf("BINARY_OPERATOR (4) \n");  return OP_NEQ_EQ;}
"=="            {printf("BINARY_OPERATOR (5) \n");  return OP_NEQ_EQ;}
"<="            {printf("BINARY_OPERATOR (6) \n");  return OP_REL;}
">="            {printf("BINARY_OPERATOR (7) \n");  return OP_REL;}
"<"             {printf("BINARY_OPERATOR (8) \n");  return OP_REL;}
">"             {printf("BINARY_OPERATOR (9) \n");  return OP_REL;}
"*"             {printf("BINARY_OPERATOR (10) \n"); return OP_MUL;}
"/"             {printf("BINARY_OPERATOR (11) \n"); return OP_MUL;}
"!"             {printf("OPERADORUNA \n");          return UNARY_OPERATOR;}
{const_integer} {printf("ENTERO \n");               return INT;}
{const_float}   {printf("REAL \n");                 return FLOAT;}
{const_char}    {printf("CARACTER \n");             return CHAR;}
{string}        {printf("CADENA \n");               return STRING;}
{identifier}	{printf("IDENTIFICADOR \n");        return IDENTIFIER;}
[ \t]+
\n	        ++lineaActual ;
{other}		printf ("\n\n(Linea %d) ERROR LÉXICO: TOKEN %s\n\n", lineaActual, yytext);

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
