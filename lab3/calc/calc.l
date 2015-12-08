%option noyywrap
%option yylineno
%{
#include "calc.tab.h"
int yylex();
%}

NUMBER			([0-9]+(\\\n[0-9]*)*)|((\\\n[0-9]*)*[0-9]+)
COMMENT			("#"(.|(\\\n))*\n)

%%

{COMMENT}	;
[ \t]+ 		;
{NUMBER}	{ yylval = convertNumber(yytext, yyleng); return NUM; }
"+"			{ return '+'; }
"*" 		{ return '*'; }
"-"			{ return '-'; }
"/"			{ return '/'; }
"^"			{ return '^'; }
\(			{ return '('; }
\)			{ return ')'; }
\n			{ return END; }
.			{ return ERROR; }

%%

int convertNumber(const char * str, int length)
{
	char *s = (char*) malloc(length *sizeof(char));
	int i = 0;
	int newSize = 0;
  	while ( i < length){
    	if((*str != '\\') && (*str !='\n')){
    		s[newSize] = *str;
    		newSize++;
    	}
    	str++;
    	i++;
  	}
  	char *result = (char*) malloc(newSize *sizeof(char));
  	strncpy(result, s, newSize *sizeof(char));
//	printf("length=%d\tnewSize=%d resultSize=%d\n",length, newSize, sizeof(result));
// 	printf("lex : %d \n", atoi(result));
	return atoi(result);
}