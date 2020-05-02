#include "structures.h"
#include "functions.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

IsProgram* insertProgram(char* id, IsMethodField* list, int line, int col) {
    IsProgram* ip = (IsProgram*)malloc(sizeof(IsProgram));

    ip->id = id;
    ip->methodFieldList = list;
    ip->line = line;
    ip->col = col;

    return ip;
}

IsMethodField* insertField(char* type, char* id, IsVarId* idsList, int line, int col) {
    IsVarId* ivi = (IsVarId*)malloc(sizeof(IsVarId));

    ivi->id = id;
    ivi->next = idsList;
    ivi->line = line;
    ivi->col = col;

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
        ifd->line = temp->line;
        ifd->col = temp->col;

        imf->mf = isField;
        imf->mfType.fieldDecl = ifd;
        imf->line = ifd->line;
        imf->col = ifd->col;
        
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

IsMethodField* insertMethod(IsMethodHeader* methodHeader, IsMethodBody* methodBody, int line, int col) {
    IsMethodField* imf = (IsMethodField*)malloc(sizeof(IsMethodField));
    IsMethodDecl* imd = (IsMethodDecl*)malloc(sizeof(IsMethodDecl));

    imd->methodHeader = methodHeader;
    imd->methodBody = methodBody;
    imd->line = line;
    imd->col = col;

    imf->mf = isMethod;
    imf->mfType.methodDecl = imd;
    imf->line = line;
    imf->col = col;
    
    return imf;
}

IsMethodHeader* insertMethodHeader(char* type, char* id, IsParamDecl* paramDeclList, int line, int col) {
    IsMethodHeader* imh = (IsMethodHeader*)malloc(sizeof(IsMethodHeader));

    imh->type = type;
    imh->id = id;
    imh->paramDeclList = paramDeclList;
    imh->line = line;
    imh->col = col;

    return imh;
}

IsParamDecl* insertParamDecl(char* type, char* id, IsParamDecl* head, int line, int col) {
    IsParamDecl* ipd = (IsParamDecl*)malloc(sizeof(IsParamDecl));

    ipd->type = type;
    ipd->id = id;
    ipd->next = head;
    ipd->line = line;
    ipd->col = col;

    return ipd;
}

IsVarId* insertVarId(char* id, IsVarId* head, int line, int col){
    IsVarId* ivi = (IsVarId*)malloc(sizeof(IsVarId));

    ivi->id = id;
    ivi->next = head;
    ivi->line = line;
    ivi->col = col;
    
    return ivi;
}

IsVarDeclStatement* insertVarDecl(char* type, char* id, IsVarId* idList, int line, int col) {
    IsVarId* ivi = (IsVarId*)malloc(sizeof(IsVarId));

    ivi->id = id;
    ivi->next = idList;
    ivi->line = line;
    ivi->col = col;

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
        ivd->line = temp->line;
        ivd->col = temp->col;

        ivds->vds = varDecl;
        ivds->vdsType.varDecl = ivd;
        ivds->line = temp->line;
        ivds->col = temp->col;
        
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

IsMethodBody* insertMethodBody(IsVarDeclStatement* head, int line, int col) {
    IsMethodBody* imb = (IsMethodBody*)malloc(sizeof(IsMethodBody));

    imb->vardDeclSatetmentList = head;
    imb->line = line;
    imb->col = col;

    return imb;
}

IsVarDeclStatement* insertBlockStatement(IsVarDeclStatement* statementList, int line, int col) {
    if (statementList == NULL) {
        return NULL;
    }
    else if (statementList->next) {
        IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
        IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
        
        is->sm = sBlock;
        is->smType.blockStatement = statementList;
        is->line = line;
        is->col = col;

        ivds->vds = statement;
        ivds->vdsType.statement = is;
        ivds->line = is->line;
        ivds->col = is->col;

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

IsVarDeclStatement* insertIfStatement(IsExpr* ifExpr, IsVarDeclStatement* thenStatement, IsVarDeclStatement* elseStatement, int hasElse, int line, int col){
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsIfStatement* iifs = (IsIfStatement*)malloc(sizeof(IsIfStatement));

    iifs->ifExpr = ifExpr;
    iifs->thenBlock = thenStatement;
    iifs->elseBlock = elseStatement;
    iifs->hasElse = hasElse;
    iifs->line = line;
    iifs->col = col;
    
    is->sm=sIf;
    is->smType.ifStatement = iifs;
    is->line = iifs->line;
    is->col = iifs->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;

    return ivds;
}

IsVarDeclStatement* insertWhileStatement(IsExpr* whileExpr, IsVarDeclStatement* whileStatement, int line, int col){
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsWhileStatement* iws = (IsWhileStatement*)malloc(sizeof(IsWhileStatement));

    iws->whileExpr = whileExpr;
    iws->whileStatement = whileStatement;
    iws->line = line;
    iws->col = col;
    
    is->sm=sWhile;
    is->smType.whileStatement = iws;
    is->line = iws->line;
    is->col = iws->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;

    return ivds;
}

IsVarDeclStatement* insertReturnStatement(IsExpr* returnExpr, int line, int col) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));
    IsReturnStatement* irs = (IsReturnStatement*)malloc(sizeof(IsReturnStatement));

    irs->returnExpr = returnExpr;
    irs->line = line;
    irs->col = col;

    is->sm = sReturn;
    is->smType.returnStatement = irs;
    is->line = irs->line;
    is->col = irs->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;

    return ivds;
}

IsVarDeclStatement* insertCallStatement(IsCallStatement* ics, int line, int col) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));

    is->sm = sCall;
    is->smType.callStatement = ics;
    is->line = ics->line;
    is->col = ics->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;
    return ivds;
}

