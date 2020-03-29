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

IsMethodField* insertMethodField(IsMethodField* head, IsMethodField* new) {
    if (new==NULL) {
        return head;
    }
    
    new->next = head;

    return new;
}