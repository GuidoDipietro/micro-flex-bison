%{
int yylex();

#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);

extern int yynerrs;
extern int yylexerrs;
%}

%token FDT INICIO FIN LEER ESCRIBIR PUNTOYCOMA
%token <id> ID
%token <cte> CONSTANTE
%union {
	char* id;
	int cte;
}
%left '+' '-' ',' 
%right ASIGNACION

%% 

programa	:	INICIO listaSentencias FIN
;

listaSentencias	:	sentencia 
				| 	listaSentencias sentencia
;

sentencia 	:	ID ASIGNACION expresion PUNTOYCOMA
			| LEER '(' listaIdentificadores ')' PUNTOYCOMA
			| ESCRIBIR '(' listaExpresiones ')' PUNTOYCOMA
;

listaIdentificadores	:	ID 
						| 	listaIdentificadores ',' ID
;

listaExpresiones	:	expresion 
					| 	listaExpresiones ','  expresion
;

expresion 	:	primaria 
			| expresion operadorAditivo primaria
;

primaria 	:	ID
			| CONSTANTE
			| '(' expresion ')'
;

operadorAditivo 	: '+'
					| '-'
;

%%

int yylexerrs = 0;

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main() {
	switch (yyparse()){
		case 0: printf("\n\nProceso de compilacion termino exitosamente");
		break;
		case 1: printf("\n\nErrores de compilacion");
		break;
		case 2: printf("\n\nNo hay memoria suficiente");
		break;
	}
	printf("\n\nErrores sintacticos: %i\tErrores lexicos: %i\n", yynerrs, yylexerrs);

	return 0;
}
