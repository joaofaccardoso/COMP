#include "structures.h"
#include "symbol_table.h"
#include "semantics.h"
#include <stdio.h>

extern TableHead* symHead;

void checkProgram(IsProgram* program) {
    insertHead(program->id);
    checkMethodField(program->methodFieldList);
}

void checkMethodField(IsMethodField* mfList) {
    while (mfList) {
        if (mfList->mf==isField) {
            insertMethodVarDecl(mfList->mfType.fieldDecl->type, mfList->mfType.fieldDecl->id, var_decl);
        }
        else {
            insertMethodVarDecl(mfList->mfType.methodDecl->methodHeader->type, mfList->mfType.methodDecl->methodHeader->id, method_decl);
        }
        mfList = mfList->next;
    }
}