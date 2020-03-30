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
%type <imh> MethodHeader
%type <imb> MethodBody
%type <ipd> FormalParams CommaTypeId
%type <charvalue> Type
%type <ivi> CommaId
%type <ivds> VarDecl Statement MethodBody1

%union{
    char* charvalue;
    IsProgram* ip;
    IsMethodField* imf;
    IsMethodDecl* imd;
    IsFieldDecl* ifd;
    IsMethodHeader* imh;
    IsMethodBody* imb;
    IsParamDecl* ipd;
    IsVarId* ivi;
    IsVarDeclStatement* ivds;
}

%%

Program: CLASS ID LBRACE Program1 RBRACE                    {$$=myProgram=insertProgram($2, $4);}                    
    ;

Program1: MethodDecl Program1                               {$$=insertMethodField($2, $1);}                             
    | FieldDecl Program1                                    {$$=insertMethodField($2, $1);}
    | SEMICOLON Program1                                    {$$=insertMethodField($2, NULL);}
    | %empty                                                {$$=NULL;}
    ;

MethodDecl: PUBLIC STATIC MethodHeader MethodBody           {$$=insertMethod($3, $4);}         
    ;

FieldDecl:  PUBLIC STATIC Type ID CommaId SEMICOLON         {$$=insertField($3,$4,$5);}
    | error SEMICOLON                                       {$$=NULL;}
    ;

CommaId: COMMA ID CommaId                                   {$$=insertVarId($2,$3);}
    | %empty                                                {$$=NULL;}
    ;

Type: BOOL                                                  {$$="Bool";}
    | INT                                                   {$$="Int";}
    | DOUBLE                                                {$$="Double";}
    ;

MethodHeader: Type ID LPAR FormalParams RPAR                {$$=insertMethodHeader($1,$2,$4);}            
    | VOID ID LPAR FormalParams RPAR                        {$$=insertMethodHeader("Void",$2,$4);}
    ;

FormalParams: Type ID CommaTypeId                           {$$=insertParamDecl($1,$2,$3);}                     
    | STRING LSQ RSQ ID                                     {$$=insertParamDecl("StringArray",$4,NULL);}
    | %empty                                                {$$=NULL;}
    ;

CommaTypeId: COMMA Type ID CommaTypeId                      {$$=insertParamDecl($2, $3, $4);}
    | %empty                                                {$$=NULL;}
    ;

MethodBody:  LBRACE MethodBody1 RBRACE                      {$$=insertMethodBody($2);}                  
    ;

MethodBody1: VarDecl MethodBody1                            {$$=insertVarDeclStatement($1,$2);}
    | Statement MethodBody1                                 {$$=insertVarDeclStatement($1,$2);}
    | %empty                                                {$$=NULL;}
    ;
            
VarDecl:  Type ID CommaId SEMICOLON                         {$$=insertVarDecl($1,$2,$3);}                     
    ;                      

Statement: LBRACE StatementLoop RBRACE                      {$$=NULL;}
    | IF LPAR Expr1 RPAR Statement %prec REDUCE             {$$=NULL;}
    | IF LPAR Expr1 RPAR Statement ELSE Statement           {$$=NULL;}
    | WHILE LPAR Expr1 RPAR Statement                       {$$=NULL;}
    | RETURN Expr1 SEMICOLON                                {$$=NULL;}
    | RETURN SEMICOLON                                      {$$=NULL;}
    | MethodInvocation SEMICOLON                            {$$=NULL;}
    | ID ASSIGN Expr1 SEMICOLON                             {$$=NULL;}
    | ParseArgs SEMICOLON                                   {$$=NULL;}
    | SEMICOLON                                             {$$=NULL;}
    | PRINT LPAR STRLIT RPAR SEMICOLON                      {$$=NULL;}
    | PRINT LPAR Expr1 RPAR SEMICOLON                       {$$=NULL;}
    | error SEMICOLON                                       {$$=NULL;}
    ;
    
StatementLoop: Statement StatementLoop
    | %empty;

MethodInvocation: ID LPAR Expr1 CommaExpr RPAR
    | ID LPAR RPAR
    | ID LPAR error RPAR;

CommaExpr: COMMA Expr1 CommaExpr
    | %empty;

ParseArgs: PARSEINT LPAR ID LSQ Expr1 RSQ RPAR
    | PARSEINT LPAR error RPAR;

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