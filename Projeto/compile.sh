lex jucompiler.l
yacc -y -d -t -v jucompiler.y
cc -o jucompiler y.tab.c lex.yy.c
./jucompiler -t < Testes/methodfielddecl.java