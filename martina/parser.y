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
%union{
	char* id;
	int cte;
}
%left '+' '-' ',' 
%right ASIGNACION

%% 

programa:
	INICIO listaSentencias FIN;

listaSentencias:
	sentencia 
	| listaSentencias sentencia;

sentencia:
	ID ASIGNACION expresion PUNTOYCOMA
	| LEER '(' listaIdentificadores ')' PUNTOYCOMA
	| ESCRIBIR '(' listaExpresiones ')' PUNTOYCOMA;

listaIdentificadores:
	ID 
	| listaIdentificadores ',' ID ;

listaExpresiones:
	expresion 
	| listaExpresiones ','  expresion;

expresion:
	primaria 
	| expresion operadorAditivo primaria;

primaria:
	ID
	| CONSTANTE
	| '(' expresion ')';

operadorAditivo: 
	'+'
	| '-';

%%

int yylexerrs = 0;

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main() {
	//printf("\n --------------------------------------------");
	switch (yyparse()){
		case 0: printf("\n\n Proceso de compilacion termino exitosamente");
		break;
		case 1: printf("\n\n Errores de compilacion");
		break;
		case 2: printf("\n\n No hay memoria suficiente");
		break;
	}
	printf("\n\n Errores sintacticos:  %i\t  Errores lexicos:  %i\n", yynerrs, yylexerrs);
	printf("\n ------------------------------------------- \n\n");
	return 0;
}