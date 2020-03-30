#ifndef STRUCTURES_H
#define STRUCTURES_H

typedef struct s11 {
    char* id;
    struct s11* next;
} IsVarId;

typedef struct s10 {

} IsStatement;

typedef struct s9 {
    char* type;
    char* id;
} IsVarDecl;

typedef enum {varDecl, statement} dVardDeclSatetment;

typedef struct s8 {
    dVardDeclSatetment vds; 
    union {
        IsVarDecl* varDecl;
        IsStatement* statement;
    } vdsType;
    struct s8* next;
} IsVarDeclStatement;

typedef struct s7 {
    char* type;
    char* id;
    struct s7* next;
} IsParamDecl;

typedef struct s6 {
    IsVarDeclStatement* vardDeclSatetmentList;
} IsMethodBody;

typedef struct s5 {
    char* type;
    char* id;
    IsParamDecl* paramDeclList;
} IsMethodHeader;

typedef struct s4 {
    char* type;
    char* id;
} IsFieldDecl;

typedef struct s3 {
    IsMethodHeader* methodHeader;
    IsMethodBody* methodBody;
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