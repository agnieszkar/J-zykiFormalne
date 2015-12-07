	int word_count = 0;
	int line_count = 0;

%%

[^ \t\n]+		++word_count; ECHO;
^[ \t\n]+		/* usuwanie białych znaków na początku lini oraz pustych lini */
[ \t]+$			/* usuwanie białych znaków na końcu lini */
[ \t]+			putchar( ' ' ); /* zamiana ciągów tabulatorów i spacji na pojedynczą spację */
\n				++line_count; ECHO;
%%
main()
{
  yylex();
  printf("number of lines = %d\nnumber of words = %d\n", line_count, word_count);
}

