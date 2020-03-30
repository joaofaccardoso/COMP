#ifndef STRUCTURES_H
#define STRUCTURES_H

typedef struct s19 {
    
} IsAssign;

typedef struct s18 {
    
} IsParseArgsStatement;

typedef struct s17 {

} IsPrintStatement;

typedef struct s16 {
    
} IsCallStatement;

typedef struct s15 {

} IsReturnStatement;

typedef struct s14 {

} IsWhileStatement;

typedef struct s13 {
    
} IsIfStatement;

typedef struct s12 {
    
} IsStatementBlock;


typedef struct s11 {
    char* id;
    struct s11* next;
} IsVarId;

typedef enum {sBlock, sIf, sWhile, sReturn, sCall, sPrint, sParseArgs, sAssign} dStatement; 

typedef struct s10 {
    dStatement sm;
    union {
        IsStatementBlock* block;
        IsIfStatement* ifStatement;
        IsWhileStatement* whileStatement;
        IsReturnStatement* returnStatement;
        IsAssign* assign;
        IsParseArgsStatement* parseArgs;
        IsPrintStatement* print;
        IsCallStatement* call;
    } smType;
    struct s10* next;
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