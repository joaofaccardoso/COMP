%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    int yylex(void);
    void yyerror (const char *s);
%}

%token <charvalue> ID STRLIT BOOLLIT PRINT PARSEINT DOTLENGHT PUBLIC RETURN STATIC STRING VOID WHILE INT DOUBLE IF ELSE BOOL CLASS EQ ASSIGN COMMA DIV RSHIFT LSHIFT XOR GE GT LE LT MINUS MOD NE NOT OR PLUS SEMICOLON STAR ARROW AND LBRACE RBRACE LPAR RPAR LSQ RSQ RESERVED
%token <intvalue> INTLIT
%token <realvalue> REALLIT

%union{
    char* charvalue;
    int intvalue;
    float realvalue;
}

%%

Program: CLASS ID LBRACE Program1 RBRACE;

Program1: MethodDecl Program1
    | FieldDecl Program1
    | SEMICOLON Program1
    | %empty;

MethodDecl:  PUBLIC STATIC MethodHeader MethodBody;

FieldDecl:  PUBLIC STATIC Type ID CommaId SEMICOLON
    | error SEMICOLON;

CommaId: COMMA ID CommaId
    | %empty;

Type:  BOOL 
    | INT 
    | DOUBLE;

MethodHeader:  Type ID LPAR MethodHeader2 RPAR
    | VOID ID LPAR MethodHeader2 RPAR;

MethodHeader2: FormalParams
    | %empty;

FormalParams:  Type ID CommaTypeId;

CommaTypeId: COMMA Type ID CommaTypeId
    | %empty;

FormalParams:  STRING LSQ RSQ ID;

MethodBody:  LBRACE MethodBody1 RBRACE;

MethodBody1: VarDecl MethodBody1
    | Statement MethodBody1
    | %empty;

VarDecl:  Type ID CommaId SEMICOLON;

Statement: LBRACE StatementLoop RBRACE
    | IF LPAR Expr RPAR Statement ELSE Statement
    | WHILE LPAR Expr RPAR Statement
    | RETURN StatementExpr SEMICOLON
    | MethodInvocation SEMICOLON
    | Assignment SEMICOLON
    | ParseArgs SEMICOLON
    | SEMICOLON
    | PRINT LPAR ExprString RPAR SEMICOLON;

StatementLoop: Statement StatementLoop
    | %empty;

StatementExpr: Expr
    | %empty;

ExprString: Expr
    | STRLIT;

MethodInvocation: ID LPAR ExprCommaExpr RPAR;

ExprCommaExpr: Expr CommaExpr
    | %empty;

CommaExpr: COMMA Expr CommaExpr
    | %empty;

Assignment: ID ASSIGN Expr;

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ RPAR;

Expr: INTLIT
    | REALLIT 
    | BOOLLIT
    | MINUS Expr 
    | NOT Expr
    | PLUS Expr
    | LPAR Expr RPAR
    | MethodInvocation 
    | Assignment 
    | ParseArgs
    | ID Dotlenght
    | LPAR error RPAR;

Dotlenght: DOTLENGHT
    | %empty;
%%