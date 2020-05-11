#include "structures.h"
#include "symbol_table.h"
#include "semantics.h"
#include <string.h>
#include <stdio.h>

extern TableHead* symHead;

void checkProgram(IsProgram* program) {
    insertHead(program->id->value, program->line, program->col);
    checkMethodField(program->methodFieldList);
}

void checkMethodField(IsMethodField* mfList) {
    int count = 0;
    while (mfList) {
        if (mfList->mf==isField) {
            insertMethodVarDecl(mfList->mfType.fieldDecl->type->value, mfList->mfType.fieldDecl->id->value, var_decl, mfList->mfType.fieldDecl->line, mfList->mfType.fieldDecl->col);
        }
        else {
            TableElement* currentElement = insertMethodVarDecl(mfList->mfType.methodDecl->methodHeader->type->value, mfList->mfType.methodDecl->methodHeader->id->value, method_decl, mfList->mfType.methodDecl->methodHeader->line, mfList->mfType.methodDecl->methodHeader->col);
            if(currentElement != NULL) {
                checkParams(currentElement, mfList->mfType.methodDecl->methodHeader->paramDeclList);
                checkBody(currentElement, mfList->mfType.methodDecl->methodBody->vardDeclSatetmentList);
                int print = checkOtherMethod(currentElement, count);
                currentElement->print = print;
            }
        }
        count ++;
        mfList = mfList->next;
    }
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

void checkParams(TableElement* currentElement, IsParamDecl* paramList) {
    while (paramList) {
        insertParamBody(currentElement, paramList->type->value, paramList->id->value , param, paramList->line, paramList->col);
        paramList = paramList->next;
    }
}

void checkBody(TableElement* currentElement, IsVarDeclStatement* bodyList) {
    for(;bodyList;bodyList=bodyList->next){
        if(bodyList->vds == varDecl){
            insertParamBody(currentElement, bodyList->vdsType.varDecl->type->value, bodyList->vdsType.varDecl->id->value, body, bodyList->vdsType.varDecl->line, bodyList->vdsType.varDecl->col);
        }
    }
}

void insertTypes(IsProgram* program){
    IsMethodField* methFieldIt = program->methodFieldList;
    TableElement* element = symHead->table;
    for(;methFieldIt;methFieldIt=methFieldIt->next,element=element->next){
        if(methFieldIt->mf == isMethod){
            insertVarStatementType(methFieldIt->mfType.methodDecl->methodBody->vardDeclSatetmentList, element);
        }
    }
}

void insertVarStatementType(IsVarDeclStatement* varStatement, TableElement* tableElement){
    for(;varStatement;varStatement=varStatement->next){
        if(varStatement->vds == statement){
            insertStatementType(varStatement->vdsType.statement, tableElement);
        }       
    }
}

void insertStatementType(IsStatement* statement, TableElement* tableElement){
    if(statement->sm == sBlock){
        IsVarDeclStatement* block = statement->smType.blockStatement;
        insertVarStatementType(block, tableElement);
    }
    else if(statement->sm == sIf){
        IsIfStatement* ifStatement = statement->smType.ifStatement;
        insertExprType(ifStatement->ifExpr, tableElement);
        insertVarStatementType(ifStatement->thenBlock, tableElement);
        insertVarStatementType(ifStatement->elseBlock, tableElement);
    }
    else if(statement->sm == sWhile){
        IsWhileStatement* whileStatement = statement->smType.whileStatement;
        insertExprType(whileStatement->whileExpr, tableElement);
        insertVarStatementType(whileStatement->whileStatement, tableElement);
    }
    else if(statement->sm == sReturn){
        IsReturnStatement* returnStatement = statement->smType.returnStatement;
        insertExprType(returnStatement->returnExpr, tableElement);
    }
    else if(statement->sm == sCall){
        IsCallStatement* callStatement = statement->smType.callStatement;
        insertCallType(callStatement, tableElement);
    }
    else if(statement->sm == sPrint){
        IsPrintStatement* printStatement = statement->smType.printStatement;
        insertPrintType(printStatement, tableElement);
    }
    else if(statement->sm == sParseArgs){
        IsParseArgsStatement* parseArgsStatement = statement->smType.parseArgsStatement;
        insertParseArgsType(parseArgsStatement, tableElement);
    }
    else if(statement->sm == sAssign){
        IsAssign* assignStatement = statement->smType.assignStatement;
        insertAssignType(assignStatement, tableElement);
    }
}

void insertCallType(IsCallStatement* call, TableElement* tableElement){
    IsExpr* param = call->callExpr;
    for(;param;param=param->next){
        insertExprType(param, tableElement);
    }

    TableElement* tableIt = symHead->table;
    int check;
    for(;tableIt;tableIt=tableIt->next){
        if(tableIt->elem_type == method_decl && strcmp(call->id->value,tableIt->id) == 0){
            check = checkFunctionType(call->id->value, tableIt->elements, call->callExpr, tableIt, tableElement, 0);
            if(check == 1){
                call->returnType = tableIt->type;
                call->id->returnType = tableIt->type;
                return;
            }
        }
    }
    call->id->returnType = "undef";
    call->returnType = "undef";
}

void insertPrintType(IsPrintStatement* print, TableElement* tableElement){
    if(print->p == stringLiteral){
        print->returnType = "String";
    }
    else{
        insertExprType(print->pType.printExpr, tableElement);
        print->returnType = print->pType.printExpr->returnType;
    }
}

int checkFunctionType(char* id, MethodElement* methodElement, IsExpr* paramsList, TableElement* currentElement, TableElement* tableElement, int closest){
    IsExpr* paramsElement = paramsList;
    
    int doubleInt;

    if(((methodElement == NULL || methodElement->meth_type == body) && paramsElement != NULL) || ((methodElement != NULL && methodElement->meth_type == param) && paramsElement == NULL)){
        return 0;
    }

    for(;methodElement && paramsElement && methodElement->meth_type == param;methodElement=methodElement->next,paramsElement=paramsElement->next){
        char* type1 = methodElement->type;
        char* type2 = paramsElement->returnType;
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

int checkOtherParam(MethodElement* param, TableElement* el, int count){
    MethodElement* iterator = el->elements;
    for(int i=0;i<count;i++,iterator=iterator->next){
        if(strcmp(param->type,iterator->type) == 0 && strcmp(param->id,iterator->id) == 0){
            return 1;
        }
    }
    return 0;
}

void insertParseArgsType(IsParseArgsStatement* parseArgs, TableElement* tableElement){
    insertTerminalType(parseArgs->id, tableElement);
    if(parseArgs->parseArgsExpr){
        insertExprType(parseArgs->parseArgsExpr, tableElement);

        if(strcmp(parseArgs->parseArgsExpr->returnType,"int") != 0){
            parseArgs->parseArgsExpr->returnType = "undef";
        }
        parseArgs->returnType = parseArgs->parseArgsExpr->returnType;
    }
    else{
        parseArgs->returnType = "undef";
    }
}

void insertAssignType(IsAssign* assign, TableElement* tableElement){
    insertTerminalType(assign->id,tableElement);
    insertExprType(assign->assignExpr,tableElement);

    if(strcmp(assign->id->returnType,"undef") == 0){
        assign->returnType = assign->assignExpr->returnType;
    }
    else{
        assign->returnType = assign->id->returnType;
    }
}

void insertExprType(IsExpr* expr, TableElement* tableElement){
    if (expr) {
        char* type = NULL;
        if(expr->e == eAssign){
            IsAssign* assign = expr->eType.exprAssign;
            insertAssignType(assign, tableElement);
            type = assign->returnType;
        }
        else if(expr->e == eOp){
            IsOp* op = expr->eType.exprOp;
            insertOpType(op, tableElement);
            type = op->returnType;
        }
        else if(expr->e == eCall){
            IsCallStatement* call = expr->eType.exprCall;
            insertCallType(call, tableElement);
            type = call->returnType;
        }
        else if(expr->e == eParseArgs){
            IsParseArgsStatement* parseArgs = expr->eType.exprParseArgs;
            insertParseArgsType(parseArgs, tableElement);
            type = parseArgs->returnType;
        }
        else if(expr->e == eTerminal){
            IsTerminal* terminal = expr->eType.exprTerminal;
            insertTerminalType(terminal, tableElement);
            type = terminal->returnType;
        }
        else if(expr->e == eUnit){
            IsUnit* unit = expr->eType.exprUnit;
            insertUnitType(unit, tableElement);
            type = unit->returnType;
        }
        expr->returnType = type;
    }
}

void insertOpType(IsOp* operation, TableElement* tableElement){
    insertExprType(operation->opExprLeft, tableElement);
    insertExprType(operation->opExprRight, tableElement);
    
    if (!strcmp(operation->op, "Eq") || !strcmp(operation->op, "Ge") || !strcmp(operation->op, "Gt") || !strcmp(operation->op, "Le") || !strcmp(operation->op, "Lt") || !strcmp(operation->op, "Ne") || !strcmp(operation->op, "And") || !strcmp(operation->op, "Or")  || !strcmp(operation->op, "Xor")) {
        if(strcmp(operation->opExprLeft->returnType, "undef") == 0 || strcmp(operation->opExprRight->returnType, "undef") == 0){
            operation->returnType = "undef";
        }
        else{
            operation->returnType = "boolean";
        }
    }
    else if(strcmp(operation->op, "Lshift") == 0 || strcmp(operation->op, "Rshift") == 0 || strcmp(operation->op,"Xor") == 0){
        operation->returnType = "none";
    }
    else if((strcmp(operation->opExprLeft->returnType,"boolean") == 0 || strcmp(operation->opExprRight->returnType,"boolean") == 0) && (strcmp(operation->op,"Add") == 0 || strcmp(operation->op,"Add") == 0 || strcmp(operation->op,"Sub") == 0 || strcmp(operation->op,"Mul") == 0 || strcmp(operation->op,"Div") == 0 || strcmp(operation->op,"Mod") == 0)){
        operation->returnType = "undef";
    }
    else if((strcmp(operation->opExprLeft->returnType,"double") == 0 && strcmp(operation->opExprRight->returnType,"int") == 0)  || (strcmp(operation->opExprRight->returnType,"double") == 0 && strcmp(operation->opExprLeft->returnType,"int") == 0)){
        operation->returnType = "double";
    }
    else if(strcmp(operation->opExprLeft->returnType,operation->opExprRight->returnType) != 0){
        operation->returnType = "undef";
    }
    else{
        operation->returnType = operation->opExprLeft->returnType;
    }
}

void insertTerminalType(IsTerminal* terminal, TableElement* tableElement){
    if (!strcmp(terminal->type, "DecLit")) {
        terminal->returnType = "int";
    }
    else if (!strcmp(terminal->type, "RealLit")) {
        terminal->returnType = "double";
    }
    else if (!strcmp(terminal->type, "BoolLit")) {
        terminal->returnType = "boolean";
    }
    else if (!strcmp(terminal->type, "StrLit")) {
        terminal->returnType = "String";
    }
    else if (!strcmp(terminal->type, "Id")) {
        terminal->returnType = getIdType(terminal->value, terminal->line, terminal->col, tableElement);
    }
    else{
        terminal->returnType = "undef";
    }
}

void insertUnitType(IsUnit* unit, TableElement* tableElement){
    if(strcmp(unit->op,"Length") == 0){
        insertExprType(unit->unitExpr,tableElement);
        unit->returnType = "int";
    }
    else{
        insertExprType(unit->unitExpr,tableElement);
        unit->returnType = unit->unitExpr->returnType;
    }
}

char* getIdType(char* id, int line, int col, TableElement* tableElement){
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