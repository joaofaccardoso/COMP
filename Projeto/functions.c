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