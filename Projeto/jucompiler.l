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
/*
*   authors:
*       - João Francisco Albuquerque de Campos Cardoso - nº 2017247458
*       - Maria Leonor Inês Coelho - nº 2017254568
*/
#include <string.h>
#include <stdio.h>
#include "structures.h"
#include "symbol_table.h"
#include "semantics.h"
#include "y.tab.h"

void printPoints(int count);
void printTree(); 
void printMethod(int count, IsMethodDecl* methodDecl, TableElement* methodTable);
void printMethodHeader(int count, IsMethodHeader* methodHeader);
void printMethodBody(int count, IsMethodBody* methodBody, TableElement* methodTable);
void printFieldDecl(int count, IsFieldDecl* fieldDecl);
void printStatement(IsStatement* statement, int count, TableElement* methodTable);
void printIfStatement(IsIfStatement* ifStatement, int count, TableElement* methodTable);
void printWhileStatement(IsWhileStatement* whileStatement, int count, TableElement* methodTable);
void printReturnStatement(IsReturnStatement* returnStatement, int count, TableElement* methodTable);
void printCallStatement(IsCallStatement* callStatement, int count, TableElement* methodTable);
void printParseArgsStatement(IsParseArgsStatement* parseArgsStatement, int count, TableElement* methodTable);
void printPrintStatement(IsPrintStatement* ips, int count, TableElement* methodTable);
void printAssign(IsAssign* assignStatement, int count, TableElement* methodTable);
void printBlockStatement(IsVarDeclStatement* blockHead, int count, TableElement* methodTable);
void printExpression(IsExpr* expression, int count, TableElement* methodTable);
void printOp(IsOp* operation, int count, TableElement* methodTable);
void printTerminal(IsTerminal* terminal, int count, TableElement* methodTable);
void printUnit(IsUnit* unit, int count, TableElement* methodTable);

void printTable();
void printMethodFieldTable(TableElement* tableElement);
void printMethodParamsBodyTable(MethodElement* elements);

void cleanTree();
void cleanMethodFieldList(IsMethodField* temp);
void cleanMethod(IsMethodDecl* temp);
void cleanHeader(IsMethodHeader* temp);
void cleanParams(IsParamDecl* temp);
void cleanBody(IsMethodBody* temp);
void cleanVarDeclList(IsVarDeclStatement* temp);
void cleanStatement(IsStatement* temp);
void cleanIf(IsIfStatement* temp);
void cleanWhile(IsWhileStatement* temp);
void cleanReturn(IsReturnStatement* temp);
void cleanCall(IsCallStatement* temp);
void cleanParseArgs(IsParseArgsStatement* temp);
void cleanPrint(IsPrintStatement* temp);
void cleanAssign(IsAssign* temp);
void cleanExpr(IsExpr* temp);
void cleanOp(IsOp* temp);
void cleanUnit(IsUnit* temp);

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
int error = 0;
TableHead* symHead = NULL;
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
    error = 1;
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
    TableElement* mfTableElement = symHead->table;
    if (myProgram!=NULL) {
        printf("Program\n..Id(%s)\n", myProgram->id->value);
        count += 2;
        IsMethodField* mfIterator = myProgram->methodFieldList;
        while(mfIterator!=NULL) {
            if (mfIterator->mf == isMethod) {
                printMethod(count, mfIterator->mfType.methodDecl, mfTableElement);
            } else {
                printFieldDecl(count, mfIterator->mfType.fieldDecl);
            }
            mfIterator = mfIterator->next;
            mfTableElement = mfTableElement->next;
        }
    }
}

void printMethod(int count, IsMethodDecl* methodDecl, TableElement* methodTable) {
    printPoints(count);
    printf("MethodDecl\n");
    count += 2;
    if(methodDecl->methodHeader!=NULL){
        printMethodHeader(count, methodDecl->methodHeader);
        printMethodBody(count, methodDecl->methodBody, methodTable);
    }
}

void printFieldDecl(int count, IsFieldDecl* fieldDecl) {
    printPoints(count);
    printf("FieldDecl\n");
    count += 2;
    
    printPoints(count);
    printf("%s\n",fieldDecl->type->value);

    printPoints(count);
    printf("Id(%s)\n",fieldDecl->id->value); 
}

