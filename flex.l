%option noyywrap
%{

	#include <stdio.h>
	#define YY_DECL int yylex()
	#include "bison.tab.h"
%}

digitos		([0-9])
identif 	[a-z]

%%	

"print"		{	
				return PRINT;
			}
{identif}	{	
				yylval.id = yytext[0];
				return ID;
			}
\n			{	
				return N_LINHA;			
			}
"("			{	
				return E_PAR;		
			}
")"			{	
				return D_PAR;		
			}
"+"			{	
				return MAIS;			
			}
"-"			{	
				return MENOS; 		
			}
"*"			{	
				return VEZES; 		
			}
"/"			{	
				return DIVIDE;		
			}
"^"			{	
				return POTENCIA;		
			}
","			{	
				return VIRGULA;		
			}
"="			{	
				return IGUAL;		
			}
{digitos}+	{ 	
				yylval.ival = atoi(yytext);
				return INTEIRO;
			}
{digitos}+"."{digitos}* {
				yylval.fval = atof(yytext);
				return FLOAT;
			}

%%
