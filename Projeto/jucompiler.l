letters                 [a-zA-Z]
number                  [1-9]
number0                 [0-9]
escape                   \\[nfrt\\\"]
integer                 {number}(_*{number0}+)*
integer0                {number0}(_*{number0}+)*
exp                     (e|E)("+"|"-")?{integer0}+
reserved                float|Integer|System|null|"++"|"--"|abstract|assert|break|byte|case|catch|char|const|continue|default|do|enum|extends|final|finally|for|goto|implements|import|instanceof|interface|long|native|new|package|private|protected|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|volatile
whiteSpace              (" "|\t|\f)
%{
#include <string.h>
#include <stdio.h>
#include "structures.h"
#include "y.tab.h"

void printPoints(int count);
void printTree(); 
void printMethod(int count, IsMethodDecl* methodDecl);
void printMethodHeader(int count, IsMethodHeader* methodHeader);
void printMethodBody(int count, IsMethodBody* methodBody);
void printFieldDecl(int count, IsFieldDecl* fieldDecl);
void printStatement(IsStatement* statement, int count);
void printIfStatement(IsIfStatement* ifStatement, int count);
void printWhileStatement(IsWhileStatement* whileStatement, int count);
void printReturnStatement(IsReturnStatement* returnStatement, int count);
void printCallStatement(IsCallStatement* callStatement, int count);
void printParseArgsStatement(IsParseArgsStatement* parseArgsStatement, int count);

int line = 1;
int column = 1;
int lError = 0;
int cError = 0;
int lComment = 0;
int cComment = 0;
int lString = 0;
int cString = 0;
int string = 0;
int flag;
int first = 1;
int initCol = 1;
int isString = 0;
char * printString;
extern IsProgram* myProgram;
%}
%X COMMENT STRINGFLAG
%%
<COMMENT>"*/"                   {BEGIN 0; column+=yyleng; initCol=column;}
<COMMENT>(\n|\r|\r\n)           {column=1; initCol=column; line++;}
<COMMENT><<EOF>>                {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated comment\n",lComment,cComment); BEGIN 0;}
<COMMENT>.                      {column+=yyleng; initCol=column;}

<STRINGFLAG>\"                      {column+=yyleng; if(flag==1 && string==0) printf("STRLIT(%s)\n",printString); BEGIN 0; if(string==0){ yylval.charvalue=(char*)strdup(printString); return STRLIT;} else string=0;}
<STRINGFLAG>(\n|\r|\r\n)            {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; string=0; BEGIN 0;}
<STRINGFLAG><<EOF>>                 {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; string=0; BEGIN 0;}
<STRINGFLAG>{escape}                {column+=yyleng;}
<STRINGFLAG>\\.?                    {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: invalid escape sequence (%s)\n",line,column,yytext); column+=yyleng; string=1;}
<STRINGFLAG>(.)                     {column+=yyleng;}

\/\/([^\r\n])*                  {isString=0; ;}
{whiteSpace}                    {isString=0; column+=yyleng; initCol=column;}
(\n|\r|\r\n)                    {isString=0; column=1; initCol=1; line++;}
System"."out"."print            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("PRINT\n"); yylval.charvalue=(char*)strdup(yytext); return PRINT;}
Integer"."parseInt              {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("PARSEINT\n"); yylval.charvalue=(char*)strdup(yytext); return PARSEINT;}
"."length                       {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("DOTLENGHT\n"); yylval.charvalue=(char*)strdup(yytext); return DOTLENGHT;}
public                          {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("PUBLIC\n"); yylval.charvalue=(char*)strdup(yytext); return PUBLIC;}
return                          {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("RETURN\n"); yylval.charvalue=(char*)strdup(yytext); return RETURN;}
static                          {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("STATIC\n"); yylval.charvalue=(char*)strdup(yytext); return STATIC;}
String                          {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("STRING\n"); yylval.charvalue=(char*)strdup(yytext); return STRING;}
void                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("VOID\n"); yylval.charvalue=(char*)strdup(yytext); return VOID;}
while                           {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("WHILE\n"); yylval.charvalue=(char*)strdup(yytext); return WHILE;}
int                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("INT\n"); yylval.charvalue=(char*)strdup(yytext); return INT;}
double                          {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("DOUBLE\n"); yylval.charvalue=(char*)strdup(yytext); return DOUBLE;}
if                              {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("IF\n"); yylval.charvalue=(char*)strdup(yytext); return IF;}
else                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("ELSE\n"); yylval.charvalue=(char*)strdup(yytext); return ELSE;}
boolean                         {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("BOOL\n"); yylval.charvalue=(char*)strdup(yytext); return BOOL;}
class                           {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("CLASS\n"); yylval.charvalue=(char*)strdup(yytext); return CLASS;}
(true|false)                    {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("BOOLLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return BOOLLIT;}
==                              {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("EQ\n"); yylval.charvalue=(char*)strdup(yytext); return EQ;}
=                               {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("ASSIGN\n"); yylval.charvalue=(char*)strdup(yytext); return ASSIGN;}
","                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("COMMA\n"); yylval.charvalue=(char*)strdup(yytext); return COMMA;}
"/"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("DIV\n"); yylval.charvalue=(char*)strdup(yytext); return DIV;}
">>"                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("RSHIFT\n"); yylval.charvalue=(char*)strdup(yytext); return RSHIFT;}
"<<"                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("LSHIFT\n"); yylval.charvalue=(char*)strdup(yytext); return LSHIFT;}
"^"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("XOR\n"); yylval.charvalue=(char*)strdup(yytext); return XOR;}
">="                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("GE\n"); yylval.charvalue=(char*)strdup(yytext); return GE;}
">"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("GT\n"); yylval.charvalue=(char*)strdup(yytext); return GT;}
"<="                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("LE\n"); yylval.charvalue=(char*)strdup(yytext); return LE;}
"<"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("LT\n"); yylval.charvalue=(char*)strdup(yytext); return LT;}
"-"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("MINUS\n"); yylval.charvalue=(char*)strdup(yytext); return MINUS;}
"%"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("MOD\n"); yylval.charvalue=(char*)strdup(yytext); return MOD;}
"!="                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("NE\n"); yylval.charvalue=(char*)strdup(yytext); return NE;}
"!"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("NOT\n"); yylval.charvalue=(char*)strdup(yytext); return NOT;}
"||"                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("OR\n"); yylval.charvalue=(char*)strdup(yytext); return OR;}
"+"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("PLUS\n"); yylval.charvalue=(char*)strdup(yytext); return PLUS;}
";"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("SEMICOLON\n"); yylval.charvalue=(char*)strdup(yytext); return SEMICOLON;}
"*"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("STAR\n"); yylval.charvalue=(char*)strdup(yytext); return STAR;}
"->"                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("ARROW\n"); yylval.charvalue=(char*)strdup(yytext); return ARROW;}
"&&"                            {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("AND\n"); yylval.charvalue=(char*)strdup(yytext); return AND;}
"{"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("LBRACE\n"); yylval.charvalue=(char*)strdup(yytext); return LBRACE;}
"}"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("RBRACE\n"); yylval.charvalue=(char*)strdup(yytext); return RBRACE;}
"("                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("LPAR\n"); yylval.charvalue=(char*)strdup(yytext); return LPAR;}
")"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("RPAR\n"); yylval.charvalue=(char*)strdup(yytext); return RPAR;}
"["                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("LSQ\n"); yylval.charvalue=(char*)strdup(yytext); return LSQ;}
"]"                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("RSQ\n"); yylval.charvalue=(char*)strdup(yytext); return RSQ;}
{reserved}                      {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("RESERVED(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return RESERVED;}
\"                              {BEGIN (STRINGFLAG); lString=line; cString=column; isString = 1; printString = yytext; initCol=column; column+=yyleng;}
"/*"                            {isString=0; lComment = line; cComment = column; BEGIN (COMMENT); column+=yyleng; initCol=column;}
("_"|"$"|{letters})("_"|"$"|{letters}|{number0})*           {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("ID(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return ID;}
(0|{integer})                                               {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("INTLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return INTLIT;}
{integer0}"."{integer0}?{exp}?                              {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}
"."{integer0}{exp}?                                         {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}
{integer0}{exp}                                             {isString=0; initCol=column; column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}


(.)                             {if (flag == 1 || flag == 2 || flag == 0) printf("Line %d, col %d: illegal character (%s)\n",line,column,yytext); column+=yyleng; initCol=column;}
%%


int yywrap(){
    return 1;
}

void yyerror (const char *s) {
    if (flag == 0) {
        if(isString == 0){
            printf ("Line %d, col %d: %s: %s\n", line, initCol, s, yytext);
        }
        else{
            printf ("Line %d, col %d: %s: %s\n", line, initCol, s, printString);
        }
    }
}

void printPoints(int count) {
    for (int i=0; i<count; i++) {
        printf(".");
    }
}

void printTree() {
    int count = 0;
    if (myProgram!=NULL) {
        printf("Program\n..Id(%s)\n", myProgram->id);
        count += 2;
        IsMethodField* mfIterator = myProgram->methodFieldList;
        while(mfIterator!=NULL) {
            if (mfIterator->mf == isMethod) {
                printMethod(count, mfIterator->mfType.methodDecl);
            } else {
                printFieldDecl(count, mfIterator->mfType.fieldDecl);
            }
            mfIterator = mfIterator->next;
        }
    }
}

void printMethod(int count, IsMethodDecl* methodDecl) {
    printPoints(count);
    printf("MethodDecl\n");
    count += 2;
    if(methodDecl->methodHeader!=NULL){
        printMethodHeader(count, methodDecl->methodHeader);
        printMethodBody(count, methodDecl->methodBody);
    }
}

void printFieldDecl(int count, IsFieldDecl* fieldDecl) {
    printPoints(count);
    printf("FieldDecl\n");
    count += 2;
    
    printPoints(count);
    printf("%s\n",fieldDecl->type);

    printPoints(count);
    printf("Id(%s)\n",fieldDecl->id);    
}

void printMethodHeader(int count, IsMethodHeader* methodHeader){
    printPoints(count);
    printf("MethodHeader\n");
    count += 2;
    printPoints(count);
    printf("%s\n",methodHeader->type);
    printPoints(count);
    printf("Id(%s)\n",methodHeader->id);
    printPoints(count);
    printf("MethodParams\n");
    if(methodHeader->paramDeclList != NULL){
        IsParamDecl* paramDeclIt = methodHeader->paramDeclList;
        count += 2;
        while(paramDeclIt != NULL){
            printPoints(count);
            printf("ParamDecl\n");

            printPoints(count+2);
            printf("%s\n",paramDeclIt->type);
            
            printPoints(count+2);
            printf("Id(%s)\n",paramDeclIt->id);
            
            paramDeclIt = paramDeclIt->next;
        }
    }
}

void printMethodBody(int count, IsMethodBody* methodBody){
    printPoints(count);
    printf("MethodBody\n");
    count += 2;

    IsVarDeclStatement* ivdsIterator = methodBody->vardDeclSatetmentList;
    while(ivdsIterator){
        if(ivdsIterator->vds == varDecl){
            printPoints(count);
            printf("VarDecl\n");

            printPoints(count+2);
            printf("%s\n",ivdsIterator->vdsType.varDecl->type);

            printPoints(count+2);
            printf("Id(%s)\n",ivdsIterator->vdsType.varDecl->id);
        }
        else{
            printStatement(ivdsIterator->vdsType.statement, count);
        }

        ivdsIterator = ivdsIterator->next;
    }
}

void printStatement(IsStatement* statement, int count){
    if(statement->sm == sIf){
        printIfStatement(statement->smType.ifStatement, count);
    }
    else if(statement->sm == sWhile){
        printWhileStatement(statement->smType.whileStatement, count);
    }
    else if(statement->sm == sReturn){
        printReturnStatement(statement->smType.returnStatement, count);
    }
    else if(statement->sm == sCall){
        printCallStatement(statement->smType.callStatement, count);
    }
    else if(statement->sm == sParseArgs) {
        printParseArgsStatement(statement->smType.parseArgsStatement, count);
    }
}

void printIfStatement(IsIfStatement* ifStatement, int count){
    int newCount;
    
    printPoints(count);
    printf("If\n");
    count += 2;
    newCount = count;

    printPoints(count);
    printf("Expr\n");
    //Expr

    IsVarDeclStatement* ivdsIterator;
    
    ivdsIterator = ifStatement->thenStatement;
    if(ivdsIterator==NULL || ivdsIterator->next){
        printPoints(count);
        printf("Block\n");
    }
        newCount = count+2;
    while(ivdsIterator){
        printStatement(ivdsIterator->vdsType.statement, newCount);
        ivdsIterator = ivdsIterator->next;
    }

    if(ifStatement->hasElse){
        ivdsIterator = ifStatement->elseStatement;
        if(ivdsIterator==NULL || ivdsIterator->next){
            printPoints(count);
            printf("Block\n");
            newCount = count+2;
        }
        while(ivdsIterator){
            printStatement(ivdsIterator->vdsType.statement, newCount);
            ivdsIterator = ivdsIterator->next;
        }
    }
}

void printWhileStatement(IsWhileStatement* whileStatement, int count){
    int newCount;
    
    printPoints(count);
    printf("While\n");
    count += 2;
    newCount = count;

    printPoints(count);
    printf("Expr\n");
    //Expr

    IsVarDeclStatement* ivdsIterator;
    
    ivdsIterator = whileStatement->whileStatement;
    if(ivdsIterator==NULL || ivdsIterator->next){
        printPoints(count);
        printf("Block\n");
        newCount = count+2;
    }
    while(ivdsIterator){
        printStatement(ivdsIterator->vdsType.statement, newCount);
        ivdsIterator = ivdsIterator->next;
    }
}

void printReturnStatement(IsReturnStatement* returnStatement, int count){
    printPoints(count);
    printf("Return\n");
    count+=2;

    if(returnStatement->returnExpr){
        printPoints(count);
        printf("Expr\n");
        //print Expr quando for feito
    }
}

void printCallStatement(IsCallStatement* callStatement, int count){
    printPoints(count);
    printf("Call\n");
    count+=2;

    printPoints(count);
    printf("Id(%s)\n",callStatement->id);

    if(callStatement->callExpr){
        printPoints(count);
        printf("Expr\n");
    }
}

void printParseArgsStatement(IsParseArgsStatement* parseArgsStatement, int count) {
    printPoints(count);
    printf("ParseArgs\n");
    count+=2;

    printPoints(count);
    printf("Id(%s)\n", parseArgsStatement->id);

    if(parseArgsStatement->parseArgsExpr) {
        printPoints(count);
        printf("Expr\n");
    }
}

int main(int argc, char *argv[]){
    int x;
    if(argc > 1){
        if(strcmp(argv[1],"-l")==0){
            flag = 1;
            x = -1;
            while(x!=0){
                x = yylex();
            }
        }
        else if(strcmp(argv[1],"-e1")==0){
            flag = 2;
            x = -1;
            while(x!=0){
                x = yylex();
            }
        }
        else if(strcmp(argv[1],"-t")==0){
            flag = 3;
            yyparse();
            printTree();
        }
        else if(strcmp(argv[1],"-e2")==0){
            flag = 0;
            yyparse();
        }
        else{
            yyparse();
        }
    }
    else{
        flag = 0;
        yyparse();
    }
    
    return 0;
}
