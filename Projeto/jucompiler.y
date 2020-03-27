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

MethodBodyContent: VarDecl MethodBodyContent
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

%%