void printMethodHeader(int count, IsMethodHeader* methodHeader){
    printPoints(count);
    printf("MethodHeader\n");
    count += 2;
    printPoints(count);
    printf("%s\n",methodHeader->type->value);
    printPoints(count);
    printf("Id(%s)\n",methodHeader->id->value);
    printPoints(count);
    printf("MethodParams\n");
    if(methodHeader->paramDeclList != NULL){
        IsParamDecl* paramDeclIt = methodHeader->paramDeclList;
        count += 2;
        while(paramDeclIt != NULL){
            printPoints(count);
            printf("ParamDecl\n");

            printPoints(count+2);
            printf("%s\n",paramDeclIt->type->value);
            
            printPoints(count+2);
            printf("Id(%s)\n",paramDeclIt->id->value);
            
            paramDeclIt = paramDeclIt->next;
        }
    }
}

void printMethodBody(int count, IsMethodBody* methodBody, TableElement* methodTable){
    printPoints(count);
    printf("MethodBody\n");
    count += 2;

    IsVarDeclStatement* ivdsIterator = methodBody->vardDeclSatetmentList;
    while(ivdsIterator){
        if(ivdsIterator->vds == varDecl){
            printPoints(count);
            printf("VarDecl\n");

            printPoints(count+2);
            printf("%s\n",ivdsIterator->vdsType.varDecl->type->value);

            printPoints(count+2);
            printf("Id(%s)\n",ivdsIterator->vdsType.varDecl->id->value);
        }
        else{
            printStatement(ivdsIterator->vdsType.statement, count, methodTable);
        }

        ivdsIterator = ivdsIterator->next;
    }
}

void printStatement(IsStatement* statement, int count, TableElement* methodTable){
    if (statement->sm == sBlock) {
        printBlockStatement(statement->smType.blockStatement, count, methodTable);
    }
    else if(statement->sm == sIf){
        printIfStatement(statement->smType.ifStatement, count, methodTable);
    }
    else if(statement->sm == sWhile){
        printWhileStatement(statement->smType.whileStatement, count, methodTable);
    }
    else if(statement->sm == sReturn){
        printReturnStatement(statement->smType.returnStatement, count, methodTable);
    }
    else if(statement->sm == sCall){
        printCallStatement(statement->smType.callStatement, count, methodTable);
    }
    else if(statement->sm == sParseArgs) {
        printParseArgsStatement(statement->smType.parseArgsStatement, count, methodTable);
    }
    else if(statement->sm == sPrint) {
        printPrintStatement(statement->smType.printStatement, count, methodTable);
    }
    else if(statement->sm == sAssign) {
        printAssign(statement->smType.assignStatement, count, methodTable);
    }
}

void printBlockStatement(IsVarDeclStatement* blockHead, int count, TableElement* methodTable) {
    IsVarDeclStatement* blockIterator = blockHead;
    
    printPoints(count);
    printf("Block\n");
    count+=2;
    
    while(blockIterator) {
        printStatement(blockIterator->vdsType.statement, count, methodTable);
        blockIterator = blockIterator->next;
    }
}

void printIfStatement(IsIfStatement* ifStatement, int count, TableElement* methodTable){
    printPoints(count);
    printf("If\n");
    count += 2;

    printExpression(ifStatement->ifExpr,count, methodTable);

    IsVarDeclStatement* ivdsIterator;
    
    ivdsIterator = ifStatement->thenBlock;
    if(ivdsIterator==NULL){
        printPoints(count);
        printf("Block\n");
    }
    else {
        printStatement(ivdsIterator->vdsType.statement, count, methodTable);
    }

    if(ifStatement->hasElse){
        ivdsIterator = ifStatement->elseBlock;
        if(ivdsIterator==NULL){
            printPoints(count);
            printf("Block\n");
        }
        else {
            printStatement(ivdsIterator->vdsType.statement, count, methodTable);
        }
    }
    else {
        printPoints(count);
        printf("Block\n");
    }

}

