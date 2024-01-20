%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
#include"funcionesDeListas.h" 

#define LONGMAX 32+1
#define VACIO -1

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

int yywrap(){	
    return 1;
}

FILE* yyin;
FILE* yyout;

/************** Listas **************/

Datos dato;

Lista tablaDeSimbolos;
Lista identificadoresSinValor;
 
void completarIdentificadores(Lista*);
int valorAsociadoIdentificador(char*, Lista*); 
NodoIdentificador* buscarIdentificadorEnTS(char*,Lista*);
int leerElValorDelIdentificador(char*);
void mostrarExpresion(int valorExpresion);
int operar(int ,char* ,int );
void errorSintactico(char*);
void errorSemantico(char*);
void finalizacion(void);

%}
%union {
    char* cadena; 
    int num; 
    char caracter;
}

%token COMA PUNTOYCOMA INICIO LEER ESCRIBIR FIN ASIGNACION FDT
%token <cadena> ID OPERADOR
%token <caracter> PARIZQ PARDER
%token <num> CONSTANTE 

%type <num> expresion listaExpresiones primaria

%left OPERADOR

%%

objetivo: programa FDT
programa: INICIO listaSentencias FIN {
    printf("Fin compilacion <3\n");
    
    finalizacion();
    
};

/************** Gramatica Sintactica Micro **************/

listaSentencias: sentencia 
                 | listaSentencias sentencia; 

sentencia: ID ASIGNACION expresion PUNTOYCOMA                   {dato.nombre = strdup($1); dato.valor = $3; agregarIdentificador(&tablaDeSimbolos, dato);}
          | LEER PARIZQ listaIdentificadores PARDER PUNTOYCOMA  {completarIdentificadores(&identificadoresSinValor);}
          | ESCRIBIR PARIZQ listaExpresiones PARDER PUNTOYCOMA  {;}


listaIdentificadores: ID                            {agregarIdentificadorSinValor($1);};
                    | ID COMA listaIdentificadores  {agregarIdentificadorSinValor($1);};


listaExpresiones: expresion {;}
                | expresion COMA listaExpresiones   {;};


expresion: primaria {;};
         | expresion OPERADOR primaria       {$$=operar($1,$2,$3);};

primaria: ID                        {$$ = valorAsociadoIdentificador($1, &tablaDeSimbolos);}
        | CONSTANTE                 {$$ = $1;}
        | PARIZQ expresion PARDER   {printf("%c ",$1);
                                     mostrarExpresion($2);
                                     printf("%c ",$3);};

%%

int main(){

    yyin = fopen("entrada.txt","r");
    yyout = fopen("salida.txt","w");

    yyparse();
   
};

/************** Rutinas Semanticas **************/

int leerElValorDelIdentificador(char* identificador){
    int registroSemantico;
    printf("Ingrese el registro semantico (valor) para el identificador %s: ", identificador);
    scanf("%d", &registroSemantico);
    return registroSemantico;
}

void completarIdentificadores(Lista* identificadoresSinValor){
    Datos dato;
    int valor = VACIO;
    NodoIdentificador* nodo = identificadoresSinValor->cabeza;

    while(nodo != NULL){
        valor = leerElValorDelIdentificador(nodo->info.nombre);
        dato.nombre = strdup(nodo->info.nombre);
        dato.valor = valor;
        agregarIdentificador(&tablaDeSimbolos, dato);
        nodo = nodo->siguiente;
    }
}

int operar(int a,char* operador,int b){
    int resultado = 0;
    char c = operador[0];
    switch(c){
        case '+': 
                resultado = a + b;
                break;
        case '-' : 
                resultado = a - b;
                break;
        default: 
                break;
    }
    return resultado;
}

void mostrarResultado(int a){
    printf("%d",a);
}

int valorAsociadoIdentificador(char* identificador, Lista* lista){
    NodoIdentificador* nodo = buscarIdentificadorEnTS(identificador, lista);
    if (nodo != NULL){
        return nodo->info.valor;
    }
    return 0;
}

NodoIdentificador* buscarIdentificadorEnTS(char* identificador, Lista* lista){
    NodoIdentificador* nodo = lista->cabeza; 
    while(nodo != NULL && strcmp(nodo->info.nombre, identificador) != 0)
        nodo = nodo->siguiente;
    return nodo;
}

/************** Errores **************/

void errorSemantico(char* mensaje){
    printf("Error Semantico: %s",mensaje);
    exit(-1);
}

void yyerror(char* mensaje){ //Error sintáctico
   printf("\n Al menos 1 error sintactico ha ocurrido \n");
   exit(-1);
}

// Error léxico en flex


/********* Reporte Tabla De Simbolos *******/ 

void finalizacion() {

    printf("\n --------------------------------------- REPORTE --------------------------------------- \n \n");

    listar(&tablaDeSimbolos);

    fclose(yyin);
    fclose(yyout);

    exit(0);
    
}
