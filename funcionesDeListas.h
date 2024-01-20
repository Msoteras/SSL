#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LONGMAX 32+1
#define VACIO -1

extern void yyerror(char*); 
extern void errorSemantico(char*); 

/* --------------------------- NODOS LISTA --------------------------- */

typedef struct Datos {
    char* nombre;
    int valor;
} Datos;

typedef struct NodoIdentificador{
    Datos info;
    struct NodoIdentificador* siguiente;
} NodoIdentificador;

typedef struct Lista {
    NodoIdentificador* cabeza;
} Lista;

Lista identificadoresSinValor;


/* --------------------------- FUNCIONES --------------------------- */

int esIdentificadorValido(char* identificador){
    int longitud = strlen(identificador);

    if(longitud > LONGMAX)
    {
        errorSemantico("Identificador supera la cantidad maxima de caracteres permitidos \n");
        return 1;
    }
    return 0;
}

void insertar(Lista* lista, Datos dato)
{
    NodoIdentificador *nodo, *r, *ant;
    nodo = (NodoIdentificador*)malloc(sizeof(NodoIdentificador));
    nodo->info = dato;
    
    r = lista->cabeza; 
    while(r != NULL) 
    {
        ant = r;
        r = r->siguiente;
    }
    nodo->siguiente = r;
    if(r != lista->cabeza)
        ant->siguiente = nodo;
    else
        lista->cabeza = nodo; 
}

void agregarIdentificadorSinValor(char* identificador) {

    Datos datos;
    datos.nombre = identificador; 
    datos.valor = VACIO; 

    insertar(&identificadoresSinValor, datos); 
}

void mostrarExpresion(int valorExpresion){
    printf("%d ", valorExpresion);
}

void agregarIdentificador(Lista* lista, Datos dato){
    NodoIdentificador *r, *ant;
    r = lista->cabeza;

    while(r != NULL && strcmp(r->info.nombre, dato.nombre) != 0){
        ant = r;
        r = r->siguiente;
    }

    if(r != NULL && strcmp(r->info.nombre, dato.nombre) == 0)       
    {
        errorSemantico("Identificador ya declarado \n");
    }
    else 
    {
       if(esIdentificadorValido(dato.nombre) == 0) 
                insertar(lista, dato);
    }
}

void listar(Lista* lista)
{
    NodoIdentificador *r;
    r = lista->cabeza;
    
    while(r != NULL)
    {
        printf("Nombre: %s       Valor: %d \n", r->info.nombre, r->info.valor);   
        r = r->siguiente;
    }   
}


