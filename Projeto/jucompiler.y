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

MethodBody1: Type ID CommaId SEMICOLON MethodBody1
    | %empty;


%%
