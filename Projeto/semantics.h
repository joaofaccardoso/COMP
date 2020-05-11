#include "structures.h"
#include "symbol_table.h"

void checkProgram(IsProgram* program);
void checkMethodField(IsMethodField* mfList);
int checkOtherMethod(TableElement* el, int count);
void checkParams(TableElement* currentElement, IsParamDecl* paramList);
void checkBody(TableElement* currentElement, IsVarDeclStatement* bodyList);
void insertTypes(IsProgram* program);
void insertVarStatementType(IsVarDeclStatement* varStatement, TableElement* tableElement);
void insertStatementType(IsStatement* statement, TableElement* tableElement);
void insertCallType(IsCallStatement* call, TableElement* tableElement);
void insertPrintType(IsPrintStatement* print, TableElement* tableElement);
int checkFunctionType(char* id, MethodElement* methodElement, IsExpr* paramsList, TableElement* currentElement, TableElement* tableElement, int closest);
int isClosestFunction(char* id, TableElement* tableIt, IsExpr* paramsElement, TableElement* tableElement);
int checkOtherParam(MethodElement* param, TableElement* el, int count);
void insertParseArgsType(IsParseArgsStatement* parseArgs, TableElement* tableElement);
void insertAssignType(IsAssign* assign, TableElement* tableElement);
void insertExprType(IsExpr* expr, TableElement* tableElement);
void insertOpType(IsOp* operation, TableElement* tableElement);
void insertTerminalType(IsTerminal* terminal, TableElement* tableElement);
void insertUnitType(IsUnit* unit, TableElement* tableElement);
char* getIdType(char* id, int line, int col, TableElement* tableElement);
