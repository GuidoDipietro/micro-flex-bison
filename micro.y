%{

void yyerror(char *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}

%union {
    int num;
    char* txt;
}

%token INICIO FIN LEER ESCRIBIR PARENIZQ PARENDER PC
%token <num> CONSTANTE
%token <txt> ID
%right ASIGNACION
%left MAS MENOS COMA

%%

/* Solo para probar si anda el FLEX */

prueba  :   token
        |   prueba token
;

token   :   CONSTANTE       {printf("constante: %d\n", $1);}
        |   ID              {printf("id: %s\n", $1);}
        |   INICIO          {printf("inicio\n");}
        |   FIN             {printf("fin\n");}
        |   LEER            {printf("leer\n");}
        |   ESCRIBIR        {printf("escribir\n");}
        |   PARENIZQ        {printf("parenizq\n");}
        |   PARENDER        {printf("parender\n");}
        |   COMA            {printf("coma\n");}
        |   PC              {printf("pc\n");}
        |   ASIGNACION      {printf("asignacion\n");}
        |   MAS             {printf("mas\n");}
        |   MENOS           {printf("menos\n");}
;

%%

int main(){
    return yyparse();
}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
} 