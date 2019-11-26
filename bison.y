%{

    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include "func_bison.h"
    extern int yylex(void);
    extern int yyparse();
    extern FILE* yyin;

    int symbols[52];
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int val);

%}

%union{
    struct ast *a;
    int     ival;
    double  fval;
    struct id *s
}

%token<ival> INTEIRO
%token<fval> REAL
%token<s> ID
%token MAIS MENOS VEZES DIVIDE POTENCIA VIRGULA IGUAL E_PAR D_PAR
%token PRINT N_LINHA
%left IGUAL
%left MAIS MENOS
%left VEZES DIVIDE  

%type<a> iexp fexp line

%start entrada

%%
    entrada:
            | entrada line N_LINHA  {
                                        dumpast($2, 0);
                                        printf("= %4.4g\n> ", eval($2));
                                        //treefree($2);
                                        
                                    }
    ;
    line: fexp  
        | iexp 
        | ID IGUAL iexp {$$ = newasgn($1, $3, 1); }
        | ID IGUAL fexp {$$ = newasgn($1, $3, 2); }
        | PRINT iexp    {$$ = newcall("print", $2); }
        | PRINT fexp    {$$ = newcall("print", $2); }
    ;
    iexp: INTEIRO               {$$ = newnum($1, 1); } //valor 1 == tipo int
        | ID                    {$$ = newref($1); }
        | E_PAR iexp D_PAR      {$$ = $2; }
        | iexp POTENCIA iexp    {$$ = newast('^', $1, $3); }
        | iexp VEZES iexp       {$$ = newast('*', $1, $3); }
        | iexp DIVIDE iexp      {$$ = newast('/', $1, $3); }
        | iexp MAIS iexp        {$$ = newast('+', $1, $3); }
        | iexp MENOS iexp       {$$ = newast('-', $1, $3); }
        
    ;
    fexp: REAL                  {$$ = newnum($1, 2); } //valor 2 == tipo float
        | E_PAR fexp D_PAR      {$$ = $2;}
        | fexp POTENCIA fexp    {$$ = newast('^', $1, $3); }
        | fexp VEZES fexp       {$$ = newast('*', $1, $3); }
        | fexp DIVIDE fexp      {$$ = newast('/', $1, $3); }
        | fexp MAIS fexp        {$$ = newast('+', $1, $3); }
        | fexp MENOS fexp       {$$ = newast('-', $1, $3); }
              
    ;
    

%%
