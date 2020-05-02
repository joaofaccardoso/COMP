%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include "functions.h"
    int yylex(void);
    void yyerror (const char *s);

    IsProgram* myProgram;

    extern int line;
    extern int initCol;

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
%type <ivds> VarDecl Statement MethodBody1 StatementLoop
%type <ie> Expr CommaExpr Expr1 Expr2
%type <ics> MethodInvocation
%type <ipas> ParseArgs
%type <ia> Assignment

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
    IsExpr* ie;
    IsCallStatement* ics;
    IsParseArgsStatement* ipas;
    IsAssign* ia;
}

%%

Program: CLASS ID LBRACE Program1 RBRACE                    {$$=myProgram=insertProgram($2, $4, line, initCol);}                    
    ;

Program1: MethodDecl Program1                               {$$=insertMethodField($2, $1);}                             
    | FieldDecl Program1                                    {$$=insertMethodField($2, $1);}
    | SEMICOLON Program1                                    {$$=insertMethodField($2, NULL);}
    | %empty                                                {$$=NULL;}
    ;

MethodDecl: PUBLIC STATIC MethodHeader MethodBody           {$$=insertMethod($3, $4, line, initCol);}         
    ;

FieldDecl:  PUBLIC STATIC Type ID CommaId SEMICOLON         {$$=insertField($3,$4,$5, line, initCol);}
    | error SEMICOLON                                       {$$=NULL;}
    ;

CommaId: COMMA ID CommaId                                   {$$=insertVarId($2,$3, line, initCol);}
    | %empty                                                {$$=NULL;}
    ;

Type: BOOL                                                  {$$="Bool";}
    | INT                                                   {$$="Int";}
    | DOUBLE                                                {$$="Double";}
    ;

MethodHeader: Type ID LPAR FormalParams RPAR                {$$=insertMethodHeader($1,$2,$4, line, initCol);}            
    | VOID ID LPAR FormalParams RPAR                        {$$=insertMethodHeader("Void",$2,$4, line, initCol);}
    ;

FormalParams: Type ID CommaTypeId                           {$$=insertParamDecl($1,$2,$3, line, initCol);}                     
    | STRING LSQ RSQ ID                                     {$$=insertParamDecl("StringArray",$4,NULL, line, initCol);}
    | %empty                                                {$$=NULL;}
    ;

CommaTypeId: COMMA Type ID CommaTypeId                      {$$=insertParamDecl($2, $3, $4, line, initCol);}
    | %empty                                                {$$=NULL;}
    ;

MethodBody:  LBRACE MethodBody1 RBRACE                      {$$=insertMethodBody($2, line, initCol);}                  
    ;

MethodBody1: VarDecl MethodBody1                            {$$=insertVarDeclStatement($1,$2);}
    | Statement MethodBody1                                 {$$=insertVarDeclStatement($1,$2);}
    | %empty                                                {$$=NULL;}
    ;
            
VarDecl:  Type ID CommaId SEMICOLON                         {$$=insertVarDecl($1,$2,$3, line, initCol);}                     
    ;                      

Statement: LBRACE StatementLoop RBRACE                      {$$=insertBlockStatement($2, line, initCol);}
    | IF LPAR Expr RPAR Statement %prec REDUCE              {$$=insertIfStatement($3,$5,NULL,0, line, initCol);}
    | IF LPAR Expr RPAR Statement ELSE Statement            {$$=insertIfStatement($3,$5,$7,1, line, initCol);}
    | WHILE LPAR Expr RPAR Statement                        {$$=insertWhileStatement($3, $5, line, initCol);}
    | RETURN Expr SEMICOLON                                 {$$=insertReturnStatement($2, line, initCol);}
    | RETURN SEMICOLON                                      {$$=insertReturnStatement(NULL, line, initCol);}
    | MethodInvocation SEMICOLON                            {$$=insertCallStatement($1, line, initCol);}
    | Assignment SEMICOLON                                  {$$=insertAssignStatement($1);}
    | ParseArgs SEMICOLON                                   {$$=insertParseArgsStatement($1);}
    | SEMICOLON                                             {$$=NULL;}
    | PRINT LPAR STRLIT RPAR SEMICOLON                      {$$=insertPrintStatement(stringLiteral, $3, NULL, line, initCol);}
    | PRINT LPAR Expr RPAR SEMICOLON                        {$$=insertPrintStatement(expression, NULL, $3, line, initCol);}
    | error SEMICOLON                                       {$$=NULL;}
    ;
    
