%{
	#include<stdio.h>
	#include <string.h>
      #include<math.h>
	#include<stdlib.h>
    void yyerror(char* );	
%}

single_line_comment "//".*
multiple_line_comment [/][*][A-Za-z0-9. \n]*[*][/]
User_Datatype "integerf"|"floatf"|"characterf"|"doublef"
variable "f#"[a-zA-Z]([a-zA-Z0-9])*
logical_operator "&&"|"||"|"!!!"
digit [0-9]


%%

{single_line_comment} {
	printf("Single line comment\n");
}
{multiple_line_comment} {
	printf("Multiple line comment\n");
}

"=f"	{return ASSIGN; }
"integerf"	{return INT; }
"floatf"	{return FLOAT; }
"characterf"	{return CHAR; }
"doublef"	{return DOUBLE; }
"plusequal"	{return PLUSEQUAL; }
"minusequal"	{return MINUSEQUAL;}
"mulequal"	{return MULEQ;}
"divequal"	{return DIVEQ;}
"inc"  {return INCREAMENT; }
"dec"  {return DECREAMENT; }
"GT" {return GT; }
"ls" {return LS; }
"feq" {return EQUAL; }
"neq" {return NOTEQUAL; }
"GTeq" {return GTEQ;}
"lseq" {return LSEQ; }
"f(" {return '('; }
"f)" {return ')'; }
"START" {return START; }
"END"	{return END; }
"f[" {return '['; }
"f]" {return ']'; }
"jog" {return '+';}
"biyog" {return '-';}
"gun" {return '*';}
"vag"  {return '/';}
"power"  {return *yytext;}
"factorial"  {return *yytext;}
"jonno"  {return FOR;}
"during"  {return WHILE;}
"switchf"  {return SWITCH;}
"case_f" {return CASE;}
"timeless" {return DEFAULT;}
"smash" {return BREAK;}
"iff" {return IF; }
"elif" {return ELIF; }
"otherwise" {return ELSE; }
"sinf" {return SIN;}
"cosf" {return COS;}
"tanf" {return TAN;}
"logf" {returb LOG;}
"squaroot"	{return SQRT;}
"evenodd"		  {return *yytext;}
"function()"  {return MAIN;}
"rtn" {return RETURN;}
"porerta"	{return CONTINUE;}
"System.out"	{return PRINTF;}
"System.in"	{return SCANF;}
"#niye.asho"	{return IMPORT;}

[-+]?{digit}+				{yylval.ivalue=atoi(yytext);
					 			return NUMBERI;}
[-+]?{digit}*"."{digit}+		{yylval.fvalue=atof(yytext);
					 			return NUMBERF;}
"comma" {return comma;}
"colon" {return colon;}
"sm" {return semicolon;}
{variable} {yylval.string=strdup(yytext);
			return VARIABLE;}
	
.           yyerror("Invalid input character");
%%


int yywrap(){}
int main(){
   
  yylex();
}









