lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c functions.c
./jucompiler -t < Testes/Meta2/fielddecl.java | diff Testes/Meta2/fielddecl.out -

# | diff Testes/unterminatedString.out -