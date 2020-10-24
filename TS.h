#ifndef TABLA_DE_SIMBOLOS
#define TABLA_DE_SIMBOLOS

// Tabla de símbolos per se
#define TAMAN_TS 100

typedef struct {
    char id[32]; // los IDs tienen hasta 32 caracteres
    int val;
} SIMBOLO;

// Funciones para leer/escribir a la TS
void init_TS(void);
int ValorSimbolo(char* s);
int IndiceTabla(char* s);
void EscribirATabla(char* s, int v);
void cargarEntradas(char* p1); // para Leer(IDs);

#endif