void printWhileStatement(IsWhileStatement* whileStatement, int count, TableElement* methodTable){
    printPoints(count);
    printf("While\n");
    count += 2;

    printExpression(whileStatement->whileExpr,count, methodTable);


    IsVarDeclStatement* ivdsIterator;
    
    ivdsIterator = whileStatement->whileStatement;
    if(ivdsIterator==NULL){
        printPoints(count);
        printf("Block\n");
    }
    else {
        printStatement(ivdsIterator->vdsType.statement, count, methodTable);
    }
}

void printReturnStatement(IsReturnStatement* returnStatement, int count, TableElement* methodTable){
    printPoints(count);
    printf("Return\n");
    count+=2;

    if(returnStatement->returnExpr){
        printExpression(returnStatement->returnExpr, count, methodTable);
    }
}

void printCallStatement(IsCallStatement* callStatement, int count, TableElement* methodTable){
    printPoints(count);
    TableElement* el = findMethodTable(callStatement->id->value, callStatement->callExpr, callStatement->line, callStatement->col, methodTable);

    printf("Call");
    
    if(flag == 3){
        printf(" - %s", callStatement->returnType);
    }

    printf("\n");
    count+=2;

    printPoints(count);
    printf("Id(%s)",callStatement->id->value);

    if(flag == 3){
        if(el){
            printf(" - (");
            MethodElement* paramsList = el->elements;
            if(paramsList && paramsList->meth_type == param){
                printf("%s",paramsList->type);
                int count = 1;
                for(paramsList=paramsList->next;paramsList;paramsList=paramsList->next, count++){
                    int check = checkOtherParam(paramsList,el,count);
                    if(check == 0){
                        printf(",%s",paramsList->type);
                    }
                }
            }
            printf(")");
        }
        else{
            printf(" - undef");
        }
    }

    printf("\n");

    IsExpr* iterator = callStatement->callExpr;
    while(iterator){
        printExpression(iterator, count, methodTable);
        iterator = iterator->next;
    }
}

void printParseArgsStatement(IsParseArgsStatement* parseArgsStatement, int count, TableElement* methodTable) {
    printPoints(count);
    printf("ParseArgs");
    if (flag == 3) {
        printf(" - %s", parseArgsStatement->returnType);
    }
    printf("\n");
    count+=2;

    printPoints(count);
    printf("Id(%s)", parseArgsStatement->id->value);

    if (flag == 3) {
        printf(" - %s", parseArgsStatement->id->returnType);
    }

    printf("\n");

    if(parseArgsStatement->parseArgsExpr) {
        printExpression(parseArgsStatement->parseArgsExpr, count, methodTable);
    }
}

void printPrintStatement(IsPrintStatement* ips, int count, TableElement* methodTable) {
    printPoints(count);
    printf("Print\n");
    count+=2;

    if (ips->p == stringLiteral) {
        printPoints(count);
        printf("StrLit(%s)", ips->pType.printString);

        if(flag == 3){
            printf(" - %s", ips->returnType);
        }

        printf("\n");
    }
    else {
        printExpression(ips->pType.printExpr, count, methodTable);
    }
}

void printAssign(IsAssign* assignStatement, int count, TableElement* methodTable) {
    printPoints(count);
    printf("Assign");
    if (flag == 3) {
        printf(" - %s", assignStatement->returnType);
    }
    printf("\n");
    count+=2;

    printPoints(count);
    printf("Id(%s)", assignStatement->id->value);
    if (flag == 3) {
        printf(" - %s",assignStatement->id->returnType);
    }
    printf("\n");

    printExpression(assignStatement->assignExpr, count, methodTable);
}

void printExpression(IsExpr* expression, int count, TableElement* methodTable) {
    if (expression->e == eAssign) {
        printAssign(expression->eType.exprAssign, count, methodTable);
    }
    else if (expression->e == eOp) {
        printOp(expression->eType.exprOp,count, methodTable);
    }
    else if (expression->e == eCall) {
        printCallStatement(expression->eType.exprCall,count, methodTable);
    }
    else if (expression->e == eParseArgs) {
        printParseArgsStatement(expression->eType.exprParseArgs,count, methodTable);
    }
    else if (expression->e == eTerminal) {
        printTerminal(expression->eType.exprTerminal,count, methodTable);
    }
    else if (expression->e   == eUnit) {
        printUnit(expression->eType.exprUnit,count, methodTable);
    }
}

