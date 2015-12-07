START			"/*"
FINAL			"/"
N_WOR			[^*]
WOR				"*"
N_WOR_N_FINAL	[^*/]


%%
\"(([^"\n])|(\\\n))*\"	ECHO;
("//"(.|(\\\n))*\n)		putchar('\n');
{START}({N_WOR}*{WOR}+{N_WOR_N_FINAL})*{N_WOR}*{WOR}+{FINAL}	
