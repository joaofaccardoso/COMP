%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    int yylex(void);
    void yyerror (const char *s);
%}
%nonassoc REDUCE 
%nonassoc ELSE 

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
    | %empty ;

MethodDecl: PUBLIC STATIC MethodHeader MethodBody;

FieldDecl:  PUBLIC STATIC Type ID CommaId SEMICOLON
    | error SEMICOLON;

CommaId: COMMA ID CommaId 
    | %empty;

Type:  BOOL 
    | INT 
    | DOUBLE;

MethodHeader:  Type ID LPAR FormalParams RPAR
    | VOID ID LPAR FormalParams RPAR;

FormalParams:  Type ID CommaTypeId
    | STRING LSQ RSQ ID
    | %empty;

CommaTypeId: COMMA Type ID CommaTypeId
    | %empty;


MethodBody:  LBRACE MethodBody1 RBRACE;

MethodBody1: VarDecl MethodBody1
    | Statement MethodBody1
    | %empty;

VarDecl:  Type ID CommaId SEMICOLON;

Statement: LBRACE StatementLoop RBRACE
    | IF LPAR Expr RPAR Statement %prec REDUCE
    | IF LPAR RPAR Statement ELSE Statement
    | WHILE LPAR Expr RPAR Statement
    | RETURN Expr SEMICOLON
    | RETURN SEMICOLON
    | MethodInvocation SEMICOLON
    | Assignment SEMICOLON
    | ParseArgs SEMICOLON
    | SEMICOLON
    | PRINT LPAR STRLIT RPAR SEMICOLON;
    | PRINT LPAR Expr RPAR SEMICOLON;
    | error SEMICOLON;
    
StatementLoop: Statement StatementLoop
    | %empty;

MethodInvocation: ID LPAR Expr CommaExpr RPAR
    | ID LPAR RPAR
    | ID LPAR error RPAR;

CommaExpr: COMMA Expr CommaExpr
    | %empty;

Assignment: ID ASSIGN Expr;

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ RPAR
    | PARSEINT LPAR error RPAR;

Expr: LPAR Expr RPAR
    | MethodInvocation 
    | Assignment 
    | ParseArgs
    | MINUS Expr
    | NOT Expr
    | PLUS Expr
    | ID DOTLENGHT
    | ID
    | INTLIT
    | BOOLLIT
    | REALLIT;
%%