calc: calc.y calc.l
	bison -d calc.y
	flex calc.l
	gcc -o calc lex.yy.c calc.tab.c -lm
