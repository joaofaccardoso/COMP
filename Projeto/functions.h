#include "structures.h"

IsProgram* insertProgram(char* id, IsMethodField* list);
IsMethodField* insertField(char* type, char* id, IsVarId* idsList);
IsMethodField* insertMethodField(IsMethodField* head, IsMethodField* new);
IsMethodField* insertMethod(IsMethodHeader* methodHeader, IsMethodBody* methodBody);
IsMethodHeader* insertMethodHeader(char* type, char* id, IsParamDecl* paramDeclList);
IsParamDecl* insertParamDecl(char* type, char* id, IsParamDecl* head);
IsVarId* insertVarId(char* id, IsVarId* head);
IsVarDeclStatement* insertVarDecl(char* type, char* id, IsVarId* idList);
IsVarDeclStatement* insertVarDeclStatement(IsVarDeclStatement* varDeclStatement, IsVarDeclStatement* head);
IsMethodBody* insertMethodBody(IsVarDeclStatement* head);
IsVarDeclStatement* insertIfStatement(IsExpr* ifExpr, IsVarDeclStatement* thenStatement, IsVarDeclStatement* elseStatement, int hasElse);
IsVarDeclStatement* insertWhileStatement(IsExpr* whileExpr, IsVarDeclStatement* whileStatement);
IsVarDeclStatement* insertReturnStatement(IsExpr* returnExpr);
IsVarDeclStatement* insertCallStatement(IsCallStatement* callStatement);
IsExpr* insertCallExpr(IsExpr* newExpr, IsExpr* head);
IsCallStatement* createCallStatement(char* id, IsExpr* newExpr, IsExpr* head);
IsVarDeclStatement* insertParseArgsStatement(IsParseArgsStatement* ipas);
IsParseArgsStatement* createParseArgsStatement(char* id, IsExpr* parseArgsExpr);
IsVarDeclStatement* insertPrintStatement(dPrint p, char* printString, IsExpr* printExpr);
