%{

#include "y.tab.h"
#include <string.h>
int yylex();
void yyerror(char* s);

%}

%%

"leer"					{return LEER;}
"escribir"				{return ESCRIBIR;}
"inicio"				{return INICIO;}
"fin"					{return FIN;}
":="					{return ASIGNACION;}
\(						{return PARENIZQ;}
\)						{return PARENDER;}
,						{return COMA;}
;						{return PC;}
\+						{return MAS;}
-						{return MENOS;}
[0-9]+					{yylval.num = atoi(yytext); return CONSTANTE;}
[a-zA-Z][a-zA-Z0-9]*	{yylval.txt = strdup(yytext); return ID;}
[ \t\n]					{;}
.						{yyerror("Caracter incorrecto.");}

%%

int yywrap(void){
    return 1;
}