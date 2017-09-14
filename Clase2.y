%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>
char lexema[64];
void yyerror(char *);
int yylex();
%}

%token ID OPERATOR NUM SEPARATOR

%%
expresion: expresion ID ':' '=' expr SEPARATOR ;
expresion: ID ':' '=' expr SEPARATOR;
expr: expr '+' termino | expr '-' termino | termino;
termino: NUM '*' termino | ID '*' termino | ID | NUM; 
%%

char absolute(char x){
	return x>'Z'?x:x+'a'-'A';
}

void yyerror(char *mgs){
	printf("error:%s",mgs);
}

int yylex(){ 
	//retorna un token es decir numeros
	//analizador lexico hecho a mano
	char c;
	while(1){
		c=getchar();
		if(c=='\n' || c==' ') return SEPARATOR;
		if(isdigit(c)) {
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}
			while(isdigit(c));
			ungetc(c,stdin);//devuelve el catacter a la entrada estandar
			lexema[i]=0;
			return NUM; //devuelve el token
		}
		if(absolute(c)<='z' && absolute(c)>='a'){
			int i=0;
			do{
				lexema[i++] = c;
				c = getchar();
				//printf("%c es letra\n",c);
			}while(isalpha(c));
			ungetc(c,stdin);
			lexema[i] = 0;
			return ID;
		}
		if(c==' ' || c=='\n') return SEPARATOR;
		return c;
	}
}
int main(){
	if(!yyparse()) 
		printf(": cadena valida \n");
	else	
	printf(": cadena invalida\n");
	return 0;
}
