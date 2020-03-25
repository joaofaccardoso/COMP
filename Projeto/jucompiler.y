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

Program1: PUBLIC STATIC MethodField Program1
    | SEMICOLON Program1
    | %empty;

MethodField: VOID ID LPAR FormalParams RPAR MethodBody
    | Type ID Dif;  

Dif: LPAR FormalParams RPAR MethodBody
    | CommaId SEMICOLON;

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
    | IF LPAR Expr RPAR Statement2 Statement;
    | WHILE LPAR Expr RPAR Statement;
    | RETURN Statement3 SEMICOLON;
    | MethodInvocation SEMICOLON 
    | ID ASSIGN Expr SEMICOLON 
    | ParseArgs SEMICOLON;
    | PRINT LPAR Statement4 RPAR SEMICOLON;

Statement1: Statement Statement1
    | %empty;
Statement2: ELSE
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

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ LPAR;

Type: BOOL
    | INT
    | DOUBLE;

Expr: MINUS Expr2 
    | NOT Expr2
    | PLUS Expr2
    | LPAR Expr2 RPAR
    | ID Dotlenght Expr1
    | INTLIT Expr1
    | REALLIT Expr1
    | BOOLLIT Expr1
    | MethodInvocation Expr1
    | ID ASSIGN Expr2
    | ParseArgs Expr1;

Expr2: Expr1
    | Expr;

Expr1: STAR Expr
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