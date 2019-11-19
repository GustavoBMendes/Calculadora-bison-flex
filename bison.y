%{

    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <func_bison.h>
    extern int yylex(void);
    extern int yyparse();
    extern FILE* yyin;

    int symbols[52];
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int val);

    void yyerror(const char* s);

%}

%union{
    int     ival;
    float   fval;
    char    id;
}

%token<ival> INTEIRO
%token<fval> FLOAT
%token<id> ID
%token MAIS MENOS VEZES DIVIDE POTENCIA VIRGULA IGUAL E_PAR D_PAR
%token PRINT N_LINHA
%left IGUAL
%left MAIS MENOS
%left VEZES DIVIDE  

%type<ival> iexp
%type<fval> fexp

%start entrada

%%
    entrada:
            |   entrada line
    ;
    line    : N_LINHA
            | fexp N_LINHA {printf("%f\n", $1);}
            | iexp N_LINHA {printf("%i\n", $1);}
            | ID IGUAL iexp N_LINHA {updateSymbolVal($1, $3);
                                     printf("Resultado %c = %d", $1, $3);}
            | ID IGUAL fexp N_LINHA {updateSymbolVal($1, $3);}
            | PRINT iexp N_LINHA
            | PRINT fexp N_LINHA
    ;
    iexp: INTEIRO               {$$ = $1; }
        | ID                    {$$ = symbolVal($1);}
        | iexp MAIS iexp        {$$ = $1 + $3;}
        | iexp MENOS iexp
        | iexp VEZES iexp
        | iexp DIVIDE iexp
        | E_PAR iexp D_PAR      {$$ = $2;}
    ;
    fexp: FLOAT                 {$$ = $1;}
        | ID                    {$$ = symbolVal($1);}
        | fexp MAIS fexp        {$$ = $1 + $3;}
        | fexp MENOS fexp       
        | fexp VEZES fexp
        | fexp DIVIDE fexp
        | E_PAR fexp D_PAR      {$$ = $2;}
        | iexp MAIS fexp        {$$ = $1 + $3;}
        | iexp MENOS fexp       {$$ = $1 - $3;}
        | iexp VEZES fexp       {$$ = $1 * $3;}
        | iexp DIVIDE fexp      {$$ = $1 / $3;}
        | fexp MAIS iexp
        | fexp MENOS iexp
        | fexp VEZES iexp
        | fexp DIVIDE iexp
    ;
    

%%

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main() {
    yyin = stdin;

    int i;
    for(i = 0; i < 52; i++){
        symbols[i] = 0;
    }

    do {
        yyparse();
    }while(!feof(yyin));

    return 0;
}

void yyerror(const char* s){
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}