#include "structures.h"
#include "symbol_table.h"
#include "semantics.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern TableHead* symHead;
extern int flag;

void checkProgram(IsProgram* program) {
    insertHead(program->id->value, program->line, program->col);
    checkMethodField(program->methodFieldList);
}

void checkMethodField(IsMethodField* mfList) {
    int count = 0;
    while (mfList) {
        if (mfList->mf==isField) {
            if ((flag == 0 || flag == 3) && strcmp(mfList->mfType.fieldDecl->id->value, "_") == 0) {
                printf("Line %d, col %d: Symbol _ is reserved\n", mfList->mfType.fieldDecl->id->line, mfList->mfType.fieldDecl->id->col);
            }
            insertMethodVarDecl(mfList->mfType.fieldDecl->type->value, mfList->mfType.fieldDecl->id->value, var_decl, mfList->mfType.fieldDecl->id->line, mfList->mfType.fieldDecl->id->col);
        }
        else {
            TableElement* currentElement = insertMethodVarDecl(mfList->mfType.methodDecl->methodHeader->type->value, mfList->mfType.methodDecl->methodHeader->id->value, method_decl, mfList->mfType.methodDecl->methodHeader->line, mfList->mfType.methodDecl->methodHeader->col);
            if(currentElement != NULL) {
                checkParams(currentElement, mfList->mfType.methodDecl->methodHeader->paramDeclList);
                checkBody(currentElement, mfList->mfType.methodDecl->methodBody->vardDeclSatetmentList);
                int print = checkOtherMethod(currentElement, count);
                if((flag == 0 || flag == 3) && print == 0){
                    printf("Line %d, col %d: Symbol %s(", mfList->mfType.methodDecl->methodHeader->id->line, mfList->mfType.methodDecl->methodHeader->id->col,  mfList->mfType.methodDecl->methodHeader->id->value);
                    MethodElement* paramIt = currentElement->elements;
                    if(paramIt && paramIt->meth_type == param){
                        printf("%s",paramIt->type);
                        for(paramIt=paramIt->next;paramIt && paramIt->meth_type==param;paramIt=paramIt->next){
                            printf(",%s",paramIt->type);
                        }
                    }
                    printf(") already defined\n");
                }
                else if (strcmp(currentElement->id, "_") == 0) {
                    if(flag == 0 || flag == 3){
                        printf("Line %d, col %d: Symbol _(", mfList->mfType.methodDecl->methodHeader->id->line, mfList->mfType.methodDecl->methodHeader->id->col);
                        MethodElement* paramIt = currentElement->elements;
                        if(paramIt && paramIt->meth_type == param){
                            printf("%s",paramIt->type);
                            for(paramIt=paramIt->next;paramIt && paramIt->meth_type==param;paramIt=paramIt->next){
                                printf(",%s",paramIt->type);
                            }
                        }
                        printf(") is reserved\n");
                    }

                    print = 0;
                }
                currentElement->print = print;
                mfList->print = print;
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
        if(it->elem_type == method_decl && strcmp(it->id,el->id) == 0 /*&& strcmp(it->type,el->type) == 0*/){
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
        if ((flag == 0 || flag == 3) && strcmp(paramList->id->value, "_") == 0) {
            printf("Line %d, col %d: Symbol _ is reserved\n", paramList->id->line, paramList->id->col);
        }
        insertParamBody(currentElement, paramList->type->value, paramList->id->value , param, paramList->id->line, paramList->id->col);
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
        if(methFieldIt->mf == isMethod && methFieldIt->print == 1){
            insertVarStatementType(methFieldIt->mfType.methodDecl->methodBody->vardDeclSatetmentList, methFieldIt->mfType.methodDecl, element);
        }
    }
}

void insertVarStatementType(IsVarDeclStatement* varStatement, IsMethodDecl* method, TableElement* tableElement){
    int check;
    for(;varStatement;varStatement=varStatement->next){
        if(varStatement->vds == statement){
            insertStatementType(varStatement->vdsType.statement, method, tableElement);
        }       
        else{
            check = checkParamsDecl(varStatement->vdsType.varDecl, method, tableElement);
            if ((flag == 0 || flag == 3) && strcmp(varStatement->vdsType.varDecl->id->value, "_") == 0) {
                printf("Line %d, col %d: Symbol _ is reserved\n",varStatement->vdsType.varDecl->id->line, varStatement->vdsType.varDecl->id->col);
            }
            else if((flag == 0 || flag == 3) && check){
                printf("Line %d, col %d: Symbol %s already defined\n",varStatement->vdsType.varDecl->id->line, varStatement->vdsType.varDecl->id->col, varStatement->vdsType.varDecl->id->value);
            }
        }
    }
}

int checkParamsDecl(IsVarDecl* var, IsMethodDecl* method, TableElement* tableElement){
    IsParamDecl* param = method->methodHeader->paramDeclList;
    for(;param && (param->line<var->line || (param->line==var->line && param->col<var->col));param=param->next){
        if(strcmp(param->id->value,var->id->value) == 0){
            return 1;
        }
    }

    IsVarDeclStatement* body = method->methodBody->vardDeclSatetmentList;
    for(;body && (body->line < var->line || (body->line == var->line && body->col < var->col));body=body->next){
        if(body->vds == varDecl){
            IsVarDecl* var2 = body->vdsType.varDecl;
            if(strcmp(var2->id->value,var->id->value) == 0){
                return 1;
            }
        }
    }
    return 0;
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

void insertStatementType(IsStatement* statement, IsMethodDecl* method, TableElement* tableElement){
    if(statement->sm == sBlock){
        IsVarDeclStatement* block = statement->smType.blockStatement;
        insertVarStatementType(block, method, tableElement);
    }
    else if(statement->sm == sIf){
        IsIfStatement* ifStatement = statement->smType.ifStatement;
        insertIfType(ifStatement, method, tableElement);
    }
    else if(statement->sm == sWhile){
        IsWhileStatement* whileStatement = statement->smType.whileStatement;
        insertWhileType(whileStatement, method, tableElement);
    }
    else if(statement->sm == sReturn){
        IsReturnStatement* returnStatement = statement->smType.returnStatement;
        insertReturnType(returnStatement, method, tableElement);
    }
    else if(statement->sm == sCall){
        IsCallStatement* callStatement = statement->smType.callStatement;
        insertCallType(callStatement, method, tableElement);
    }
    else if(statement->sm == sPrint){
        IsPrintStatement* printStatement = statement->smType.printStatement;
        insertPrintType(printStatement, method, tableElement);
    }
    else if(statement->sm == sParseArgs){
        IsParseArgsStatement* parseArgsStatement = statement->smType.parseArgsStatement;
        insertParseArgsType(parseArgsStatement, method, tableElement);
    }
    else if(statement->sm == sAssign){
        IsAssign* assignStatement = statement->smType.assignStatement;
        insertAssignType(assignStatement, method, tableElement);
    }
}

void insertIfType(IsIfStatement* ifStatement, IsMethodDecl* method, TableElement* tableElement){
    insertExprType(ifStatement->ifExpr, method, tableElement);
    insertVarStatementType(ifStatement->thenBlock, method, tableElement);
    insertVarStatementType(ifStatement->elseBlock, method, tableElement);

    if(strcmp(ifStatement->ifExpr->returnType,"boolean") != 0){
        if(flag == 0 || flag == 3){
            printf("Line %d, col %d: Incompatible type %s in if statement\n", ifStatement->ifExpr->line, ifStatement->ifExpr->col, ifStatement->ifExpr->returnType);
        }
    }
}

void insertWhileType(IsWhileStatement* whileStatement, IsMethodDecl* method, TableElement* tableElement){
    insertExprType(whileStatement->whileExpr, method, tableElement);
    insertVarStatementType(whileStatement->whileStatement, method, tableElement);

    if(strcmp(whileStatement->whileExpr->returnType,"boolean") != 0){
        if(flag == 0 || flag == 3){
            printf("Line %d, col %d: Incompatible type %s in while statement\n", whileStatement->whileExpr->line, whileStatement->whileExpr->col, whileStatement->whileExpr->returnType);
        }
    }
}

void insertReturnType(IsReturnStatement* returnStatement, IsMethodDecl* method, TableElement* tableElement){
    insertExprType(returnStatement->returnExpr, method, tableElement);

    char* methodType = lower(method->methodHeader->type->value);
    if(returnStatement->returnExpr != NULL){
        if(strcmp(methodType,"void") == 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Incompatible type %s in return statement\n", returnStatement->line, returnStatement->col, returnStatement->returnExpr->returnType);
            }
        }
        else if(!(strcmp(methodType,"double") == 0 && strcmp(returnStatement->returnExpr->returnType,"int") == 0) && strcmp(methodType,returnStatement->returnExpr->returnType) != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Incompatible type %s in return statement\n", returnStatement->line, returnStatement->col, returnStatement->returnExpr->returnType);
            }
        }
    }
    else{
        if(strcmp(methodType,"void") != 0 && (flag == 0 || flag == 3)){
            printf("Line %d, col %d: Incompatible type void in return statement\n", returnStatement->line, returnStatement->col);
        }
    }
}

void insertCallType(IsCallStatement* call, IsMethodDecl* method, TableElement* tableElement){
    IsExpr* param = call->callExpr;
    for(;param;param=param->next){
        insertExprType(param, method, tableElement);
    }

    int check, pos = 0;
    int count = 0;
    TableElement* tableIterator = symHead->table;
    for(;tableIterator;tableIterator=tableIterator->next,pos++){
        if(tableIterator->elem_type == method_decl && strcmp(tableIterator->id,call->id->value) == 0){
            check = checkParameters(tableIterator->elements,call->callExpr);

            if(check == 1 || check == -1){
                call->returnType = tableIterator->type;
                call->id->returnType = tableIterator->type;
                call->pos = pos;
                
                if(check == -1){
                    count++;
                }
                else{
                    return;
                }
            }
        }
    }

    if(count == 0){
        call->id->returnType = "undef";
        call->returnType = "undef";
        call->pos = -1;

        if(flag == 0 || flag == 3){
            printf("Line %d, col %d: Cannot find symbol %s(", call->line, call->col, call->id->value);
            param = call->callExpr;
            if (param) {
                printf("%s", param->returnType);
                param = param->next;
                for (;param; param = param->next) {
                    printf(",%s", param->returnType);
                }
            }
            printf(")\n");
        }
    }
    else if(count > 1){
        call->returnType = "undef";
        call->id->returnType = "undef";
        call->pos = -1;

        if(flag == 0 || flag == 3){
            printf("Line %d, col %d: Reference to method %s(", call->line, call->col, call->id->value);
            IsExpr* params = call->callExpr;
            if(params){
                printf("%s",params->returnType);
                for(params=params->next;params;params=params->next){
                    printf(",%s",params->returnType);
                }
            }
            printf(") is ambiguous\n");
        }
    }
}

int checkParameters(MethodElement* elements, IsExpr* params){   // RETORNA 0 SE PARAMETROS DIFERENTES, RETORNA 1 SE PARAMETROS IGUAIS, RETORNA -1 SE PARAMETROS COM DOUBLE E INT
    int doubleInt = 0;

    if((elements == NULL  || elements->meth_type == body) && params == NULL){
        return 1;
    }
    else if(elements == NULL || elements->meth_type == body || params == NULL){
        return 0;
    }

    for(;elements && elements->meth_type == param && params;elements=elements->next, params=params->next){
        if(strcmp(elements->type,"double")==0 && strcmp("int",params->returnType)==0){
            doubleInt = 1;
        }
        else if(strcmp(elements->type,params->returnType)!=0){
            return 0;
        }
    }

    if((elements != NULL && elements->meth_type == param) || params != NULL){
        return 0;
    }

    if(doubleInt == 1){
        return -1;
    }

    return 1;
}

void insertPrintType(IsPrintStatement* print, IsMethodDecl* method, TableElement* tableElement){
    if(print->p == stringLiteral){
        print->returnType = "String";
    }
    else{
        insertExprType(print->pType.printExpr, method, tableElement);
        if(strcmp(print->pType.printExpr->returnType,"int") != 0 && strcmp(print->pType.printExpr->returnType,"double") != 0 && strcmp(print->pType.printExpr->returnType,"boolean") != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Incompatible type %s in System.out.print statement\n", print->pType.printExpr->line, print->pType.printExpr->col, print->pType.printExpr->returnType);
            }
        }
    }

}

void insertParseArgsType(IsParseArgsStatement* parseArgs, IsMethodDecl* method, TableElement* tableElement){
    insertTerminalType(parseArgs->id, method, tableElement);
    if(parseArgs->parseArgsExpr){
        insertExprType(parseArgs->parseArgsExpr, method, tableElement);
        
        parseArgs->returnType = "int";

        if(strcmp(parseArgs->id->returnType,"String[]") != 0 || strcmp(parseArgs->parseArgsExpr->returnType,"int") != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator Integer.parseInt cannot be applied to types %s, %s\n", parseArgs->line, parseArgs->col, parseArgs->id->returnType, parseArgs->parseArgsExpr->returnType);
            }
        }
    }
    else{
        parseArgs->returnType = "undef";
    }
}