void printOp(IsOp* operation, int count, TableElement* methodTable) {
    printPoints(count);
    printf("%s",operation->op);

    if(flag == 3 && strcmp(operation->op,"Lshift") != 0 && strcmp(operation->op,"Rshift") != 0 && strcmp(operation->op,"Xor") != 0){
        printf(" - %s", operation->returnType);
    }

    printf("\n");
    count+=2;
    
    printExpression(operation->opExprLeft,count, methodTable);
    printExpression(operation->opExprRight,count, methodTable);
}

void printTerminal(IsTerminal* terminal, int count, TableElement* methodTable) {
    printPoints(count);
    printf("%s(%s)", terminal->type, terminal->value);
    if (flag == 3) {
        printf(" - %s", terminal->returnType);
    }
    printf("\n");
}

void printUnit(IsUnit* unit, int count, TableElement* methodTable) {
    printPoints(count);
    printf("%s", unit->op);

    if(flag == 3){
        printf(" - %s",unit->returnType);
    }
    printf("\n");
    count+=2;

    printExpression(unit->unitExpr, count, methodTable);
}

void printTable(){
    printf("===== Class %s Symbol Table =====\n",symHead->id);

    TableElement* tableElement = symHead->table;

    for(;tableElement;tableElement=tableElement->next){
        while(tableElement && tableElement->print == 0){
            tableElement=tableElement->next;
        }
        if(!tableElement){
            break;
        }
        if(tableElement->elem_type == var_decl){
            printf("%s\t\t%s\n",tableElement->id,tableElement->type);
        }
        else{
            printf("%s\t(",tableElement->id);

            if(tableElement->elements != NULL && tableElement->elements->meth_type == param){
                printf("%s",tableElement->elements->type);
                MethodElement* aux = tableElement->elements->next;
                for(;aux && aux->meth_type==param;aux=aux->next){
                    printf(",%s",aux->type);
                }
            }
            printf(")\t%s\n",tableElement->type);
        }

    }

    printMethodFieldTable(symHead->table);
}

void printMethodFieldTable(TableElement* tableElement){
    for(;tableElement;tableElement=tableElement->next){
        if(tableElement->elem_type == method_decl){
            printf("\n===== Method %s(",tableElement->id);
            if(tableElement->elements != NULL && tableElement->elements->meth_type == param){
                printf("%s",tableElement->elements->type);
                MethodElement* aux = tableElement->elements->next;
                for(;aux && aux->meth_type==param;aux=aux->next){
                    printf(",%s",aux->type);
                }
            }
            printf(") Symbol Table =====\nreturn\t\t%s\n",tableElement->type);
            
            printMethodParamsBodyTable(tableElement->elements);

        }
    }
}

void printMethodParamsBodyTable(MethodElement* elements){
    for(;elements;elements=elements->next){
        if(elements->meth_type == param && elements->print == 1){
            printf("%s\t\t%s\tparam\n",elements->id,elements->type);
        }
        else if(elements->print == 1){
            printf("%s\t\t%s\n",elements->id,elements->type);
        }
    }
}

void cleanTree() {
    if(myProgram == NULL){
        return;
    }

    cleanMethodFieldList(myProgram->methodFieldList);

    free(myProgram);
}

void cleanMethodFieldList(IsMethodField* temp) {
    if(temp==NULL){
        return;
    }
    if(temp->mf == isMethod){
        cleanMethod(temp->mfType.methodDecl);
    }
    else{
        if(temp->mfType.fieldDecl){
            free(temp->mfType.fieldDecl);
        }
    }
    cleanMethodFieldList(temp->next);
    free(temp);
}

void cleanMethod(IsMethodDecl* temp) {
    if(temp == NULL){
        return;
    }
    
    cleanHeader(temp->methodHeader);

    cleanBody(temp->methodBody);
    
    free(temp);
}

void cleanHeader(IsMethodHeader* temp) {
    if(temp == NULL){
        return;
    }
    
    cleanParams(temp->paramDeclList);
    
    free(temp);
}

void cleanParams(IsParamDecl* temp) {
    if(temp == NULL){
        return;
    }

    cleanParams(temp->next);

    free(temp);
}

