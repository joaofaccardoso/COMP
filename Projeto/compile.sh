lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c functions.c semantics.c symbol_table.c
# ./jucompiler -s < Testes/Meta3/testsMethods.java
./jucompiler -s < Testes/Meta3/Operators2.java > out.out
./jucompiler -s < Testes/Meta3/Operators2.java | diff Testes/Meta3/Operators2.out -

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