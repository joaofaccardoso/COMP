%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
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

Program1: PUBLIC STATIC MethodField Program1
    | SEMICOLON Program1
    | %empty;

MethodField: MethodHeader MethodBody
    | Type ID CommaId SEMICOLON;

MethodHeader: Type ID LPAR FormalParams RPAR
    | VOID ID LPAR FormalParams RPAR;

FormalParams: Type ID FormalParams1
    | STRING LSQ RSQ ID;
    | %empty;

FormalParams1: COMMA Type ID FormalParams
    | %empty;

MethodBody: LBRACE MethodBody1 RBRACE;

MethodBody1: Statement MethodBody1
    | VarDecl MethodBody1
    | %empty;

VarDecl: Type ID CommaId SEMICOLON;

CommaId: COMMA ID CommaId
    | %empty;
    
Statement: LBRACE Statement1 RBRACE;
    | IF LPAR Expr RPAR Statement Statement2;
    | WHILE LPAR Expr RPAR Statement;
    | RETURN Statement3 SEMICOLON;
    | MethodInvocation SEMICOLON 
    | Assignment SEMICOLON 
    | ParseArgs SEMICOLON;
    | PRINT LPAR Statement4 RPAR SEMICOLON;

Statement1: Statement Statement1
    | %empty;
Statement2: ELSE Statement
    | %empty;
Statement3: Expr
    | %empty;
Statement4: Expr 
    | STRLIT;

MethodInvocation: ID LPAR MethodInvocation1 RPAR;

MethodInvocation1: Expr CommaExpr
    | %empty;

CommaExpr: COMMA Expr CommaExpr
    | %empty;
    
Assignment: ID ASSIGN Expr;

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ LPAR;

Type: BOOL
    | INT
    | DOUBLE;

Expr: MINUS Expr1 
    | NOT Expr1 
    | PLUS Expr1
    | LPAR Expr RPAR Expr2
    | ID Dotlenght Expr2
    | INTLIT Expr2
    | REALLIT Expr2
    | BOOLLIT Expr2
    | MethodInvocation Expr2
    | Assignment Expr2
    | ParseArgs Expr2;
Expr1: Expr
    | Expr2;
Expr2: STAR Expr
    | DIV Expr
    | MOD Expr
    | AND Expr
    | OR Expr 
    | XOR Expr 
    | LSHIFT Expr 
    | RSHIFT Expr
    | EQ Expr 
    | GE Expr 
    | GT Expr 
    | LE Expr 
    | LT Expr 
    | NE Expr
    | %empty;
Dotlenght: DOTLENGHT
    | %empty;
%%