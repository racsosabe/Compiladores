%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>
int yylex();
char lexema[254];
void yyerror(char *);
%}

%token ID IGUAL NUM PUNTCOM SUM MEN INICIO PROGRAMA FIN PUNTO POT MUL DIV RAIZ PD PI COMA

%%
s: PROGRAMA ID PUNTCOM INICIO listainstr FIN;
listainstr: listainstr instr| ;
instr: ID IGUAL expr PUNTCOM;
expr:expr SUM term | term |expr MEN term;
term: term MUL fact | fact | term DIV fact ;
fact: fact POT valor | valor | PI expr PD; 
real: MEN NUM COMA NUM | NUM COMA NUM;
entero: NUM | MEN NUM;
valor: real | entero | ID | RAIZ PI NUM PD;
%%

void yyerror(char *mgs){
	printf("error:%s",mgs);
}

int Reservada(char lexema[]){
	if(strcasecmp(lexema,"Programa")==0) return PROGRAMA;
	if(strcasecmp(lexema,"Inicio")==0) return INICIO;
	if(strcasecmp(lexema,"Fin")==0) return FIN;
	return ID;
}

int yylex(){
	char c;
	int i;
	while(1){
		c = getchar();
		if(c=='\n' || c == ' ') continue;
		if(isspace(c)) ;
		if(c==';') return PUNTCOM;
		if(c=='=') return IGUAL;
		if(c=='+') return SUM;
		if(c=='-') return MEN;
		if(c=='*') return MUL;
		if(c=='/') return DIV;
		if(c=='^') return POT;
		if(c=='r') return RAIZ;
		if(c=='(') return PI;
		if(c==')') return PD;
		if(c=='.') return PUNTO;
		if(c==',') return COMA;
		if(isalpha(c)){
			i = 0;
			do{
				lexema[i++]=c;
				c=getchar();	
			}while(isalnum(c));
			ungetc(c,stdin);
			lexema[i]=0;
			return Reservada(lexema);
		}
		if('1' <= c && c <='7'){
			i = 0;
			do{
				lexema[i++]=c;
				c=getchar();
			}while('0' <= c && c <= '7');
			if(isalpha(c))
			return c;
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
