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

Program: CLASS ID LBRACE Declarations RBRACE;

Declarations: MethodDecl Declarations
            | FieldDecl Declarations
            | SEMICOLON Declarations
            | %empty
            ;

FieldDecl: PUBLIC STATIC Type ID CommaId SEMICOLON
        |  error SEMICOLON
        ;

MethodDecl: PUBLIC STATIC MethodHeader MethodBody;

MethodHeader: Type ID LPAR FormalParams RPAR
            | VOID ID LPAR FormalParams RPAR
            ;

FormalParams: Type ID CommaTypeId
            | STRING LSQ RSQ ID
            | %empty
            ;

MethodBody: LBRACE MethodBodyContent RBRACE;

MethodBodyContent: Statement MethodBodyContent
                |  VarDecl MethodBodyContent
                |  %empty
                ;

VarDecl: Type ID CommaId SEMICOLON;

CommaId: COMMA ID CommaId
      |  %empty
      ;

CommaTypeId: COMMA Type ID CommaTypeId
          |  %empty
          ;

Type: BOOL
    | INT
    | DOUBLE
    ;

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

MethodInvocation: ID MethodInvocation2;

MethodInvocation2: LPAR MethodInvocation1 RPAR;

MethodInvocation1: Expr CommaExpr
    | %empty;

CommaExpr: COMMA Expr CommaExpr
    | %empty;

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ LPAR;

Type: BOOL
    | INT
    | DOUBLE;

Expr: MINUS Expr2
    | PLUS Expr2
    | Expr4;

Expr4: NOT Expr2
    | LPAR Expr2 RPAR
    | ID Expr3
    | INTLIT Expr1
    | REALLIT Expr1
    | BOOLLIT Expr1
    | ParseArgs Expr1;

Expr3: Dotlenght Expr1
    | ASSIGN Expr2
    | MethodInvocation2 Expr1;

Expr2: Expr1
    | Expr4;

Expr1: PLUS Expr
    | MINUS Expr
    | STAR Expr
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
