flex scanner.l
bison -d parser.y
gcc -o micro lex.yy.c parser.tab.c TS.c