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

Program: CLASS ID LBRACE Program1 RBRACE
    | error;

Program1: PUBLIC STATIC MethodHeader MethodBody Program1
    | FieldDecl Program1
    | SEMICOLON Program1
    | %empty;

FieldDecl: PUBLIC STATIC Type ID CommaId SEMICOLON
    | error SEMICOLON;

Type: BOOL
    | INT
    | DOUBLE;

CommaId: COMMA ID CommaId
    | %empty;

MethodHeader: Type ID LPAR FormalParams RPAR
    | VOID ID LPAR FormalParams RPAR;

FormalParams: Type ID CommaTypeId
    | STRING LSQ RSQ ID
    | %empty;

CommaTypeId: COMMA ID CommaTypeId
    | %empty;

MethodBody: LBRACE MethodBody1 RBRACE;

MethodBody1: Statement MethodBody1
    | VarDecl MethodBody1
    | %empty;
    
VarDecl: Type ID CommaId SEMICOLON;

Statement: LBRACE Statement1 RBRACE
    | IF LPAR Expr RPAR Statement ElseStatement 
    | WHILE LPAR Expr RPAR 
    | RETURN SEMICOLON
    | RETURN Expr SEMICOLON
    | SEMICOLON
    | MethodInvocation SEMICOLON 
    | Assignment SEMICOLON
    | ParseArgs SEMICOLON
    | error SEMICOLON;

Statement1: Statement Statement1
    | %empty;

ElseStatement: ELSE Statement;

MethodInvocation: ID LPAR RPAR
    | ID LPAR Expr CommaExpr RPAR
    | PARSEINT LPAR error RPAR;

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
