.SUFFIXES:

generated/prueba: generated/main.o generated/y.tab.o
	gcc -o generated/prueba generated/main.o generated/y.tab.o
generated/y.tab.o: generated/y.tab.c
	gcc -c generated/y.tab.c -o generated/y.tab.o
generated/main.o: main.c
	gcc -c main.c -o generated/main.o
generated/y.tab.c: generated/lex.yy.c yacc.y
	bison -v -d -o generated/y.tab.c yacc.y
generated/lex.yy.c: tokensLex.l
	flex -o generated/lex.yy.c -ll tokensLex.l
clean:
	rm -f -R generated/* *~
all:
	make clean
	make generated/prueba