/* 
 * undef = none  :: return undef
 * double = int  :: return double
 * undef = qualquer coisa  ::  return qualquer coisa (e vice versa)
 * String[]/qualquer coisa = String[]/qualquer coisa  ::  return undef
 */ 
void insertAssignType(IsAssign* assign, IsMethodDecl* method, TableElement* tableElement){
    insertTerminalType(assign->id, method, tableElement);
    insertExprType(assign->assignExpr, method, tableElement);

    assign->returnType = assign->id->returnType;

    if(strcmp(assign->id->returnType,"undef") == 0 || strcmp(assign->assignExpr->returnType,"undef") == 0 || strcmp(assign->id->returnType,"String[]") == 0 || strcmp(assign->assignExpr->returnType,"String[]") == 0 || strcmp(assign->assignExpr->returnType,"none") == 0 || strcmp(assign->id->returnType,assign->assignExpr->returnType) != 0){
        if((flag == 0 || flag == 3) && !((strcmp(assign->id->returnType,"double") == 0) && strcmp(assign->assignExpr->returnType,"int") == 0)){
            printf("Line %d, col %d: Operator = cannot be applied to types %s, %s\n", assign->line, assign->col, assign->id->returnType, assign->assignExpr->returnType);
        }
    }
}

void insertExprType(IsExpr* expr, IsMethodDecl* method, TableElement* tableElement){
    if (expr) {
        char* type = NULL;
        if(expr->e == eAssign){
            IsAssign* assign = expr->eType.exprAssign;
            insertAssignType(assign, method, tableElement);
            type = assign->returnType;
        }
        else if(expr->e == eOp){
            IsOp* op = expr->eType.exprOp;
            insertOpType(op, method, tableElement);
            type = op->returnType;
        }
        else if(expr->e == eCall){
            IsCallStatement* call = expr->eType.exprCall;
            insertCallType(call, method, tableElement);
            type = call->returnType;
        }
        else if(expr->e == eParseArgs){
            IsParseArgsStatement* parseArgs = expr->eType.exprParseArgs;
            insertParseArgsType(parseArgs, method, tableElement);
            type = parseArgs->returnType;
        }
        else if(expr->e == eTerminal){
            IsTerminal* terminal = expr->eType.exprTerminal;
            insertTerminalType(terminal, method, tableElement);
            type = terminal->returnType;
        }
        else if(expr->e == eUnit){
            IsUnit* unit = expr->eType.exprUnit;
            insertUnitType(unit, method, tableElement);
            type = unit->returnType;
        }
        expr->returnType = type;
    }
}

