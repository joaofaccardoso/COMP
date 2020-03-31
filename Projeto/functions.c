#include "structures.h"
#include "functions.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

IsProgram* insertProgram(char* id, IsMethodField* list) {
    IsProgram* ip = (IsProgram*)malloc(sizeof(IsProgram));

    ip->id = id;
    ip->methodFieldList = list;

    return ip;
}

IsMethodField* insertField(char* type, char* id, IsVarId* idsList) {
    IsVarId* ivi = (IsVarId*)malloc(sizeof(IsVarId));

    ivi->id = id;
    ivi->next = idsList;

    idsList = ivi;
    
    IsVarId* tempFree=NULL;
    IsVarId* temp;
    IsMethodField* head = NULL;
    IsMethodField* imfIterator = NULL;

    for (temp = idsList; temp;) {
        IsMethodField* imf = (IsMethodField*)malloc(sizeof(IsMethodField));
        IsFieldDecl* ifd = (IsFieldDecl*)malloc(sizeof(IsFieldDecl));

        ifd->type = type;
        ifd->id = temp->id;

        imf->mf = isField;
        imf->mfType.fieldDecl = ifd;
        
        if (head==NULL) {
            head = imf;
        }
        else{
            for (imfIterator = head; imfIterator->next; imfIterator=imfIterator->next);
            imfIterator->next = imf;
        }
        tempFree = temp;
        temp = temp->next;
        free(tempFree);
    }
    
    return head;
}

IsMethodField* insertMethodField(IsMethodField* head, IsMethodField* new) {
    if (new==NULL) {
        return head;
    }
    IsMethodField* imfIterator = NULL;
    
    for (imfIterator = new; imfIterator->next; imfIterator=imfIterator->next);
    
    imfIterator->next = head;

    return new;
}

IsMethodField* insertMethod(IsMethodHeader* methodHeader, IsMethodBody* methodBody) {
    IsMethodField* imf = (IsMethodField*)malloc(sizeof(IsMethodField));
    IsMethodDecl* imd = (IsMethodDecl*)malloc(sizeof(IsMethodDecl));

    imd->methodHeader = methodHeader;
    imd->methodBody = methodBody;

    imf->mf = isMethod;
    imf->mfType.methodDecl = imd;
    
    return imf;
}

IsMethodHeader* insertMethodHeader(char* type, char* id, IsParamDecl* paramDeclList) {
    IsMethodHeader* imh = (IsMethodHeader*)malloc(sizeof(IsMethodHeader));

    imh->type = type;
    imh->id = id;
    imh->paramDeclList = paramDeclList;

    return imh;
}

IsParamDecl* insertParamDecl(char* type, char* id, IsParamDecl* head) {
    IsParamDecl* ipd = (IsParamDecl*)malloc(sizeof(IsParamDecl));

    ipd->type = type;
    ipd->id = id;
    ipd->next = head;

    return ipd;
}

IsVarId* insertVarId(char* id, IsVarId* head){
    IsVarId* ivi = (IsVarId*)malloc(sizeof(IsVarId));

    ivi->id = id;
    ivi->next = head;
    
    return ivi;
}

IsVarDeclStatement* insertVarDecl(char* type, char* id, IsVarId* idList) {
    IsVarId* ivi = (IsVarId*)malloc(sizeof(IsVarId));

    ivi->id = id;
    ivi->next = idList;

    idList = ivi;
    
    IsVarId* tempFree=NULL;
    IsVarId* temp;
    IsVarDeclStatement* head = NULL;
    IsVarDeclStatement* ivdIterator = NULL;

    for (temp = idList; temp;) {
        IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
        IsVarDecl* ivd = (IsVarDecl*)malloc(sizeof(IsVarDecl));

        ivd->type = type;
        ivd->id = temp->id;

        ivds->vds = varDecl;
        ivds->vdsType.varDecl = ivd;
        
        if (head==NULL) {
            head = ivds;
        }
        else{
            for (ivdIterator = head; ivdIterator->next; ivdIterator=ivdIterator->next);
            ivdIterator->next = ivds;
        }
        tempFree = temp;
        temp = temp->next;
        free(tempFree);

    }
    return head;
}

IsVarDeclStatement* insertVarDeclStatement(IsVarDeclStatement* varDeclStatement, IsVarDeclStatement* head){
    IsVarDeclStatement* temp;

    if(varDeclStatement == NULL){
        return head;
    }

    for (temp = varDeclStatement; temp->next; temp = temp->next);
    
    temp->next = head;
    
    return varDeclStatement;
}

IsMethodBody* insertMethodBody(IsVarDeclStatement* head) {
    IsMethodBody* imb = (IsMethodBody*)malloc(sizeof(IsMethodBody));

    imb->vardDeclSatetmentList = head;

    return imb;
}

IsVarDeclStatement* insertBlockStatement(IsVarDeclStatement* statementList) {
    if (statementList == NULL) {
        return NULL;
    }
    else if (statementList->next) {
        IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
        IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
        
        is->sm = sBlock;
        is->smType.blockStatement = statementList;

        ivds->vds = statement;
        ivds->vdsType.statement = is;

        return ivds;
    }
    else {
        return statementList;
    }
}

IsVarDeclStatement* createBlockStatement(IsVarDeclStatement* newStatement, IsVarDeclStatement* head) {
    if (newStatement == NULL) {
        return head;
    }
    
    newStatement->next = head;

    return newStatement;
}

