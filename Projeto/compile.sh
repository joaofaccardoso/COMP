lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc *.c -o jucompiler

./jucompiler -t < Testes/Meta3/teste.java
# ./jucompiler < Testes/Meta3/NoFlags.java > out.out

# ./jucompiler -s < Testes/Meta3/AindaSemErros.java | diff Testes/Meta3/AindaSemErros.out -
# ./jucompiler -s < Testes/Meta3/AlgunsErros.java | diff Testes/Meta3/AlgunsErros.out -
# ./jucompiler -s < Testes/Meta3/Call_me_maybe.java | diff Testes/Meta3/Call_me_maybe.out -
# ./jucompiler -s < Testes/Meta3/CallError.java | diff Testes/Meta3/CallError.out -
# ./jucompiler -s < Testes/Meta3/declarationErrors.java | diff Testes/Meta3/declarationErrors.out -
# ./jucompiler -s < Testes/Meta3/divide.java | diff Testes/Meta3/divide.out -
# ./jucompiler -s < Testes/Meta3/DoublePrecisionErros.java | diff Testes/Meta3/DoublePrecisionErros.out -
# ./jucompiler -s < Testes/Meta3/Factorial.java | diff Testes/Meta3/Factorial.out -
# ./jucompiler -s < Testes/Meta3/FieldDecErrors.java | diff Testes/Meta3/FieldDecErrors.out -
# ./jucompiler -s < Testes/Meta3/ifwhile.java | diff Testes/Meta3/ifwhile.out -
# ./jucompiler -s < Testes/Meta3/LongNamesOperatorsAndPriority.java | diff Testes/Meta3/LongNamesOperatorsAndPriority.out -
# ./jucompiler -s < Testes/Meta3/MethodInvocation.java | diff Testes/Meta3/MethodInvocation.out -
# ./jucompiler -s < Testes/Meta3/methodsAndFields.java | diff Testes/Meta3/methodsAndFields.out -
# ./jucompiler -s < Testes/Meta3/MultipleArguments.java | diff Testes/Meta3/MultipleArguments.out -
# ./jucompiler < Testes/Meta3/NoFlags.java | diff Testes/Meta3/NoFlags.out -
# ./jucompiler -s < Testes/Meta3/operator_single.java | diff Testes/Meta3/operator_single.out -
# ./jucompiler -s < Testes/Meta3/Operators.java | diff Testes/Meta3/Operators.out -
# ./jucompiler -s < Testes/Meta3/Operators2.java | diff Testes/Meta3/Operators2.out -
# ./jucompiler -s < Testes/Meta3/Operators3.java | diff Testes/Meta3/Operators3.out -
# ./jucompiler -s < Testes/Meta3/printing_void.java | diff Testes/Meta3/printing_void.out -
# ./jucompiler -s < Testes/Meta3/Problema_H.java | diff Testes/Meta3/Problema_H.out -
# ./jucompiler -s < Testes/Meta3/simpleTest.java | diff Testes/Meta3/simpleTest.out -
# ./jucompiler -s < Testes/Meta3/testeProblemaE.java | diff Testes/Meta3/testeProblemaE.out -
# ./jucompiler -s < Testes/Meta3/TestesGeral.java | diff Testes/Meta3/TestesGeral.out -
# ./jucompiler -s < Testes/Meta3/testsMethods.java | diff Testes/Meta3/testsMethods.out -

# | diff Testes/Meta2/fielddecl.out -

# simpleTest
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
# testsMethods