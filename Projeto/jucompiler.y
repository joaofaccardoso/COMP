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

%right ASSIGN
%left OR
%left AND
%left XOR
%left EQ NE
%left GE LT GT LE
%left LSHIFT RSHIFT
%left PLUS MINUS
%left STAR DIV MOD
%right NOT PRE

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
    | IF LPAR Expr RPAR Statement %prec REDUCE              {$$=NULL;}
    | IF LPAR Expr RPAR Statement ELSE Statement            {$$=NULL;}
    | WHILE LPAR Expr RPAR Statement                        {$$=NULL;}
    | RETURN Expr SEMICOLON                                 {$$=NULL;}
    | RETURN SEMICOLON                                      {$$=NULL;}
    | MethodInvocation SEMICOLON                            {$$=NULL;}
    | Assignment SEMICOLON                                  {$$=NULL;}
    | ParseArgs SEMICOLON                                   {$$=NULL;}
    | SEMICOLON                                             {$$=NULL;}
    | PRINT LPAR STRLIT RPAR SEMICOLON                      {$$=NULL;}
    | PRINT LPAR Expr RPAR SEMICOLON                        {$$=NULL;}
    | error SEMICOLON                                       {$$=NULL;}
    ;
    
StatementLoop: Statement StatementLoop
    | %empty;

MethodInvocation: ID LPAR Expr CommaExpr RPAR
    | ID LPAR RPAR
    | ID LPAR error RPAR;

Assignment: ID ASSIGN Expr;

CommaExpr: COMMA Expr CommaExpr
    | %empty;

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ RPAR
    | PARSEINT LPAR error RPAR;

Expr: Assignment
    | Expr1;

Expr1: Expr1 PLUS Expr1
    | Expr1 MINUS Expr1
    | Expr1 STAR Expr1
    | Expr1 DIV Expr1
    | Expr1 MOD Expr1
    | Expr1 AND Expr1
    | Expr1 OR Expr1
    | Expr1 XOR Expr1
    | Expr1 LSHIFT Expr1
    | Expr1 RSHIFT Expr1
    | Expr1 EQ Expr1
    | Expr1 GE Expr1
    | Expr1 GT Expr1
    | Expr1 LE Expr1
    | Expr1 LT Expr1
    | Expr1 NE Expr1
    | Expr2
    ;

Expr2: NOT Expr2 %prec PRE
    | PLUS Expr2 %prec PRE
    | MINUS Expr2 %prec PRE
    | Expr3
    ;

Expr3: MethodInvocation 
    | ParseArgs
    | LPAR Expr RPAR
    | LPAR error RPAR
    | ID
    | ID DOTLENGHT
    | INTLIT 
    | REALLIT 
    | BOOLLIT
    ;

%%