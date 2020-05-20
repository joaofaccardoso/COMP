#include "structures.h"
#include "symbol_table.h"

void checkProgram(IsProgram* program);
void checkMethodField(IsMethodField* mfList);
int checkOtherMethod(TableElement* el, int count);
void checkParams(TableElement* currentElement, IsParamDecl* paramList);
void checkBody(TableElement* currentElement, IsVarDeclStatement* bodyList);
void insertTypes(IsProgram* program);
void insertVarStatementType(IsVarDeclStatement* varStatement,  IsMethodDecl* method, TableElement* tableElement);
void insertStatementType(IsStatement* statement,  IsMethodDecl* method, TableElement* tableElement);
void insertIfType(IsIfStatement* ifStatement, IsMethodDecl* method, TableElement* tableElement);
void insertWhileType(IsWhileStatement* whileStatement, IsMethodDecl* method, TableElement* tableElement);
void insertReturnType(IsReturnStatement* returnStatement, IsMethodDecl* method, TableElement* TableElement);
void insertCallType(IsCallStatement* call,  IsMethodDecl* method, TableElement* tableElement);
void insertPrintType(IsPrintStatement* print,  IsMethodDecl* method, TableElement* tableElement);
int checkFunctionType(char* id, MethodElement* methodElement, IsExpr* paramsList, TableElement* currentElement, TableElement* tableElement, int closest);
int isClosestFunction(char* id, TableElement* tableIt, IsExpr* paramsElement, TableElement* tableElement);
int checkParamsDecl(IsVarDecl* var, IsMethodDecl* method, TableElement* tableElement);
int checkOtherParam(MethodElement* param, TableElement* el, int count);
void insertParseArgsType(IsParseArgsStatement* parseArgs,  IsMethodDecl* method, TableElement* tableElement);
void insertAssignType(IsAssign* assign,  IsMethodDecl* method, TableElement* tableElement);
void insertExprType(IsExpr* expr,  IsMethodDecl* method, TableElement* tableElement);
void insertOpType(IsOp* operation,  IsMethodDecl* method, TableElement* tableElement);
void insertTerminalType(IsTerminal* terminal,  IsMethodDecl* method, TableElement* tableElement);
void insertUnitType(IsUnit* unit,  IsMethodDecl* method, TableElement* tableElement);
char* getIdType(char* id, int line, int col,  IsMethodDecl* method, TableElement* tableElement);
int checkParameters(MethodElement* elements, IsExpr* params);
char* removeUnderscore(char* value);