# Implementación de un compilador simple del lenguaje "MICRO"
<hr>

### Definición informal

- El único tipo de dato es entero.
- Todos los identificadores son declarados implícitamente y con una longitud máxima de
32 caracteres.
- Los identificadores deben comenzar con una letra y están compuestos de letras y
dígitos.
- Las constantes son secuencias de dígitos (números enteros).
- Hay dos tipos de sentencias:
	- `Asignación ID := Expresión;` Expresión es infija y se construye con
identificadores, constantes y los operadores `+` y `–`, los paréntesis están
permitidos.
	- Entrada/Salida
		- `leer (lista de IDs);`
		- `escribir (lista de Expresiones);`
- Cada sentencia termina con un "punto y coma" (`;`).
- El cuerpo de un programa está delimitado por `inicio` y `fin`. - `inicio`, `fin`, `leer` y `escribir` son palabras reservadas y deben escribirse en minúscula.

### Gramática
