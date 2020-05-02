#ifndef STRUCTURES_H
#define STRUCTURES_H

typedef struct s23 {
    char* type;    
    char* value;
    int line, col;
} IsTerminal;

typedef struct s22 {
    char* op;    
    struct s20* unitExpr;
    int line, col;
} IsUnit;

typedef struct s21 {
    struct s20* opExprLeft;
    char* op;
    struct s20* opExprRight;
    int line, col;
} IsOp;

typedef enum {eAssign, eOp, eCall, eParseArgs, eTerminal, eUnit} dExpr;

typedef struct s20 {
    dExpr e;
    union{
        struct s19* exprAssign;
        IsOp* exprOp;
        IsUnit* exprUnit;
        struct s16* exprCall;
        struct s18* expParseArgs;
        IsTerminal* exprTerminal;
    } eType;
    int line, col;
    struct s20* next;
} IsExpr;

typedef enum {expression, stringLiteral} dPrint;

typedef struct s17 {
    dPrint p;
    union {
        char* printString;
        IsExpr* printExpr;
    } pType;
    int line, col;
} IsPrintStatement;

typedef struct s18 {
    char* id;
    IsExpr* parseArgsExpr;
    int line, col;
} IsParseArgsStatement;

typedef struct s19 {
    char* id;
    IsExpr* assignExpr;
    int line, col;
} IsAssign;

typedef struct s16 {
    char* id;
    IsExpr* callExpr;
    int line, col;
} IsCallStatement;

typedef struct s15 {
    IsExpr* returnExpr;
    int line, col;
} IsReturnStatement;

typedef struct s14 {
    IsExpr* whileExpr;
    struct s8* whileStatement;
    int line, col;
} IsWhileStatement;

typedef struct s13 {
    int hasElse;
    IsExpr* ifExpr;
    struct s8* thenBlock;
    struct s8* elseBlock;
    int line, col;
} IsIfStatement;

typedef struct s11 {
    char* id;
    int line, col;
    struct s11* next;
} IsVarId;

typedef enum {sBlock, sIf, sWhile, sReturn, sCall, sPrint, sParseArgs, sAssign} dStatement; 

typedef struct s10 {
    dStatement sm;
    union {
        struct s8* blockStatement;
        IsIfStatement* ifStatement;
        IsWhileStatement* whileStatement;
        IsReturnStatement* returnStatement;
        IsCallStatement* callStatement;
        IsAssign* assignStatement;
        IsParseArgsStatement* parseArgsStatement;
        IsPrintStatement* printStatement;
    } smType;
    int line, col;
} IsStatement;

typedef struct s9 {
    char* type;
    char* id;
    int line, col;
} IsVarDecl;

typedef enum {varDecl, statement} dVardDeclSatetment;

typedef struct s8 {
    dVardDeclSatetment vds; 
    union {
        IsVarDecl* varDecl;
        IsStatement* statement;
    } vdsType;
    int line, col;
    struct s8* next;
} IsVarDeclStatement;

typedef struct s7 {
    char* type;
    char* id;
    int line, col;
    struct s7* next;
} IsParamDecl;

typedef struct s6 {
    IsVarDeclStatement* vardDeclSatetmentList;
    int line, col;
} IsMethodBody;

typedef struct s5 {
    char* type;
    char* id;
    IsParamDecl* paramDeclList;
    int line, col;
} IsMethodHeader;

typedef struct s4 {
    char* type;
    char* id;
    int line, col;
} IsFieldDecl;

typedef struct s3 {
    IsMethodHeader* methodHeader;
    IsMethodBody* methodBody;
    int line, col;
} IsMethodDecl;

typedef enum {isMethod, isField} dMethodField;

typedef struct s2 {
    dMethodField mf; 
    union {
        IsMethodDecl* methodDecl;
        IsFieldDecl* fieldDecl;
    } mfType;
    int line, col;
    struct s2* next;
} IsMethodField;

typedef struct s1 {
    char* id;
    IsMethodField* methodFieldList;
    int line, col;
} IsProgram;

#endif