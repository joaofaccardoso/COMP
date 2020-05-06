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
    int print = 1;
    int count = 1;
    for(aux=symHead->table;aux;prev=aux,aux=aux->next,count++){
        if(strcmp(aux->id,id)==0 && strcmp(aux->type,lower(type)) == 0){
            if(elemType == var_decl) {
                print = 0;
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

int checkOtherMethod(TableElement* el, int count){
    TableElement* it = symHead->table;
    int check;
    for(int i=0;i<count;i++,it=it->next){
        if(it->elem_type == method_decl && strcmp(it->id,el->id) == 0 && strcmp(it->type,el->type) == 0){
            MethodElement* it1 = el->elements;
            MethodElement* it2 = it->elements;
            check = 1;
            for(;it1 && it1->meth_type == param && it2 && it2->meth_type == param;it1=it1->next,it2=it2->next){
                if(strcmp(it1->type,it2->type) != 0){
                    check = 0;
                    break;
                }
            }

            if(check == 1 && (it1 == NULL || it1->meth_type == body) && (it2 == NULL || it2->meth_type == body)){
                return 0;
            }

        }
    }
    return 1;
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
    for(aux=elem->elements;aux;prev=aux,aux=aux->next){
        if(strcmp(aux->id,id)==0){
            paramElem->print = 0;
        }
    }
    
    if(elem->elements == NULL){
        elem->elements = paramElem;
    }
    else{
        prev->next = paramElem;
    }
    return elem;
}

char* findTerminalType(IsTerminal* terminal, TableElement* tableElement){
    if (!strcmp(terminal->type, "DecLit")) {
        return "int";
    }
    else if (!strcmp(terminal->type, "RealLit")) {
        return "double";
    }
    else if (!strcmp(terminal->type, "BoolLit")) {
        return "boolean";
    }
    else if (!strcmp(terminal->type, "StrLit")) {
        return "String";
    }
    else if (!strcmp(terminal->type, "Id")) {
        return findIdTable(terminal->value, terminal->line, terminal->col, tableElement);
    }
    return "undef";
}

char* findIdTable(char* id, int line, int col, TableElement* tableElement){
    MethodElement* methodIterator = tableElement->elements;
    for(;methodIterator && methodIterator->line <= line;methodIterator=methodIterator->next){
        if(strcmp(methodIterator->id,id) == 0){
            return methodIterator->type;
        }
    }

    TableElement* tableIterator = symHead->table;
    for(;tableIterator;tableIterator=tableIterator->next){
        if(tableIterator->elem_type == var_decl && strcmp(tableIterator->id,id) == 0){
            return tableIterator->type;
        }
    }

    return "undef";
}

TableElement* findMethodTable(char* id, IsExpr* paramsElement, int line, int col, TableElement* tableElement){
    TableElement* tableIt = symHead->table;
    int check;
    for(;tableIt;tableIt=tableIt->next){
        if(tableIt->elem_type == method_decl && strcmp(id,tableIt->id) == 0){
            check = checkFunctionType(id, tableIt->elements, paramsElement, tableIt, tableElement, 0);
            if(check == 1){
                return tableIt;
            }
        }
    }
    return NULL;
}

int checkFunctionType(char* id, MethodElement* methodElement, IsExpr* paramsList, TableElement* currentElement, TableElement* tableElement, int closest){
    IsExpr* paramsElement = paramsList;
    
    int doubleInt;

    if(((methodElement == NULL || methodElement->meth_type == body) && paramsElement != NULL) || ((methodElement != NULL && methodElement->meth_type == param) && paramsElement == NULL)){
        return 0;
    }

    for(;methodElement && paramsElement && methodElement->meth_type == param;methodElement=methodElement->next,paramsElement=paramsElement->next){
        char* type1 = methodElement->type;
        char* type2 = getExprType(paramsElement, tableElement);
        if(closest == 0 && strcmp(type1,"double") == 0 && strcmp(type2,"int") == 0){
            doubleInt = 1;
        }
        else if(strcmp(type1,type2) != 0){
            return 0;
        }
    }

    if(((methodElement == NULL || methodElement->meth_type == body) && paramsElement != NULL) || ((methodElement != NULL && methodElement->meth_type == param) && paramsElement == NULL)){
        return 0;
    }

    if(doubleInt == 1){
        int check = isClosestFunction(id, currentElement, paramsList, tableElement);
        if(check == 0){
            return 0;
        }
    }

    return 1;
}

char* getExprType(IsExpr* expr, TableElement* tableElement){
    if(expr->e == eAssign){
        return getAssignType(expr->eType.exprAssign, tableElement);
    }
    else if(expr->e == eOp){
        return getOpType(expr->eType.exprOp, tableElement);
    }
    else if(expr->e == eUnit){
        if(strcmp(expr->eType.exprUnit->op,"Length") == 0){
            return "int";
        }
        return getExprType(expr->eType.exprUnit->unitExpr, tableElement);
    }
    else if(expr->e == eCall){
        TableElement* el = findMethodTable(expr->eType.exprCall->id->value, expr->eType.exprCall->callExpr, expr->eType.exprCall->line, expr->eType.exprCall->col, tableElement);
        if(!el){
            return "undef";
        }
        return el->type;
    }
    else if(expr->e == eParseArgs){
        return "int";
    }
    else if(expr->e == eTerminal){
        return findTerminalType(expr->eType.exprTerminal, tableElement);
    }
    return "undef";
}

char* getOpType(IsOp* op, TableElement* tableElement){
    char* type1 = getExprType(op->opExprLeft, tableElement);
    char* type2 = getExprType(op->opExprRight, tableElement);
    
    if (!strcmp(op->op, "Eq") || !strcmp(op->op, "Ge") || !strcmp(op->op, "Gt") || !strcmp(op->op, "Le") || !strcmp(op->op, "Lt") || !strcmp(op->op, "Ne") || !strcmp(op->op, "And") || !strcmp(op->op, "Or")  || !strcmp(op->op, "Xor")) {
        if(strcmp(type1, "undef") == 0 || strcmp(type2, "undef") == 0){
            return "undef";
        }
        return "boolean";
    }
    else if(strcmp(op->op, "Lshift") == 0 || strcmp(op->op, "Rshift") == 0 || strcmp(op->op,"Xor") == 0){
        return "undef";
    }
    else if((strcmp(type1,"boolean") == 0 || strcmp(type2,"boolean") == 0) && (strcmp(op->op,"Add") == 0 || strcmp(op->op,"Add") == 0 || strcmp(op->op,"Sub") == 0 || strcmp(op->op,"Mul") == 0 || strcmp(op->op,"Div") == 0 || strcmp(op->op,"Mod") == 0)){
        return "undef";
    }
    else if((strcmp(type1,"double") == 0 && strcmp(type2,"int") == 0)  || (strcmp(type2,"double") == 0 && strcmp(type1,"int") == 0)){
        return "double";
    }
    else if(strcmp(type1,type2) != 0){
        return "undef";
    }
    else{
        return type1;
    }
    
    return type1;

    // return "undef";
}

int isClosestFunction(char* id, TableElement* tableIt, IsExpr* paramsElement, TableElement* tableElement){
    tableIt = tableIt->next;
    for(;tableIt;tableIt=tableIt->next){
        if(tableIt->elem_type == method_decl && strcmp(id,tableIt->id) == 0){
            int check = checkFunctionType(id, tableIt->elements, paramsElement, tableIt, tableElement, 1);
            if(check == 1){
                return 0;
            }
        }
    }
    return 1;
}

char* getAssignType(IsAssign* assign, TableElement* tableElement){
    char* type1 = findIdTable(assign->id->value, assign->id->line, assign->id->col, tableElement);
    char* type2 = getExprType(assign->assignExpr,tableElement);

    if(strcmp(type1,"undef") == 0){
        return type2;
    }
    return type1;
}

int checkOtherParam(MethodElement* param, TableElement* el, int count){
    MethodElement* iterator = el->elements;
    for(int i=0;i<count;i++,iterator=iterator->next){
        if(strcmp(param->type,iterator->type) == 0 && strcmp(param->id,iterator->id) == 0){
            return 1;
        }
    }
    return 0;
}