IsVarDeclStatement* insertIfStatement(IsExpr* ifExpr, IsVarDeclStatement* thenStatement, IsVarDeclStatement* elseStatement, int hasElse){
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsIfStatement* iifs = (IsIfStatement*)malloc(sizeof(IsIfStatement));

    iifs->ifExpr = ifExpr;
    iifs->thenBlock = thenStatement;
    iifs->elseBlock = elseStatement;
    iifs->hasElse = hasElse;
    
    is->sm=sIf;
    is->smType.ifStatement = iifs;

    ivds->vds = statement;
    ivds->vdsType.statement = is;

    return ivds;
}

IsVarDeclStatement* insertWhileStatement(IsExpr* whileExpr, IsVarDeclStatement* whileStatement){
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsWhileStatement* iws = (IsWhileStatement*)malloc(sizeof(IsWhileStatement));

    iws->whileExpr = whileExpr;
    iws->whileStatement = whileStatement;
    
    is->sm=sWhile;
    is->smType.whileStatement = iws;

    ivds->vds = statement;
    ivds->vdsType.statement = is;

    return ivds;
}

IsVarDeclStatement* insertReturnStatement(IsExpr* returnExpr) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsReturnStatement* irs = (IsReturnStatement*)malloc(sizeof(IsReturnStatement));

    irs->returnExpr = returnExpr;

    is->sm = sReturn;
    is->smType.returnStatement = irs;

    ivds->vds = statement;
    ivds->vdsType.statement = is;

    return ivds;
}

IsVarDeclStatement* insertCallStatement(IsCallStatement* ics) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));

    is->sm = sCall;
    is->smType.callStatement = ics;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    return ivds;
}

IsExpr* insertCallExpr(IsExpr* newExpr, IsExpr* head) {
    if(newExpr==NULL){
        return head;
    }
    newExpr->next = head;
    return newExpr;
}

IsCallStatement* createCallStatement(char* id, IsExpr* newExpr, IsExpr* head) {
    if(newExpr != NULL){
        newExpr->next = head;
        head = newExpr;
    }
    
    IsCallStatement* ics = (IsCallStatement*)malloc(sizeof(IsCallStatement));

    ics->id = id;
    ics->callExpr = head;

    return ics;
}

IsVarDeclStatement* insertAssignStatement(IsAssign* assignStatement) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));

    is->sm = sAssign;
    is->smType.assignStatement = assignStatement;

    ivds->vds = statement;
    ivds->vdsType.statement = is;

    return ivds;
}

IsAssign* createAssign(char* id, IsExpr* assignExpr) {
    IsAssign* ia = (IsAssign*)malloc(sizeof(IsAssign));

    ia->id = id;
    ia->assignExpr = assignExpr;

    return ia;
}

IsVarDeclStatement* insertParseArgsStatement(IsParseArgsStatement* ipas) {
    if (ipas==NULL) {
        return NULL;
    }
    
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));

    is->sm = sParseArgs;
    is->smType.parseArgsStatement = ipas;

    ivds->vds = statement;
    ivds->vdsType.statement = is;

    return ivds;
}

IsParseArgsStatement* createParseArgsStatement(char* id, IsExpr* parseArgsExpr) {
    IsParseArgsStatement* ipas = (IsParseArgsStatement*)malloc(sizeof(IsParseArgsStatement));

    ipas->id = id;
    ipas->parseArgsExpr = parseArgsExpr;

    return ipas;
}

IsVarDeclStatement* insertPrintStatement(dPrint p, char* printString, IsExpr* printExpr) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsPrintStatement* ips = (IsPrintStatement*)malloc(sizeof(IsPrintStatement));

    if (p==stringLiteral) {
        ips->p = p;
        ips->pType.printString = printString;
    } else {
        ips->p = expression;
        ips->pType.printExpr = printExpr;
    }

    is->sm = sPrint;
    is->smType.printStatement = ips;

    ivds->vds = statement;
    ivds->vdsType.statement = is;

    return ivds;
}

IsExpr* insertAssignExpr(IsAssign* assignExpr) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));

    ie->e = eAssign;
    ie->eType.exprAssign = assignExpr;

    return ie;
}

IsExpr* insertOp(IsExpr* opExprLeft, char* op, IsExpr* opExprRight) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));
    IsOp* io = (IsOp*)malloc(sizeof(IsOp));

    io->opExprLeft = opExprLeft;
    io->op = op;
    io->opExprRight = opExprRight;
    
    ie->e = eOp;
    ie->eType.exprOp = io;

    return ie;
}

IsExpr* insertUnit(char* op, IsExpr* unitExpr, char* id) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));
    IsUnit* iu = (IsUnit*)malloc(sizeof(IsUnit));
    iu->op = op;

    if(id!=NULL){
        iu->unitExpr = insertTerminal("Id",id);
    }
    else{
        iu->unitExpr = unitExpr;
    }


    ie->e = eUnit;
    ie->eType.exprUnit = iu;

    return ie;
}

IsExpr* insertExprCall(IsCallStatement* ics) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));

    ie->e = eCall;
    ie->eType.exprCall = ics;

    return ie;
}

IsExpr* insertExprParseArgs(IsParseArgsStatement* ipas) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));

    ie->e = eParseArgs;
    ie->eType.expParseArgs = ipas;

    return ie;
}

IsExpr* insertTerminal(char* type, char* value){
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));
    IsTerminal* it = (IsTerminal*)malloc(sizeof(IsTerminal));
    
    it->type = type;
    it->value = value;

    ie->e = eTerminal;
    ie->eType.exprTerminal = it;

    return ie;
}   