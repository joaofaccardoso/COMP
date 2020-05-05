#include "symbol_table.h"
#include "structures.h"
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
    for(aux=symHead->table;aux;prev=aux,aux=aux->next){
        // if(strcmp(aux->id,id)==0){
        //     return NULL;
        // }
    }

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

    MethodElement* prev, *aux;
    for(aux=elem->elements;aux;prev=aux,aux=aux->next){
        // if(strcmp(aux->id,id)==0){
        //     return NULL;
        // }
    }
    
    if(elem->elements == NULL){
        elem->elements = paramElem;
    }
    else{
        prev->next = paramElem;
    }
    return elem;
}

MethodElement* findMethodElement(char* id, int line, int col, TableElement* method) {
    MethodElement* methodIterator = method->elements;
    MethodElement* element = NULL;

    while (methodIterator->line < line || (methodIterator->line==line && methodIterator->col < col) ) {
        if (!strcmp(methodIterator->id, id)) {
            element = methodIterator;
        }

        methodIterator = methodIterator->next;
        if (!methodIterator) break;
    }

    return element;
}

TableElement* findTableField(char* id, int line, int col) {
    TableElement* tableIterator = symHead->table;
    TableElement* element = NULL;

    while (tableIterator->line < line || (tableIterator->line==line && tableIterator->col < col) ) {
        if (!strcmp(tableIterator->id, id) && tableIterator->elem_type == var_decl) {
            element = tableIterator;
        }

        tableIterator = tableIterator->next;
        if (!tableIterator) break;
    }

    return element;
}

char* findIdTable(char* id, int line, int col, TableElement* methodTable) {
    MethodElement* elem = NULL;
    elem = findMethodElement(id, line, col, methodTable);
    
    if (elem) {
        return elem->type;
    }
    else {
        TableElement* elemTable = NULL;
        elemTable = findTableField(id, line, col);
        
        if (elemTable) {
            return elemTable->type;
        }
        else {
            return "undef";
        }
    }
}

char* findExprTypeTable(IsExpr* expr, int line, int col, TableElement* methodTable) {
    if (expr->e == eAssign) {
        return findIdTable(expr->eType.exprAssign->id->value, expr->eType.exprAssign->line, expr->eType.exprAssign->col, methodTable);
    }
    else if (expr->e == eOp) {
        char* leftResult = findExprTypeTable(expr->eType.exprOp->opExprLeft, expr->eType.exprOp->line, expr->eType.exprOp->col, methodTable);
        char* rightResult = findExprTypeTable(expr->eType.exprOp->opExprRight, expr->eType.exprOp->line, expr->eType.exprOp->col, methodTable);
    
        if (!strcmp(leftResult, "undef") || !strcmp(rightResult, "undef")) {
            return "undef";
        }
        else if ((!strcmp(leftResult, "int") && !strcmp(rightResult, "double")) || (!strcmp(leftResult, "double") && !strcmp(rightResult, "int"))) {
            return "double";
        }
        else if ((!strcmp(leftResult, "int") && !strcmp(rightResult, "boolean")) || (!strcmp(leftResult, "boolean") && !strcmp(rightResult, "int"))) {
            return "undef";
        }
        else if ((!strcmp(leftResult, "double") && !strcmp(rightResult, "boolean")) || (!strcmp(leftResult, "boolean") && !strcmp(rightResult, "double"))) {
            return "undef";
        }
        else {
            return leftResult;
        }
    }
    else if (expr->e == eCall) {
        TableElement* elem = findTableMethod(expr->eType.exprCall->id->value, expr->eType.exprCall->callExpr, expr->eType.exprCall->line, expr->eType.exprCall->col, methodTable);
        return elem->type;
    }
    else if (expr->e == eParseArgs) {
        return "int";
    }
    else if (expr->e == eTerminal) {
        if (!strcmp(expr->eType.exprTerminal->type, "DecLit")) {
            return "int";
        }
        else if (!strcmp(expr->eType.exprTerminal->type, "RealLit")) {
            return "double";
        }
        else if (!strcmp(expr->eType.exprTerminal->type, "BoolLit")) {
            return "boolean";
        }
        else if (!strcmp(expr->eType.exprTerminal->type, "Id")) {
            return findIdTable(expr->eType.exprTerminal->value, expr->eType.exprTerminal->line, expr->eType.exprTerminal->col, methodTable);
        }
    }
    else if (expr->e == eUnit) {
        if (!strcmp(expr->eType.exprUnit->op, "Length")) {
            return "int";
        }
        else {
            return findExprTypeTable(expr->eType.exprUnit->unitExpr, expr->eType.exprUnit->line, expr->eType.exprUnit->col, methodTable);
        }
    }
}

TableElement* findTableMethod(char* id, IsExpr* expr, int line, int col, TableElement* methodTable) {
    IsExpr* paramIterator = NULL;
    TableElement* tableIterator = symHead->table;
    MethodElement* methodIterator = NULL;

    while (tableIterator) {

        if (strcmp(id, tableIterator->id) == 0 && tableIterator->elem_type == method_decl) {

            if (!expr && (!tableIterator->elements || tableIterator->elements->meth_type == body)) {
                return tableIterator;
            }
            else if (!tableIterator->elements || tableIterator->elements->meth_type == body) {
                tableIterator = tableIterator->next;
                continue;
            }

            methodIterator = tableIterator->elements;
            paramIterator = expr;

            while (methodIterator && methodIterator->meth_type == param) {
                if (!paramIterator) {
                    break;
                }

                if (strcmp(methodIterator->type, findExprTypeTable(paramIterator, line, col, methodTable))) {
                    if (!(strcmp(methodIterator->type, "double") == 0 && strcmp(findExprTypeTable(paramIterator, line, col, methodTable), "int") == 0)) {
                        break;
                    }
                }

                methodIterator = methodIterator->next;
                paramIterator = paramIterator->next;
            }

            if (!paramIterator && (!methodIterator || methodIterator->meth_type != param)) {
                return tableIterator;
            }
        }

        tableIterator = tableIterator->next;
    }

    return tableIterator;
}