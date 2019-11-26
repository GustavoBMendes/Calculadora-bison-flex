frontend:	flex.l bison.y func_bison.h func_bison.c
			bison -d bison.y && \
			flex flex.l && \
			gcc bison.tab.c lex.yy.c func_bison.c -o front -lm

clean:
		rm -f front \
		bison.tab.c bison.tab.h lex.yy.c