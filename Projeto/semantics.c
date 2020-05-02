#include "structures.h"
#include "symbol_table.h"
#include "semantics.h"
#include <stdio.h>

extern TableHead* symHead;

void checkProgram(IsProgram* program) {
    insertHead(program->id, program->line, program->col);
    checkMethodField(program->methodFieldList);
}

void checkMethodField(IsMethodField* mfList) {
    while (mfList) {
        if (mfList->mf==isField) {
            insertMethodVarDecl(mfList->mfType.fieldDecl->type, mfList->mfType.fieldDecl->id, var_decl, mfList->mfType.fieldDecl->line, mfList->mfType.fieldDecl->col);
        }
        else {
            TableElement* currentElement = insertMethodVarDecl(mfList->mfType.methodDecl->methodHeader->type, mfList->mfType.methodDecl->methodHeader->id, method_decl, mfList->mfType.methodDecl->methodHeader->line, mfList->mfType.methodDecl->methodHeader->col);
            if(currentElement != NULL) {
                checkParams(currentElement, mfList->mfType.methodDecl->methodHeader->paramDeclList);
                checkBody(currentElement, mfList->mfType.methodDecl->methodBody->vardDeclSatetmentList);
            }
        }
        mfList = mfList->next;
    }
}

void checkParams(TableElement* currentElement, IsParamDecl* paramList) {
    while (paramList) {
        insertParamBody(currentElement, paramList->type, paramList->id , param, paramList->line, paramList->col);
        paramList = paramList->next;
    }
}

void checkBody(TableElement* currentElement, IsVarDeclStatement* bodyList) {
    for(;bodyList;bodyList=bodyList->next){
        if(bodyList->vds == varDecl){
            insertParamBody(currentElement, bodyList->vdsType.varDecl->type, bodyList->vdsType.varDecl->id, body, bodyList->vdsType.varDecl->line, bodyList->vdsType.varDecl->col);
        }
    }
}