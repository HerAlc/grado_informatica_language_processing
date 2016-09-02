#!/bin/bash

mkdir P2/bin

lex -o P2/bin/lex.yy.c tokensLex.l
cc -o P2/bin/prueba P2/bin/lex.yy.c -lfl -I.
P2/bin/prueba < $1
