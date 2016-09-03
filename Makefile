.SUFFIXES:

bin/prueba: bin/main.o bin/y.tab.o
	gcc -o bin/prueba bin/main.o bin/y.tab.o
bin/y.tab.o: bin/y.tab.c
	gcc -c bin/y.tab.c -o bin/y.tab.o
bin/main.o: main.c
	gcc -c main.c -o bin/main.o
bin/y.tab.c: bin/lex.yy.c yacc.y
	bison -v -d -o bin/y.tab.c yacc.y
bin/lex.yy.c: tokensLex.l
	flex -o bin/lex.yy.c -ll tokensLex.l
clean:
	rm -f -R bin/* *~
all:
	make clean
	make bin/prueba
