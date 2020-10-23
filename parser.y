%{
int yylex();

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *s);

extern int yynerrs;
extern int yylexerrs;
extern FILE* yyin;

char* prueba[3]; 

/* Tabla de simbolos */
typedef struct {
    char id[32]; // los IDs tienen hasta 32 caracteres
    int val;
} SIMBOLO;
# define TAMAN_TS 100
SIMBOLO TS[TAMAN_TS];
int ValorSimbolo(char* s);
int IndiceTabla(char* s);
void EscribirATabla(char* s, int v);
void MostrarValorID(char* s); // para probar

void cargarPrueba(char* p1, char* p2, char* p3);

%}

%token FDT INICIO FIN LEER ESCRIBIR PUNTOYCOMA
%token <id> ID
%token <cte> CONSTANTE
%union {
    char* id;
    int cte;
}
%left '+' '-' ',' '*'
%right ASIGNACION

%type <cte> expresion primaria

%%

programa:
       INICIO listaSentencias FIN                       {if (yynerrs || yylexerrs) YYABORT; return -1}
; 

listaSentencias:
       sentencia 
    |  listaSentencias sentencia
;

sentencia:
       ID ASIGNACION expresion PUNTOYCOMA                 {EscribirATabla($1, $3);}         
    |  LEER '(' listaIdentificadores ')' PUNTOYCOMA     
    |  ESCRIBIR '(' listaExpresiones ')' PUNTOYCOMA
    |  ESCRIBIR ID PUNTOYCOMA                                { MostrarValorID($2); } /* esto desp se tiene que ir */

;

listaIdentificadores:
       ID                                                                                          
    |  listaIdentificadores ',' ID
;

listaExpresiones:
       expresion                                 {printf("%d\n", $1);}
    |  listaExpresiones ',' expresion            {printf("%d\n", $3);}
;

expresion:
       primaria                         {$$ = $1;}
    |  expresion '+' primaria           {$$ = $1 + $3;}
    |  expresion '-' primaria           {$$ = $1 - $3;}   
    |  expresion '*' expresion          {$$ = $1 * $3;}                      
;               

primaria:
       ID                           {$$ = ValorSimbolo($1);}
    |  CONSTANTE                    {$$ = $1;}
    |  '(' expresion ')'            {$$ = $2;}
;

%%

int yylexerrs = 0;

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

////// COSAS DE LA TS //////

// Esto es solamente para probar la TS
void MostrarValorID(char* s){
    int valor = ValorSimbolo(s);
    if (valor == -1)
        printf("No existe tal identificador!");
    else
        printf("%d\n\n", valor);
}

// Retorna valor de un ID si está en la TS, de lo contrario -1
int ValorSimbolo(char* s){
    int ind = IndiceTabla(s);
    if (ind<0) return -1;
    return TS[ind].val;
}

// Retorna el índice si está, o -1 si no
int IndiceTabla(char* s){
    int i=0;
    for (i; i<TAMAN_TS; i++)
        if (!strcmp(TS[i].id, s)) return i;
    return -1;
}

// Si ya está en la tabla lo actualiza, si no, crea una entrada
void EscribirATabla(char* s, int v){
    int ind = IndiceTabla(s);
    // No está en la TS
    if (ind == -1){
        int i=0;
        for (i; (i<TAMAN_TS && TS[i].val != -1); i++) // busca la primera entrada vacía
            ;
        if (i > TAMAN_TS){
            printf("No hay mas espacio en la TS.");
            return;
        }
        // Asigna ID y su valor
        TS[i].val = v;
        sprintf(TS[i].id, s);
    }
    // Sí está en la TS
    else
        TS[ind].val = v;
}

void cargarPrueba(char* p1, char* p2, char* p3){
    prueba[0] = p1;
    prueba[1] = p2;
    prueba[2] = p3;
}

////// MAIN //////

int main(int argc, char** argv) {
    
    // Argumentos
    if (argc > 2){
        printf("Numero incorrecto de argumentos.");
        return EXIT_FAILURE;
    }
    else if (argc == 2)
        yyin = fopen(argv[1], "r");
    else
        yyin = stdin;

    // Inicializar TS
    for(int i=0; i<TAMAN_TS; (TS[i].val = -1, i++)) // valores inadmitidos en Micro
        ;

    // Parser
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
