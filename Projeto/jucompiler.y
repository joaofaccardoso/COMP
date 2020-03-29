%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include "functions.h"
    int yylex(void);
    void yyerror (const char *s);

    IsProgram* myProgram;

%}
%nonassoc REDUCE 
%nonassoc ELSE 

%token <charvalue> ID STRLIT BOOLLIT PRINT PARSEINT DOTLENGHT PUBLIC RETURN STATIC STRING VOID WHILE INT DOUBLE IF ELSE BOOL CLASS EQ ASSIGN COMMA DIV RSHIFT LSHIFT XOR GE GT LE LT MINUS MOD NE NOT OR PLUS SEMICOLON STAR ARROW AND LBRACE RBRACE LPAR RPAR LSQ RSQ RESERVED INTLIT REALLIT

%type <ip> Program
%type <imf> Program1 MethodDecl FieldDecl

%union{
    char* charvalue;
    IsProgram* ip;
    IsMethodField* imf;
    IsMethodDecl* imd;
    IsFieldDecl* ifd;
}

%%

Program: CLASS ID LBRACE Program1 RBRACE                    {$$=myProgram=insertProgram($2, $4);}                    
    ;

Program1: MethodDecl Program1                               {$$=insertMethodField($2, $1);}                             
    | FieldDecl Program1                                    {$$=insertMethodField($2, $1);}
    | SEMICOLON Program1                                    {$$=insertMethodField($2, NULL);}
    | %empty                                                {$$=NULL;}
    ;

MethodDecl: PUBLIC STATIC MethodHeader MethodBody           {$$=NULL;}         
    ;

FieldDecl:  PUBLIC STATIC Type ID CommaId SEMICOLON         {$$=NULL;}
    | error SEMICOLON                                       {$$=NULL;}
    ;

CommaId: COMMA ID CommaId 
    | %empty
    ;

Type:  BOOL                                                 
    | INT                                                   
    | DOUBLE                                                
    ;

MethodHeader: Type ID LPAR FormalParams RPAR                
    | VOID ID LPAR FormalParams RPAR                        
    ;

FormalParams: Type ID CommaTypeId                           
    | STRING LSQ RSQ ID                                     
    | %empty                                                
    ;

CommaTypeId: COMMA Type ID CommaTypeId                      
    | %empty                                                
    ;

MethodBody:  LBRACE MethodBody1 RBRACE                      
    ;

MethodBody1: VarDecl MethodBody1                            
    | Statement MethodBody1 
    | %empty
    ;

VarDecl:  Type ID CommaId SEMICOLON   
    ;                      

Statement: LBRACE StatementLoop RBRACE
    | IF LPAR Expr1 RPAR Statement %prec REDUCE
    | IF LPAR Expr1 RPAR Statement ELSE Statement
    | WHILE LPAR Expr1 RPAR Statement
    | RETURN Expr1 SEMICOLON
    | RETURN SEMICOLON
    | MethodInvocation SEMICOLON
    | ID ASSIGN Expr1 SEMICOLON
    | ParseArgs SEMICOLON
    | SEMICOLON
    | PRINT LPAR STRLIT RPAR SEMICOLON
    | PRINT LPAR Expr1 RPAR SEMICOLON
    | error SEMICOLON
    ;
    
StatementLoop: Statement StatementLoop
    | %empty
    ;

MethodInvocation: ID LPAR Expr1 CommaExpr RPAR
    | ID LPAR RPAR
    | ID LPAR error RPAR
    ;

CommaExpr: COMMA Expr1 CommaExpr
    | %empty
    ;

ParseArgs: PARSEINT LPAR ID LSQ Expr1 RSQ RPAR
    | PARSEINT LPAR error RPAR
    ;

PlusMinus: PLUS Expr3
    | MINUS Expr3
    ;

Expr1: PlusMinus
    | ExprAux1
    ;

Expr2: PlusMinus
    | ExprAux2
    ;

Expr3: ExprAux1
    | PlusMinus
    ;

ExprAux1: NOT Expr3
    | LPAR Expr3 RPAR Expr2
    | MethodInvocation Expr2
    | ID ASSIGN Expr3
    | ParseArgs Expr2
    | ID Expr2
    | ID DOTLENGHT Expr2
    | INTLIT Expr2
    | REALLIT Expr2
    | BOOLLIT Expr2;


ExprAux2: LSHIFT Expr3
    | RSHIFT Expr3
    | STAR Expr3
    | DIV Expr3
    | MOD Expr3
    | AND Expr3
    | OR Expr3
    | XOR Expr3
    | EQ Expr3
    | GE Expr3
    | GT Expr3
    | LE Expr3
    | LT Expr3
    | NE Expr3
    | %empty;
%%