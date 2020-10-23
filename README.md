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

#### Agregados personales
Implementamos además el operador `*` que funciona como la multiplicación corriente, y un bucle `escribirVeces` que equivale a un `for` que llama a un `printf` una cantidad de veces indicada.  
Ejemplos de uso:

```C
cuenta := 1+4*2+7*(((4)))+9;
escribir(cuenta);
46

n := 3;
imprimir cuenta n+1 veces;
46
46
46
46
```

## Gramática

La gramática léxica y sintáctica del lenguaje Micro (con nuestros agregados) es muy simple, a continuación su definición en BNF.  

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
<imprimir> := "imprimir"
<veces> := "veces"

<operadorAditivo> :=
	'+' | '-'

<mul> := '*'

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
	|	<escribir> <parenizq> <listaExpresiones> <parender> <pc>
	|	<imprimir> <expresion> <expresion> <veces> <pc>

<listaIdentificadores> :=
		<identificador>
	|	<listaIdentificadores> <coma> <identificador>

<listaExpresiones> :=
		<expresion>
	|	<listaExpresiones> <coma> <expresion>

<expresion> :=
		<termino>
	|	<expresion> <operadorAditivo> <termino>

<termino> :=
		<primaria>
	|	<termino> <mul> <primaria>

<primaria> :=
		<identificador>
	|	<constante>
	|	<parenizq> <expresion> <parender>
```

Las funciones `leer` y `escribir` funcionan de la siguiente manera:

- `leer(lista de IDs)` asigna los valores dados a los IDs proporcionados. Por ejemplo:  
<!-- CAMBIAR -->
```C
leer(a,b,c);
// se ingresa "14 27 49"
// ahora a==14, b==27, c==49
```
- `escribir(lista de sentencias)` se muestra en pantalla el valor de las sentencias indicadas. Ejemplo:
```C
a := 14;
be := 27;
escribir (a, be, 1+a+be*2);
14
27
69
```

## Tokens

El lenguaje Micro cuenta con 16 Tokens:

| ER                       | Token      |
|--------------------------|------------|
| `[0-9]+`                 | CONSTANTE  |
| `[a-zA-Z][a-zA-Z0-9]*`   | ID         |
| `"inicio"`               | INICIO     |
| `"fin"`                  | FIN        |
| `"leer"`                 | LEER       |
| `"escribir"`             | ESCRIBIR   |
| `"imprimir"`             | IMPRIMIR   |
| `"veces"`                | VECES      |
| `":="`                   | ASIGNACION |
| `\(`                     | '('        |
| `\)`                     | ')'        |
| `,`                      | ','        |
| `;`                      | PUNTOYCOMA |
| `\+`                     | '+'        |
| `-`                      | '-'        |
| `*`                      | '\*'       |

## Tabla de símbolos

En el caso de Micro, la TS contendrá los identificadores.  
Cada entrada tendrá como único atributo su valor asignado en caso de tenerlo, o `-1` en caso contrario.

## Compilar y ejecutar

Doble click en el batchfile `compilar.bat` o ejecutar esto:

```
flex micro.l
bison -yd micro.y
gcc lex.yy.c y.tab.c -o micro
```

Se puede ejecutar `micro` para poder ingresar texto en consola que será evaluado por el compilador, o bien `micro archivo.txt` para que el compilador evalúe el contenido del archivo `archivo.txt` indicado.
