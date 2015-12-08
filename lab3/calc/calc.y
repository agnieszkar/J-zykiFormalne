%{
  #include <math.h>
  #include <stdio.h>
  int yylex (void);
  void printONP();
  void putNumber(int n);
  void putText(const char *s, int length);
  void clean();
  
  extern int yylineno;  // z lex-a
  int n = 1234577;
  char onpExpression[200];
  int numbers[50];
  int numbersLength = 0;
  int top = 0;
%}


/* Bison declarations.  */
%define api.value.type {int}
%token NUM
%token ERROR
%token END
%left '-' '+'
%left '*' '/'
%precedence NEG   /* negation--unary minus */
%right '^'        /* exponentiation */

%% /* The grammar follows.  */

input: %empty
	| input line
;

line: END
	| exp END  { printONP(); printf("\nWynik:\t%d\n", $1); }
	| ERROR		{ printf("Bład: Niepoprawny symbol\n");}
;

exp: NUM                 { $$ = ($1 % n); 			putNumber($1 % n);	}
	| exp '+' exp        { $$ = addMod($1, $3);		putText("+ ", 2);	}
	| exp '-' exp        { $$ = addMod($1, negMod($3)); putText("- ", 2);    }
	| exp '*' exp        { $$ = mulMod($1,$3);  	putText("* ", 2);    }
	| exp '/' exp        { 
							if($3 % n) {
								$$ = divMod($1,$3);		putText("/ ", 2);
							} else {
								printf("Bład: Dzielenie przez 0.\n");
								YYERROR;
							}
						 }
	| '-' exp  %prec NEG { $$ = -($2 % n);			putText("~ ", 2);		}
	| exp '^' exp        { $$ = powerMod($1,$3);	putText("^ ", 2);	}
	| '(' exp ')'        { $$ = ($2 % n);					}
;

%%
int addMod(int a, int b)
{
	if( a < 0) a = negMod(a);
	if( b < 0) b = negMod(b);
	return ((a % n) + (b % n)) % n;
}

int mulMod(int a, int b)
{
	if( a < 0) a = negMod(a);
	if( b < 0) b = negMod(b);
	int result = 0;
	b = b % n;
	a = a % n;
	while( b > 1739){
		result = (result + ((a * 1739) % n)) % n;
		b = b - 1739;
	}
	return (result + ((a * b)%n)) % n;
}

int negMod(int a)
{
	//printf("negacja\n");
	return n - a%n;
}

int invMod(int a)
{
	//printf("inwersja\n");
	return powerMod(a, n-2);
}

int divMod(int a, int b)
{
	if( a < 0) a = negMod(a);
	if( b < 0) b = negMod(b);
	return mulMod(a, invMod(b)); 
}

int powerMod(int base,int  exponent) {

	if( base < 0) base = negMod(base);
	if( exponent < 0){
		exponent = -exponent % n ;
		base = invMod(base);
	}
	//printf("potega\n");
    int result = 1;
    base = base % n;
    exponent = exponent % n;
    while (exponent > 0) {
       result = mulMod(result, base);
       exponent--;
    }
    return result;
}

void putText(const char *s, int length)
{
	int i;
	for( i=0; i < length; i++){
		onpExpression[top++] = *s;
		s++;
	}
}


void putNumber(int n)
{
	putText(". ", 2);
	numbers[numbersLength++] = n;
}

void printONP()
{
	int i;
	int numIndex = 0;
	for(i=0; i < top; i++){
		if( onpExpression[i] != '.'){
			printf("%c", onpExpression[i]);
		} else {
			printf("%d", numbers[numIndex++]);
		}
	}
	clean();
}

void clean()
{
	numbersLength = 0;
  	top = 0;	
}

int yyerror(char *s)
{
    printf("Błąd: %s\n",s);	
    return 0;
}

int main()
{
	while(1) {
    	yyparse();
    	clean();
    }
    return 0;
}