void cleanBody(IsMethodBody* temp) {
    if(temp == NULL){
        return;
    }

    cleanVarDeclList(temp->vardDeclSatetmentList);
    
    free(temp);
}

void cleanVarDeclList(IsVarDeclStatement* temp) {
    if(temp == NULL){
        return;
    }

    if (temp->vds == statement){
        cleanStatement(temp->vdsType.statement);
    }
    else{
        if(temp->vdsType.varDecl){
            free(temp->vdsType.varDecl);
        }
    }

    cleanVarDeclList(temp->next);

    free(temp);
}

void cleanStatement(IsStatement* temp) {
    if(temp == NULL){
        return;
    }

    if (temp->sm == sBlock) {
        cleanVarDeclList(temp->smType.blockStatement);
    }
    else if(temp->sm == sIf){
        cleanIf(temp->smType.ifStatement);
    }
    else if(temp->sm == sWhile){
        cleanWhile(temp->smType.whileStatement);
    }
    else if(temp->sm == sReturn){
        cleanReturn(temp->smType.returnStatement);
    }
    else if(temp->sm == sCall){
        cleanCall(temp->smType.callStatement);
    }
    else if(temp->sm == sParseArgs) {
        cleanParseArgs(temp->smType.parseArgsStatement);
    }
    else if(temp->sm == sPrint) {
        cleanPrint(temp->smType.printStatement);
    }
    else if(temp->sm == sAssign) {
        cleanAssign(temp->smType.assignStatement);
    }

    free(temp);
}

void cleanIf(IsIfStatement* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->ifExpr);
    
    cleanVarDeclList(temp->thenBlock);
    
    cleanVarDeclList(temp->elseBlock);
    
    free(temp);
}

void cleanWhile(IsWhileStatement* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->whileExpr);
        
    cleanVarDeclList(temp->whileStatement);
    
    free(temp);
}

void cleanReturn(IsReturnStatement* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->returnExpr);
    
    free(temp);
}

void cleanCall(IsCallStatement* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->callExpr);

    free(temp);
}

void cleanParseArgs(IsParseArgsStatement* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->parseArgsExpr);
    
    free(temp);
}

void cleanPrint(IsPrintStatement* temp) {
    if(temp == NULL){
        return;
    }
    if(temp->p == expression){
        cleanExpr(temp->pType.printExpr);
    }
    else if(temp->pType.printString){
        free(temp->pType.printString);   
    }

    free(temp);
}

void cleanAssign(IsAssign* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->assignExpr);
    
    free(temp);
}

void cleanExpr(IsExpr* temp) {
    if(temp == NULL){
        return;
    }

    if (temp->e == eAssign) {
        cleanAssign(temp->eType.exprAssign);
    }
    else if (temp->e == eOp) {
        cleanOp(temp->eType.exprOp);
    }
    else if (temp->e == eCall) {
        cleanCall(temp->eType.exprCall);
    }
    else if (temp->e == eParseArgs) {
        cleanParseArgs(temp->eType.exprParseArgs);
    }
    else if (temp->e == eTerminal) {
        if(temp->eType.exprTerminal){
            free(temp->eType.exprTerminal);
        }
    }
    else if (temp->e == eUnit) {
        cleanUnit(temp->eType.exprUnit);
    }

    cleanExpr(temp->next);
    
    free(temp);
}

void cleanOp(IsOp* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->opExprLeft);

    cleanExpr(temp->opExprRight);

    free(temp);
}

void cleanUnit(IsUnit* temp) {
    if(temp == NULL){
        return;
    }

    cleanExpr(temp->unitExpr);
    
    free(temp);
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
            flag = 0;
            yyparse();
            if(error == 0){
                printTree();
            }
        }
        else if(strcmp(argv[1],"-e2")==0){
            flag = 0;
            yyparse();
        }
        else if(strcmp(argv[1],"-s")==0){
            flag = 3;
            yyparse();
            checkProgram(myProgram);
            insertTypes(myProgram);
            printTable();
            printf("\n");
            printTree();
        }
        else{
            yyparse();
        }
    }
    else{
        flag = 0;
        yyparse();
    }
    
    if (myProgram)
        cleanTree();
    return 0;
}