/*
 * lshift e rshift, esq e dir têm de ser int? Esq pode ser double?
 * undef < boolean  ::  ?
 * xor tem de ter boolean nos 2 tipos?
 * lshift e rshift retornam none mas podem ser usados noutras operacoes? Por exemplo, soma?
 */
void insertOpType(IsOp* operation, IsMethodDecl* method, TableElement* tableElement){
    if(strcmp(operation->op,"Lshift") == 0 || strcmp(operation->op, "Rshift") == 0){
        operation->returnType = "none";
        return;
    }
    else if(strcmp(operation->op,"Xor") == 0){
        operation->returnType = "none";
        return;
    }
    insertExprType(operation->opExprLeft, method, tableElement);
    insertExprType(operation->opExprRight, method, tableElement);

    char* type1 = operation->opExprLeft->returnType;
    char* type2 = operation->opExprRight->returnType;

    if(strcmp(operation->op,"Mul") == 0 || strcmp(operation->op,"Div") == 0 || strcmp(operation->op,"Mod") == 0 || strcmp(operation->op,"Add") == 0 || strcmp(operation->op,"Sub") == 0){
        if((strcmp(type1,"double") == 0 || strcmp(type2,"double") == 0) && (strcmp(type1,"int") == 0 || strcmp(type2,"int") == 0)){
            operation->returnType = "double";
        }
        else if(strcmp(type1,type2) == 0 && (strcmp(type1,"double") == 0 || strcmp(type1,"int") == 0)){
            operation->returnType = type1;
        }
        else{
            operation->returnType = "undef";
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to types %s, %s\n", operation->line, operation->col, operation->symbol, type1, type2);
            }
        }
    }
    else if(strcmp(operation->op,"Le") == 0 || strcmp(operation->op,"Lt") == 0 || strcmp(operation->op,"Gt") == 0 || strcmp(operation->op,"Ge") == 0){
        operation->returnType = "boolean";
        if(!((strcmp(type1,"int") == 0 || strcmp(type1,"double") == 0) && (strcmp(type2,"int") == 0 || strcmp(type2,"double") == 0))){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to types %s, %s\n", operation->line, operation->col, operation->symbol, type1, type2);
            }
        }
    }
    else if(strcmp(operation->op,"Eq") == 0 || strcmp(operation->op,"Ne") == 0){
        operation->returnType = "boolean";
        if(!((strcmp(type1,type2) == 0 && (strcmp(type1,"int") == 0 || strcmp(type1,"double") == 0 || strcmp(type1,"boolean") == 0)) || ((strcmp(type1,"int") == 0 || strcmp(type1,"double") == 0) && (strcmp(type2,"int") == 0 || strcmp(type2,"double") == 0)))){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to types %s, %s\n", operation->line, operation->col, operation->symbol, type1, type2);
            }
        }
    }
    else if(strcmp(operation->op,"And") == 0 || strcmp(operation->op,"Or") == 0){
        operation->returnType = "boolean";
        if(strcmp(type1,"boolean") != 0 || strcmp(type2,"boolean") != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to types %s, %s\n", operation->line, operation->col, operation->symbol, type1, type2);
            }
        }
    }
}