IsExpr* insertCallExpr(IsExpr* newExpr, IsExpr* head) {
    if(newExpr==NULL){
        return head;
    }
    newExpr->next = head;
    return newExpr;
}

IsCallStatement* createCallStatement(char* id, IsExpr* newExpr, IsExpr* head, int line, int col) {
    if(newExpr != NULL){
        newExpr->next = head;
        head = newExpr;
    }
    
    IsCallStatement* ics = (IsCallStatement*)malloc(sizeof(IsCallStatement));

    ics->id = id;
    ics->callExpr = head;
    ics->line = line;
    ics->col = col;

    return ics;
}

IsVarDeclStatement* insertAssignStatement(IsAssign* assignStatement) {
    IsVarDeclStatement* ivds = (IsVarDeclStatement*)malloc(sizeof(IsVarDeclStatement));
    IsStatement* is = (IsStatement*)malloc(sizeof(IsStatement));

    is->sm = sAssign;
    is->smType.assignStatement = assignStatement;
    is->line = assignStatement->line;
    is->col = assignStatement->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;

    return ivds;
}

IsAssign* createAssign(char* id, IsExpr* assignExpr, int line, int col) {
    IsAssign* ia = (IsAssign*)malloc(sizeof(IsAssign));

    ia->id = id;
    ia->assignExpr = assignExpr;
    ia->line = line;
    ia->col = col;

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
    is->line = ipas->line;
    is->col = ipas->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;

    return ivds;
}

IsParseArgsStatement* createParseArgsStatement(char* id, IsExpr* parseArgsExpr, int line, int col) {
    IsParseArgsStatement* ipas = (IsParseArgsStatement*)malloc(sizeof(IsParseArgsStatement));

    ipas->id = id;
    ipas->parseArgsExpr = parseArgsExpr;
    ipas->line = line;
    ipas->col = col;

    return ipas;
}

IsVarDeclStatement* insertPrintStatement(dPrint p, char* printString, IsExpr* printExpr, int line, int col) {
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
    ips->line = line;
    ips->col = col;

    is->sm = sPrint;
    is->smType.printStatement = ips;
    is->line = ips->line;
    is->col = ips->col;

    ivds->vds = statement;
    ivds->vdsType.statement = is;
    ivds->line = is->line;
    ivds->col = is->col;

    return ivds;
}

IsExpr* insertAssignExpr(IsAssign* assignExpr) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));

    ie->e = eAssign;
    ie->eType.exprAssign = assignExpr;
    ie->line = assignExpr->line;
    ie->col = assignExpr->col;

    return ie;
}

IsExpr* insertOp(IsExpr* opExprLeft, char* op, IsExpr* opExprRight, int line, int col) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));
    IsOp* io = (IsOp*)malloc(sizeof(IsOp));

    io->opExprLeft = opExprLeft;
    io->op = op;
    io->opExprRight = opExprRight;
    io->line = line;
    io->col = col;
    
    ie->e = eOp;
    ie->eType.exprOp = io;
    ie->line = io->line;
    ie->col = io->col;

    return ie;
}

IsExpr* insertUnit(char* op, IsExpr* unitExpr, char* id, int line, int col) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));
    IsUnit* iu = (IsUnit*)malloc(sizeof(IsUnit));
    iu->op = op;

    if(id!=NULL){
        iu->unitExpr = insertTerminal("Id",id, line, col);
    }
    else{
        iu->unitExpr = unitExpr;
    }

    iu->line = line;
    iu->col = col;

    ie->e = eUnit;
    ie->eType.exprUnit = iu;
    ie->line = iu->line;
    ie->col = iu->col;

    return ie;
}

IsExpr* insertExprCall(IsCallStatement* ics) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));

    ie->e = eCall;
    ie->eType.exprCall = ics;
    ie->line = ics->line;
    ie->col = ics->col;

    return ie;
}

IsExpr* insertExprParseArgs(IsParseArgsStatement* ipas) {
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));

    ie->e = eParseArgs;
    ie->eType.expParseArgs = ipas;
    ie->line = ipas->line;
    ie->col = ipas->col;

    return ie;
}

IsExpr* insertTerminal(char* type, char* value, int line, int col){
    IsExpr* ie = (IsExpr*)malloc(sizeof(IsExpr));
    IsTerminal* it = (IsTerminal*)malloc(sizeof(IsTerminal));
    
    it->type = type;
    it->value = value;
    it->line = line;
    it->col = col;

    ie->e = eTerminal;
    ie->eType.exprTerminal = it;
    ie->line = it->line;
    ie->col = it->col;

    return ie;
}   