lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c
./jucompiler -t < Testes/Meta2/methodfielddecl.java

# | diff Testes/unterminatedString.out -