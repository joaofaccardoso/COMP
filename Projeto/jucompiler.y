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
Program: CLASS ID LBRACE Decl RBRACE 
    | %empty;
Decl: SEMICOLON Decl                                {;}
    | PUBLIC STATIC MethodField Decl                {;};
MethodField: MethodHeader MethodBody                {;}
    | Type ID CommaId SEMICOLON                     {;};

CommaId: COMMA ID CommaId                           {;}
    | %empty                                        {;};

Type: BOOL                                          {;}
    | INT                                           {;}
    | DOUBLE                                        {;};
MethodHeader: Type MethodHeader1                    {;} 
    | VOID MethodHeader1                            {;};
MethodHeader1: ID LPAR MethodHeader2 RPAR           {;};
MethodHeader2: FormalParams                         {;}
    | %empty                                        {;};
FormalParams: Type FormalParams1                    {;}
    | STRING LSQ RSQ ID                             {;};
FormalParams1: ID COMMA Type ID FormalParams1       {;}
    | %empty                                        {;};
MethodBody: LBRACE MethodBody1 RBRACE               {;};
MethodBody1: Statement MethodBody1                  {;}
    | VarDecl MethodBody1                           {;}
    | %empty                                        {;};
VarDecl: Type ID CommaId SEMICOLON                  {;};
Statement: LBRACE Statement5 RBRACE                 {;};
    | IF LPAR Expr RPAR Statement Statement1        {;}
    | WHILE LPAR Expr RPAR Statement                {;}
    | RETURN Statement3 SEMICOLON                   {;}
    | Statement2 SEMICOLON                          {;}
    | PRINT LPAR Statement4 RPAR SEMICOLON          {;};
Statement1: ELSE Statement                          {;}
    | %empty                                        {;};
Statement2: MethodInvocation                        {;} 
    | Assignment                                    {;} 
    | ParseArgs                                     {;}
    | %empty                                        {;};
Statement3: Expr                                    {;}
    | %empty                                        {;};
Statement4: Expr                                    {;}
    | STRLIT                                        {;};
Statement5: Statement Statement5                    {;}
    | %empty                                        {;};
MethodInvocation: ID LPAR MethodInvocation1 RPAR    {;};
MethodInvocation1: Expr MethodInvocation2           {;}
    | %empty                                        {;};   
MethodInvocation2: COMMA Expr MethodInvocation1     {;}
    | %empty                                        {;};
Assignment: ID ASSIGN Expr                          {;};
ParseArgs: PARSEINT LPAR ID LSQ Expr RSQ LPAR       {;};
Expr: Expr Expr1 Expr                               {;}
    | Expr Expr2 Expr                               {;}
    | Expr Expr3 Expr                               {;}
    | Expr4 Expr                                    {;}
    | LPAR Expr RPAR                                {;}
    | MethodInvocation                              {;}
    | Assignment                                    {;}
    | ParseArgs                                     {;}
    | ID Expr5                                      {;}
    | INTLIT                                        {;}
    | REALLIT                                       {;}
    | BOOLLIT                                       {;};
Expr1: PLUS                                         {;}
    | MINUS                                         {;}
    | STAR                                          {;}
    | DIV                                           {;}
    | MOD                                           {;};
Expr2: AND                                          {;}
    | OR                                            {;}
    | XOR                                           {;}
    | LSHIFT                                        {;}
    | RSHIFT                                        {;};
Expr3: EQ                                           {;}
    | GE                                            {;}
    | GT                                            {;}
    | LE                                            {;}
    | LT                                            {;}
    | NE                                            {;};
Expr4: MINUS                                        {;}
    | NOT                                           {;}
    | PLUS                                          {;};     
Expr5: DOTLENGHT                                    {;}
    | %empty                                        {;};
%%