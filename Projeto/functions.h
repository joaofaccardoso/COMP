#include "structures.h"

IsProgram* insertProgram(char* id, IsMethodField* list, int line, int col);
IsMethodField* insertField(char* type, char* id, IsVarId* idsList, int line, int col);
IsMethodField* insertMethodField(IsMethodField* head, IsMethodField* new);
IsMethodField* insertMethod(IsMethodHeader* methodHeader, IsMethodBody* methodBody, int line, int col);
IsMethodHeader* insertMethodHeader(char* type, char* id, IsParamDecl* paramDeclList, int line, int col);
IsParamDecl* insertParamDecl(char* type, char* id, IsParamDecl* head, int line, int col);
IsVarId* insertVarId(char* id, IsVarId* head, int line, int col);
IsVarDeclStatement* insertVarDecl(char* type, char* id, IsVarId* idList, int line, int col);
IsVarDeclStatement* insertVarDeclStatement(IsVarDeclStatement* varDeclStatement, IsVarDeclStatement* head);
IsMethodBody* insertMethodBody(IsVarDeclStatement* head, int line, int col);
IsVarDeclStatement* insertIfStatement(IsExpr* ifExpr, IsVarDeclStatement* thenStatement, IsVarDeclStatement* elseStatement, int hasElse, int line, int col);
IsVarDeclStatement* insertWhileStatement(IsExpr* whileExpr, IsVarDeclStatement* whileStatement, int line, int col);
IsVarDeclStatement* insertReturnStatement(IsExpr* returnExpr, int line, int col);
IsVarDeclStatement* insertCallStatement(IsCallStatement* callStatement, int line, int col);
IsExpr* insertCallExpr(IsExpr* newExpr, IsExpr* head);
IsCallStatement* createCallStatement(char* id, IsExpr* newExpr, IsExpr* head, int line, int col);
IsVarDeclStatement* insertParseArgsStatement(IsParseArgsStatement* ipas);
IsParseArgsStatement* createParseArgsStatement(char* id, IsExpr* parseArgsExpr, int line, int col);
IsVarDeclStatement* insertPrintStatement(dPrint p, char* printString, IsExpr* printExpr, int line, int col);
IsVarDeclStatement* insertAssignStatement(IsAssign* assignStatement);
IsAssign* createAssign(char* id, IsExpr* assignExpr, int line, int col);
IsVarDeclStatement* insertBlockStatement(IsVarDeclStatement* statementList, int line, int col);
IsVarDeclStatement* createBlockStatement(IsVarDeclStatement* newStatement, IsVarDeclStatement* head);
IsExpr* insertAssignExpr(IsAssign* assignExpr);
IsExpr* insertOp(IsExpr* opExprLeft, char* op, IsExpr* opExprRight, int line, int col);
IsExpr* insertUnit(char* op, IsExpr* unitExpr, char* id, int line, int col);
IsExpr* insertExprCall(IsCallStatement* ics);
IsExpr* insertExprParseArgs(IsParseArgsStatement* ipas);
IsExpr* insertTerminal(char* type, char* value, int line, int col);