void insertTerminalType(IsTerminal* terminal, IsMethodDecl* method, TableElement* tableElement){
    if (!strcmp(terminal->type, "DecLit")) {
        terminal->returnType = "int";

        char* value = removeUnderscore(terminal->value);
        long intValue = strtol(value, (char **)NULL, 10);

        if(intValue >= 2147483648){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Number %s out of bounds\n", terminal->line, terminal->col, terminal->value);
            }
        }
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
        terminal->returnType = getIdType(terminal->value, terminal->line, terminal->col, method, tableElement);
    }
    else{
        terminal->returnType = "undef";
    }
}

void insertUnitType(IsUnit* unit, IsMethodDecl* method, TableElement* tableElement){
    insertExprType(unit->unitExpr, method, tableElement);
    if(strcmp(unit->op,"Length") == 0){
        unit->returnType = "int";
        if(strcmp(unit->unitExpr->returnType,"String[]") != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to type %s\n", unit->line, unit->col, unit->symbol, unit->unitExpr->returnType);
            }
        }
    }
    else if(strcmp(unit->symbol,"!") == 0){
        unit->returnType = "boolean";
        if(strcmp(unit->unitExpr->returnType,"boolean") != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to type %s\n", unit->line, unit->col, unit->symbol, unit->unitExpr->returnType);
            }
        }
    }
    else{
        if(strcmp(unit->unitExpr->returnType,"double") != 0 && strcmp(unit->unitExpr->returnType,"int") != 0){
            if(flag == 0 || flag == 3){
                printf("Line %d, col %d: Operator %s cannot be applied to type %s\n", unit->line, unit->col, unit->symbol, unit->unitExpr->returnType);
            }
            unit->returnType = "undef";
        }
        else{
            unit->returnType = unit->unitExpr->returnType;        
        }
    }
}

char* getIdType(char* id, int line, int col, IsMethodDecl* method, TableElement* tableElement){
    MethodElement* methodIterator = tableElement->elements;
    for(;methodIterator && (methodIterator->line < line || (methodIterator->line == line && methodIterator->col < col));methodIterator=methodIterator->next){
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

    if(flag == 0 || flag == 3){
        printf("Line %d, col %d: Cannot find symbol %s\n", line, col, id);
    }
    return "undef";
}

void removeChar(char *str, char garbage) {

    char *src, *dst;
    for (src = dst = str; *src != '\0'; src++) {
        *dst = *src;
        if (*dst != garbage) dst++;
    }
    *dst = '\0';
}

char* removeUnderscore(char* value){
    char* returnValue = malloc(sizeof(char) * strlen(value));

    strcpy(returnValue, value);

    removeChar(returnValue, '_');

    return returnValue;
}