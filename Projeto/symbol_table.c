#include "symbol_table.h"
#include "structures.h"
#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern TableHead* symHead;

char* lower(char* type){
    if(strcmp(type,"StringArray") == 0){
        type = "String[]";
    }
    else if(strcmp(type,"Int") == 0){
        type = "int";
    }
    else if(strcmp(type,"Double") == 0){
        type = "double";
    }
    else if(strcmp(type,"Void") == 0){
        type = "void";
    }
    else if(strcmp(type,"Bool") == 0){
        type = "boolean";
    }
    return type;
}

TableHead* insertHead(char* id, int line, int col) {
	TableHead* head=(TableHead*) malloc(sizeof(TableHead));
    head->id = id;  
    head->line = line;
    head->col = col;
    symHead = head; 
    return head; 
}

TableElement* insertMethodVarDecl(char* type, char* id, element_type elemType, int line, int col) {
    TableElement* elem = (TableElement*)malloc(sizeof(TableElement));

    elem->elem_type = elemType;
    elem->type = lower(type);
    elem->id = id;
    elem->line = line;
    elem->col = col;
    TableElement* prev, *aux;
    int print = 1;
    int check = 0;
    for(aux=symHead->table;aux;prev=aux,aux=aux->next){
        if(elemType == var_decl && aux->elem_type == var_decl && strcmp(aux->id,id) == 0){
            print = 0;
            if(strcmp("_",id) != 0 && check == 0){
                printf("Line %d, col %d: Symbol %s already defined\n",line,col,id);
                check = 1;
            }
        }
    }

    elem->print = print;
    
    if(symHead->table == NULL){
        symHead->table = elem;
    }
    else{
        prev->next = elem;
    }
    
    return elem;
}

TableElement* insertParamBody(TableElement* elem, char* type, char* id, element_method_type methType, int line, int col) {
    MethodElement* paramElem = (MethodElement*) malloc(sizeof(MethodElement));
    paramElem->type = lower(type);
    paramElem->id = id;
    paramElem->meth_type = methType;
    paramElem->line = line;
    paramElem->col = col;
    paramElem->print = 1;

    MethodElement* prev, *aux;
    int check = 0;
    for(aux=elem->elements;aux;prev=aux,aux=aux->next){
        if(strcmp(aux->id,id)==0){
            if(strcmp("_",id) != 0 && methType == param && check == 0){
                printf("Line %d, col %d: Symbol %s already defined\n",line,col,id);
                check = 1;
            }
            paramElem->print = 0;
        }
    }

    if(strcmp("_",id) == 0){
        paramElem->print = 0;
    }
    
    if(elem->elements == NULL){
        elem->elements = paramElem;
    }
    else{
        prev->next = paramElem;
    }
    return elem;
}

TableElement* findMethod(int pos){
    if(pos == -1){
        return NULL;
    }
    TableElement* it = symHead->table;
    for(int i=0;i<pos;i++,it=it->next){}
    return it;
}