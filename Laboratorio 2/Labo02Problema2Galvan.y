%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>
char lexema[64];
void yyerror(char *);
int yylex();
%}

%token OCTAL

%%
instr: termino | termino ' ' instr | termino '\n' instr;
termino: integer | real;
integer: OCTAL | '-' OCTAL
real: '-' OCTAL '.' OCTAL | OCTAL '.' OCTAL | real 'e' OCTAL | OCTAL 'e' OCTAL;
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
		if('1' <= c && c <='7') {
			int i=0;
			do{
				lexema[i++]=c;
				c=getchar();
			}
			while('0'<=c && c <= '7');
			ungetc(c,stdin);//devuelve el catacter a la entrada estandar
			lexema[i]=0;
			return OCTAL; //devuelve el token
		}
		return c;
	}
}
int main(){
	if(!yyparse()) 
		puts("La cadena es valida");
	else	
		puts(": cadena invalida");
	return 0;
}