StatementLoop: Statement StatementLoop                      {$$=createBlockStatement($1, $2);}
    | %empty                                                {$$=NULL;}
    ;

MethodInvocation: ID LPAR Expr CommaExpr RPAR               {$$=createCallStatement($1, $3, $4, line, initCol);}
    | ID LPAR RPAR                                          {$$=createCallStatement($1, NULL, NULL, line, initCol);}
    | ID LPAR error RPAR                                    {$$=NULL;}
    ;

Assignment: ID ASSIGN Expr                                  {$$=createAssign($1, $3, line, initCol);}
    ;

CommaExpr: COMMA Expr CommaExpr                             {$$=insertCallExpr($2, $3);}
    | %empty                                                {$$=NULL;}
    ;

ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ RPAR               {$$=createParseArgsStatement($3, $5, line, initCol);}
    | PARSEINT LPAR error RPAR                              {$$=NULL;}
    ;

Expr: Assignment                                            {$$=insertAssignExpr($1);}
    | Expr1                                                 {$$=$1;}
    ;

Expr1: Expr1 PLUS Expr1                                     {$$=insertOp($1,"Add",$3, line, initCol);} 
    | Expr1 MINUS Expr1                                     {$$=insertOp($1,"Sub",$3, line, initCol);}
    | Expr1 STAR Expr1                                      {$$=insertOp($1,"Mul",$3, line, initCol);}
    | Expr1 DIV Expr1                                       {$$=insertOp($1,"Div",$3, line, initCol);}
    | Expr1 MOD Expr1                                       {$$=insertOp($1,"Mod",$3, line, initCol);}
    | Expr1 AND Expr1                                       {$$=insertOp($1,"And",$3, line, initCol);}
    | Expr1 OR Expr1                                        {$$=insertOp($1,"Or",$3, line, initCol);}
    | Expr1 XOR Expr1                                       {$$=insertOp($1,"Xor",$3, line, initCol);}
    | Expr1 LSHIFT Expr1                                    {$$=insertOp($1,"Lshift",$3, line, initCol);}
    | Expr1 RSHIFT Expr1                                    {$$=insertOp($1,"Rshift",$3, line, initCol);}
    | Expr1 EQ Expr1                                        {$$=insertOp($1,"Eq",$3, line, initCol);}
    | Expr1 GE Expr1                                        {$$=insertOp($1,"Ge",$3, line, initCol);}
    | Expr1 GT Expr1                                        {$$=insertOp($1,"Gt",$3, line, initCol);}
    | Expr1 LE Expr1                                        {$$=insertOp($1,"Le",$3, line, initCol);}
    | Expr1 LT Expr1                                        {$$=insertOp($1,"Lt",$3, line, initCol);}
    | Expr1 NE Expr1                                        {$$=insertOp($1,"Ne",$3, line, initCol);}
    | Expr2                                                 {$$=$1;}
    ;

Expr2: NOT Expr2 %prec PRE                                  {$$=insertUnit("Not",$2,NULL, line, initCol);}
    | PLUS Expr2 %prec PRE                                  {$$=insertUnit("Plus",$2,NULL, line, initCol);}
    | MINUS Expr2 %prec PRE                                 {$$=insertUnit("Minus",$2,NULL, line, initCol);}
    | MethodInvocation                                      {$$=insertExprCall($1);}
    | ParseArgs                                             {$$=insertExprParseArgs($1);}
    | LPAR Expr RPAR                                        {$$=$2;}
    | LPAR error RPAR                                       {$$=NULL;}
    | ID                                                    {$$=insertTerminal("Id",$1, line, initCol);}
    | ID DOTLENGHT                                          {$$=insertUnit("Length",NULL,$1, line, initCol);}
    | INTLIT                                                {$$=insertTerminal("DecLit",$1, line, initCol);}
    | REALLIT                                               {$$=insertTerminal("RealLit",$1, line, initCol);}
    | BOOLLIT                                               {$$=insertTerminal("BoolLit",$1, line, initCol);}
    ;

%%