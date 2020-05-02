#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef enum {param, body} element_method_type;

typedef struct t5 {
    element_method_type meth_type;
    char* type;
    char* id;
    int line, col;
    struct t5* next;
} MethodElement;

typedef enum {var_decl, method_decl} element_type;

typedef struct t2 {
    element_type elem_type;
    char* type;
    char* id;
    MethodElement* elements;
    int line, col;
    struct t2* next;
} TableElement;

typedef struct t1 {
    char* id;
    int line, col;
    TableElement* table;
} TableHead;

TableElement* insertParamBody(TableElement* elem, char* type, char* id, element_method_type methType, int line, int col);
TableElement* insertMethodVarDecl(char* type, char* id, element_type elemType, int line, int col);
TableHead* insertHead(char* id, int line, int col);
char *strlwr(char *str);

#endif