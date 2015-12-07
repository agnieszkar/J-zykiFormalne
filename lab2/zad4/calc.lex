%{
#include <math.h>
void push(int n);
int pull();
void clean();
%}
	int stack[100];
	int top = 0;


NUMBER			-?[0-9]+

%%

{NUMBER}	{
				push(atoi(yytext));
			}
"+"			{
				if( top < 2){
					printf("Błąd: za mała liczba argumentów\n");
					clean();
				} else 	push(pull()+pull());
			}
"-"			{
				if( top < 2){
					printf("Błąd: za mała liczba argumentów\n");
					clean();
				} else {
					int a = pull();
					push(pull()-a);
				}
			}
"*"			{
				if( top < 2){
					printf("Błąd: za mała liczba argumentów\n");
					clean();
				} else push(pull()*pull());
			}
"/"			{
				if( top < 2){
					printf("Błąd: za mała liczba argumentów\n");
					clean();
				} else {
					int a = pull();
					push(pull()/a);
				}
			}

"%"			{
				if( top < 2){
					printf("Błąd: za mała liczba argumentów\n");
					clean();
				} else {
					int a = pull();
					push(pull()%a);
				}
			}
"^"			{
				if( top < 2){
					printf("Błąd: za mała liczba argumentów\n");
					clean();
				} else {
					int a = pull();
					push(pow(pull(), a));
				}
			}
\n			{
				if( top != 1){
					if (top < 1); //printf("Błąd: top < 1\n");
					else printf("Błąd: za mała liczba operatorów \n");
					clean();
				} else {
					printf("=%d\n",pull());
					top = 0;
				}
			}
.			{
				printf("Błąd: zły symbol \"%s\"", yytext);
				clean();
			}
" "			

%%
void push(int n)
{
	stack[top++] = n;
}
int pull()
{
	return stack[--top];
}
void clean()
{
	YY_FLUSH_BUFFER;
	top = 0;
}

main()
{
	yylex();
}