# Implementación de un compilador simple del lenguaje "MICRO"

[Consigna original](https://www.campusvirtual.frba.utn.edu.ar/especialidad/pluginfile.php/279745/mod_resource/content/1/COMPILACION%20PARTE%201.pdf)

<hr>

### Definición informal

- El único tipo de dato es entero.
- Todos los identificadores son declarados implícitamente y con una longitud máxima de 32 caracteres.
- Los identificadores deben comenzar con una letra y están compuestos de letras y dígitos.
- Las constantes son secuencias de dígitos (números enteros).
- Hay dos tipos de sentencias:
	- `Asignación ID := Expresión;`  
	  `Expresión` es infija y se construye con identificadores, constantes y los operadores `+` y `–`; los paréntesis están permitidos.
	- Entrada/Salida
		- `leer (lista de IDs);`
		- `escribir (lista de Expresiones);`
- Cada sentencia termina con un "punto y coma" (`;`).
- El cuerpo de un programa está delimitado por `inicio` y `fin`. - `inicio`, `fin`, `leer` y `escribir` son palabras reservadas y deben escribirse en minúscula.

## Gramática

La gramática léxica y sintáctica del lenguaje Micro es muy simple, a continuación su definición en BNF.  

Representamos los terminales de un solo símbolo entre comillas simples, y aquellos que sean cadenas, entre comillas dobles.  
En el caso de `<letra>` y `<digito>` optamos por una abreviación para simplificar la expresión.

### Gramática léxica

```ebnf
<token> :=
		<identificador>
	| 	<constante>
	|	<palabraReservada>
	|	<operadorAditivo>
	|	<asignacion>
	|	<caracterPuntuacion>

<identificador> :=
		<letra>
	|	<identificador> <letraODigito>

<constante> :=
		<digito>
	|	<constante> <digito>

<letraODigito> :=
	<letra> | <digito>

<letra> := una de
	a-z A-Z

<digito> := uno de
	0-9

<palabraReservada> :=
	<inicio> | <fin> | <leer> | <escribir>

<inicio> := "inicio"
<fin> := "fin"
<leer> := "leer"
<escribir> := "escribir"

<operadorAditivo> :=
	'+' | '-'

<asignacion> :=
	":="

<caracterPuntuacion> :=
	<parenizq> | <parender> | <coma> | <pc>

<parenizq> := '('
<parender> := ')'
<coma> := ','
<pc> := ';'
```

### Gramática sintáctica

```ebnf
<programa> :=
	<inicio> <listaSentencias> <fin>

<listaSentencias> :=
		<sentencia>
	|	<listaSentencias> <sentencia>

<sentencia> :=
		<identificador> <asignacion> <expresion> <pc>
	| 	<leer> <parenizq> <listaIdentificadores> <parender> <pc>
	|	<escribir> <parenizq> <listaExpresiones> <parender> <pc> //esto no tiene mucho sentido

<listaIdentificadores> :=
		<identificador>
	|	<listaIdentificadores> <coma> <identificador>

<listaExpresiones> :=
		<expresion>
	|	<listaExpresiones> <coma> <expresion>

<expresion> :=
		<primaria>
	|	<expresion> <operadorAditivo> <expresion>

<primaria> :=
		<identificador>
	|	<constante>
	|	<parenizq> <expresion> <parender>
```

Entendemos que las funciones `leer` y `escribir` funcionan de la siguiente manera:

- `leer(lista de IDs)` imprime en pantalla el valor de cada identificador (inventado, en el documento no lo dice)
- `escribir()` ???????????

## Tokens

El lenguaje Micro cuenta con 13 Tokens:

| ER                       | Token      |
|--------------------------|------------|
| `[0-9]+`                 | CONSTANTE  |
| `[a-zA-Z][a-zA-Z0-9]*`   | ID         |
| `"inicio"`               | INICIO     |
| `"fin"`                  | FIN        |
| `"leer"`                 | LEER       |
| `"escribir"`             | ESCRIBIR   |
| `":="`                   | ASIGNACION |
| `\(`                     | PARENIZQ   |
| `\)`                     | PARENDER   |
| `,`                      | COMA       |
| `;`                      | PC         |
| `\+`                     | MAS        |
| `-`                      | MENOS      |

## Tabla de símbolos

En el caso de Micro, la TS contendrá los identificadores.  
Cada entrada tendrá como único atributo su valor asignado en caso de tenerlo, o `NULL` en caso contrario.

## Compilar

Doble click en el batchfile `compilar.bat` o ejecutar esto:

```
flex micro.l
bison -yd micro.y
gcc lex.yy.c y.tab.c -o micro
```

Los archivos `lex.yy.c, y.tab.c, y.tab.h` que están subidos son los de la última compilación hecha.