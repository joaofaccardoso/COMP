#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef enum {param, body} element_method_type;

typedef struct t5 {
    element_method_type meth_type;
    char* type;
    char* id;
    struct t5* next;
} MethodElement;

typedef enum {var_decl, method_decl} element_type;

typedef struct t2 {
    element_type elem_type;
    char* type;
    char* id;
    MethodElement* elements;
    struct t2* next;
} TableElement;

typedef struct t1 {
    char* id;
    TableElement* table;
} TableHead;

TableElement* insertParamBody(TableElement* elem, char* type, char* id, element_method_type methType);
TableElement* insertMethodVarDecl(char* type, char* id, element_type elemType);
TableHead* insertHead(char* id);
char *strlwr(char *str);

#endif