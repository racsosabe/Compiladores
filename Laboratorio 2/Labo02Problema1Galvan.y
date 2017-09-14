%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>
int yylex();
char lexema[254];
void yyerror(char *);
%}

%token IGUAL NUM PUNTCOM SUM MEN INICIO PROGRAMA FIN PUNTO POT MUL DIV RAIZ PD PI COMA

%%
lista_operaciones: lista_operaciones instr | ;
instr: expr PUNTCOM;
expr:expr SUM term | term |expr MEN term;
term: term MUL fact | fact | term DIV fact ;
fact: valor | PI expr PD; 
real: MEN NUM COMA NUM | NUM COMA NUM | real 'e' NUM | NUM 'e' NUM;
entero: NUM | MEN NUM;
valor: real | entero;
%%

void yyerror(char *mgs){
	printf("error:%s",mgs);
}

int yylex(){
	char c;
	int i;
	while(1){
		c = getchar();
		if(c=='\n' || c == ' ') continue;
		if(c==';') return PUNTCOM;
		if(c=='+') return SUM;
		if(c=='-') return MEN;
		if(c=='*') return MUL;
		if(c=='/') return DIV;
		if(c=='(') return PI;
		if(c==')') return PD;
		if(c=='.') return PUNTO;
		if(c==',') return COMA;
		if(isdigit(c)){
			i = 0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while(isdigit(c));
			if(isalpha(c)) return c;
			ungetc(c,stdin);
			lexema[i]=0;
			return NUM;
		}
		return c;
	}
}

int main(){
	if(!yyparse())
		puts("La cadena es valida");
	else
		puts(" cadena invalida");
	return 0;
}
