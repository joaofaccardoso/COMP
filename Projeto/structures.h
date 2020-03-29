#ifndef STRUCTURES_H
#define STRUCTURES_H

typedef struct s4 {
    int x;
} IsFieldDecl;

typedef struct s3 {
    int y;
} IsMethodDecl;

typedef enum {isMethod, isField} dMethodField;

typedef struct s2 {
    dMethodField mf; 
    union {
        IsMethodDecl* methodDecl;
        IsFieldDecl* fieldDecl;
    } mfType;
    struct s2* next;
} IsMethodField;

typedef struct s1 {
    char* id;
    IsMethodField* methodFieldList;
} IsProgram;

#endif