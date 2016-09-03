%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror( const char * msg ) ;

int linea_actual = 1 ;
%}

%error-verbose

%token INICIO_PROGRAMA	
%token VARINI	
%token VARFIN
%token LEFT_CURLY
%token RIGHT_CURLY
%token TYPE
%token COMMA
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token EQUAL
%token SEMICOLON

%token IF
%token ELSE
%token WHILE
%token SELECT
%token CASE
%token ENTER
%token EXIT
%token RETURN
%token PLUSLESS
%token BOOL
%token LEFT_SQUARE_BRACKET
%token RIGHT_SQUARE_BRACKET
%token DOUBLE_QUOTE
%token SINGLE_QUOTE

%token OP_OR
%token OP_AND
%token OP_XOR
%token OP_NEQ_EQ
%token OP_REL
%token OP_PLUSLESS
%token OP_MUL

%token OP_DEC_PRE
%token OP_INC_PRE
%token OP_DEC_POS
%token OP_INC_POS
%token OP_INDEX

%token UNARY_OPERATOR
%token INT
%token FLOAT
%token CHAR
%token STRING
%token IDENTIFIER

%token BREAK 
%token COLON 

%left OP_OR
%left OP_AND
%left OP_XOR
%left OP_NEQ_EQ
%left OP_REL
%left OP_PLUSLESS
%left OP_MUL
%right UNARY_OPERATOR
%right OP_DEC_PRE
%right OP_INC_PRE
%left OP_DEC_POS
%left OP_INC_POS
%left OP_INDEX

%start Principal

%%
/* Sección de producciones que definen la gramática. */
Principal             : header_program block;

block                 : start_block local_var_dec sub_progs sentences end_block
                         | start_block local_var_dec sub_progs end_block;

sub_progs             : sub_progs sub_prog
                         | ;

sub_prog              : header_subprogram block;

local_var_dec         : VARINI local_var VARFIN
                         | ;

header_program        : INICIO_PROGRAMA
                         | error;

start_block           : LEFT_CURLY ;

end_block             : RIGHT_CURLY ;

local_var             : local_var var_body
                         | var_body;

var_body              : type array_or_id SEMICOLON
                         | type array_or_id error
                         | error;

type                  : primitive_type
                         | error;

primitive_type        : TYPE;

array_or_id	      : IDENTIFIER LEFT_SQUARE_BRACKET expr COMMA expr RIGHT_SQUARE_BRACKET
                         |  IDENTIFIER LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET
                         |  array_or_id COMMA IDENTIFIER
                         |  IDENTIFIER;

header_subprogram     : type IDENTIFIER LEFT_BRACKET parameters RIGHT_BRACKET
                         | type IDENTIFIER LEFT_BRACKET RIGHT_BRACKET;

parameters            : parameters COMMA type IDENTIFIER
                         |  type IDENTIFIER;

sentences             : sentences sentence
                         |  sentence;

sentence              : block
                         |  sentence_assign
                         |  sentence_if_then_else
                         |  sentence_while
                         |  sentence_input
                         |  sentence_output
                         |  sentence_return
                         |  sentence_switch;

sentence_assign       : IDENTIFIER EQUAL expr SEMICOLON;

sentence_if_then_else : IF LEFT_BRACKET expr RIGHT_BRACKET sentence
                         |  IF LEFT_BRACKET expr RIGHT_BRACKET sentence ELSE sentence;

sentence_while        : WHILE LEFT_BRACKET expr RIGHT_BRACKET sentence;

sentence_switch       : SELECT LEFT_BRACKET expr RIGHT_BRACKET start_block switch_cases end_block;

switch_cases          : CASE expr COLON switch_block switch_cases
                         |  CASE expr COLON switch_block;

switch_block          : local_var_dec sub_progs sentences BREAK SEMICOLON;

sentence_input        : ENTER STRING COMMA array_or_id
                         |  ENTER array_or_id;

sentence_output       : EXIT list_expr_string SEMICOLON;

list_expr_string      : list_expr_string COMMA expr_cad
                         |  expr_cad;

array                 : IDENTIFIER LEFT_SQUARE_BRACKET expr COMMA expr RIGHT_SQUARE_BRACKET
                         |  IDENTIFIER LEFT_SQUARE_BRACKET expr RIGHT_SQUARE_BRACKET;

expr_cad              : expr;
                        /* removed STRING, already contained in expr |  STRING;*/

expr                  : LEFT_BRACKET expr RIGHT_BRACKET
                         | OP_PLUSLESS expr %prec UNARY_OPERATOR
                         | UNARY_OPERATOR expr
                         | expr OP_PLUSLESS expr
                         | expr OP_MUL expr
                         | expr OP_REL expr
                         | expr OP_NEQ_EQ expr
                         | expr OP_OR expr
                         | expr OP_AND expr
                         | expr OP_XOR expr
                         | IDENTIFIER
                         | array
                         | const
                         | function_call
                         | error;
                         
sentence_return       : RETURN expr SEMICOLON;

function_call         : IDENTIFIER LEFT_BRACKET list_expr RIGHT_BRACKET
                         |  IDENTIFIER LEFT_BRACKET RIGHT_BRACKET;

list_expr             : list_expr COMMA expr
                         |  expr;

const                 : INT
                         | FLOAT
                         |  BOOL
                         |  CHAR
                         |  array_constant
                         |  STRING;

array_constant        : LEFT_SQUARE_BRACKET list_int_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_int_const SEMICOLON list_int_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_float_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_float_const SEMICOLON list_float_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_boolean_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_boolean_const SEMICOLON list_boolean_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_char_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_char_const SEMICOLON list_char_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_string_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_string_const SEMICOLON list_string_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_array_const RIGHT_SQUARE_BRACKET
                         |  LEFT_SQUARE_BRACKET list_array_const SEMICOLON list_array_const RIGHT_SQUARE_BRACKET;

list_int_const        : list_int_const COMMA INT
                         |  INT;

list_float_const      : list_float_const COMMA FLOAT
                         |  FLOAT;

list_boolean_const    : list_boolean_const COMMA BOOL
                         |  BOOL;

list_char_const       : list_char_const COMMA CHAR
                         |  CHAR;

list_string_const     : list_string_const COMMA STRING
                         |  STRING;

list_array_const      : list_array_const COMMA array_constant
                         |  array_constant;

%%

#include "./lex.yy.c"

void yyerror( const char *msg )
{
	fprintf(stderr,"[Linea %d]: %s\n", linea_actual, msg) ;
}

