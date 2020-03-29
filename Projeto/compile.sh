lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c functions.c
./jucompiler -e2 < Testes/Meta2/statement.java

# | diff Testes/unterminatedString.out -