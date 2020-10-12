%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

void yyerror(char *s);
int yylex();

%}

digito                  [0-9]
letra                   [a-zA-Z]
identificador           {letra}({letra}|{digito})*
constante               ({digito})+

%%

"inicio"                return INICIO;
"fin"                   return FIN;
"leer"                  return LEER;
"escribir"              return ESCRIBIR;
{identificador}         {yylval.id = strdup(yytext); return ID;} 
{constante}             {yylval.cte = atoi(yytext); return CONSTANTE;}
"("                     return '(';
")"                     return ')';
";"                     return  PUNTOYCOMA;
"+"                     return '+';
"-"                     return '-';
","                     return ',';
":="                    return ASIGNACION;
[ \t\n]                 ;
.                       {ECHO; yyerror("Caracter Invalido");}

%%

int yywrap(void) {
    return 1;
}
