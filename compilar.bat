flex micro.l
bison -yd micro.y
gcc lex.yy.c y.tab.c -o micro