lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c functions.c semantics.c symbol_table.c
./jucompiler -t < Testes/Meta3/Factorial.java

# | diff Testes/Meta2/fielddecl.out -