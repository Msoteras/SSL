%{
	#include<stdio.h>
	#include<stdlib.h>
	#include <string.h>
    #include "y.tab.h"

#ifndef yywrap
static int yywrap(void) {return 1;}
#endif

    void errorLexico();

%}
DIGITO [0-9]
LETRAS [a-zA-Z]
IDENTIFICADOR {LETRAS}({LETRAS}|{DIGITO})*
CARACTERPUNTUACION [(),;]
OPERADOR [+-]
ASIGNACION :=
CONSTANTE {DIGITO}+

%%
"inicio" 					{return (INICIO);};
"fin" 						{return (FIN);};
"leer" 						{return (LEER);};
"escribir" 					{return (ESCRIBIR);};
{DIGITO}+  					{yylval.num=atoi(yytext);return (CONSTANTE);};
{IDENTIFICADOR} 			{yylval.cadena = strdup(yytext); return(ID);};
"+" 						{yylval.cadena = strdup(yytext); return (OPERADOR);};
"-" 						{yylval.cadena = strdup(yytext); return (OPERADOR);};
":=" 						{return (ASIGNACION);};
"(" 						{return (PARIZQ);};
")" 						{return (PARDER);};
"," 						{return (COMA);};
";" 						{return (PUNTOYCOMA);};
[ \t\n]+ 					{;};
\0							{return(FDT);};
. 							{errorLexico();};

%%

void errorLexico() {
	printf("Error Lexico: %s no pudo ser identificado en la gramatica lexica de Micro \n",yytext);
	exit(-1);
}