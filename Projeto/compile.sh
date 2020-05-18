lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c functions.c semantics.c symbol_table.c
# ./jucompiler -s < Testes/Meta3/testeProblemaE.java
./jucompiler -s < Testes/Meta3/testeProblemaE.java > out.out
./jucompiler -s < Testes/Meta3/testeProblemaE.java | diff Testes/Meta3/testeProblemaE.out -

# | diff Testes/Meta2/fielddecl.out -

# AindaSemErros
# AlgunsErros
# Call_me_maybe
# declarationErrors
# divide
# Factorial
# FieldDecErrors
# MethodInvocation
# MultipleArguments
# Operators
# Operators2
# Operators3
# testeProblemaE
# TestesGeral
#testsMethods