START			"/*"
FINAL			"/"
N_WOR			[^*]
WOR				"*"
N_WOR_N_FINAL	[^*/]
BLOCK_COMMENT_WITHOUT_START	({N_WOR}*{WOR}+{N_WOR_N_FINAL})*{N_WOR}*{WOR}+{FINAL}


%%
\"(([^"\n])|(\\\n))*\"					ECHO;
("//"(.|(\\\n))*\n)						putchar('\n');		 
"/**"{BLOCK_COMMENT_WITHOUT_START}		ECHO;
{START}{BLOCK_COMMENT_WITHOUT_START}	
