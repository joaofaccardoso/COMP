#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

extern TableHead* symHead;

TableHead* insertHead(char* id) {
	TableHead* head=(TableHead*) malloc(sizeof(TableHead));
    head->id = id;  
    symHead = head; 
    return head; 
}

TableElement* insertMethodVarDecl(char* type, char* id, element_type elemType) {
    TableElement* elem = (TableElement*)malloc(sizeof(TableElement));

    elem->elem_type = elemType;
    elem->type = type;
    elem->id = id;
    TableElement* prev, *aux;
    for(aux=symHead->table;aux;prev=aux,aux=aux->next){
        if(strcmp(aux->id,id)==0){
            return NULL;
        }
    }

    if(symHead->table == NULL){
        symHead->table = elem;
    }
    else{
        prev->next = elem;
    }
    return elem;
}

TableElement* insertParamBody(TableElement* elem, char* type, char* id, element_method_type methType) {
    MethodElement* paramElem = (MethodElement*) malloc(sizeof(MethodElement));

    paramElem->type = type;
    paramElem->id = id;
    paramElem->meth_type = methType;

    MethodElement* prev, *aux;
    if(methType == param){
        aux=elem->paramsList;
    }
    else{
        aux=elem->body;
    }
    for(;aux;prev=aux,aux=aux->next){
        if(strcmp(aux->id,elem->id)==0){
            return NULL;
        }
    }

    prev->next = paramElem;
    return elem;
}