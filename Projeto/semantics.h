#include "structures.h"
#include "symbol_table.h"

void checkProgram(IsProgram* program);
void checkMethodField(IsMethodField* mfList);
void checkParams(TableElement* currentElement, IsParamDecl* paramList);
void checkBody(TableElement* currentElement, IsVarDeclStatement* bodyList);
