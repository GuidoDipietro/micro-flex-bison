flex scanner.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o micro_martina