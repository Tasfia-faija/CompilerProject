%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
int i=0,sw=-1,fi=0,s[100];
int k,j,stop=0;
int inc=0,dec=0,g=-1,l=-1,r=-1;

struct  {
	char *s;
	float n;
	int nint;
	int f;
}store[1000]; //store type er 1000ta array


void yyerror(char*);
int yylex(void); 

%}


%union
{
	float float_value;
	int int_value;  //yylval dye ei 3ta access korte parbo
	char *string;
}

%token MAIN STARTF ENDF RETURN INCREMENT DECREMENT 
%token INT FLOAT CHAR DOUBLE GT LS EQ NEQ SHOW IF ELIF ELSE SWITCH CASE DEF BREAK FOR WHILE COND SQRT FACT  COL CM  SM
%token<string> VARIABLE
%token<float_value> NUMBERFLOAT
%type<int_value> exp1  if_condition else_if if_condition1 assign asgn case default
%token<int_value> NUMBERINT


%nonassoc IFX
%nonassoc ELIFX
%nonassoc ELSE
%left PLUS MINUS INCREMENT DECREMENT
%left MULT DIV
%left GT LT EQ NEQ
%nonassoc '<' '>'


%%
program:
	 MAIN STARTF statements ENDF {printf("succesfully compiled\n");}  
	|
	;

statements:
	statements stmnt  {/*printf("valid statement 1\n");*/}
	|stmnt         {/*printf("valid statement 2\n");*/}
	;


stmnt:
	 declaration     {/*printf(" declaration \n");*/}
	|assign SM      {/*printf(" assign \n");*/}
	|RETURN SM     {printf("\nend of program\n");}
	|output SM   {/*printf("output\n");*/}    
	|conditions 
	|loops
	|SQRT '(' exp1 ')' SM 
    			{
    			   float d=sqrt($3);
    			   printf("square root of %d is %f\n",$3,d);

    			}

    |FACT '(' exp1 ')' SM
                 {
                 int k=$3,d=1,i;
                 for(i=1;i<=k;i++)
                 d=d*i;
                 printf("Factorial of %d is %d\n",$3,d);

                 }
    |'sin' '(' exp1 ')' SM     
    			{
    			  float d=sin($3 * 3.14/180);
    			  printf("sin(%d) is %.5f\n",$3,d);
    			}     
   |'cos' '(' exp1 ')' SM     
    			{
    			float d=cos($3* 3.14/180);
    			  printf("cos(%d) is %.5f\n",$3,d);
    			}            			   
   |'tan' '(' exp1 ')' SM     
    			{
    			 float d=tan($3* 3.14/180);
    			  printf("tan(%d) is %.5f\n",$3,d);
    			}  
    |'log' '(' exp1 ')' SM    
    			{
    			  float d=log($3);
    			  printf("log(%d) is %.5f\n",$3,d);
    			}   
    |'evenodd' '(' exp1 ')' SM
				{
				int d=$3;
				  if(d%2)
				  printf("%d is odd\n",$3);
				  else
				  printf("%d is even\n",$3);

				}  
    |'gcd' '(' exp1 CM exp1 ')' SM  
    			{
    			   int i,n1,n2,gcd;
					n1=$3;
					n2=$5;
				for(i=1; i <= n1 && i <= n2; ++i)   
    			  {
        
        			if(n1%i==0 && n2%i==0)
            		gcd = i;
    			   }
    			 printf("G.C.D of %d and %d is %d\n", n1, n2, gcd);
    			}
    |'power' '(' exp1 CM exp1 ')' SM 
    			{
    			   int d=pow($3,$5);
    			   printf("power of %d^%d is %d\n",$3,$5,d);

    			}  	
    |'prime' '(' exp1 ')' SM
    			{int i, n=$3,flag=0;
    			for (i = 2; i <= n / 2; ++i) {
    					if (n % i == 0) {
      							flag = 1;
     							 break;
    								}
  						}

  					if (n == 1) {
    					printf("1 is neither prime nor composite.\n");}    
  					else {
    					if (flag == 0)
      					printf("%d is a prime number.\n", n);
   						 else
      					printf("%d is not a prime number.\n", n);}
    				}					 

	;
loops:
    FOR START NUMBERINT COL NUMBERINT END '(' exp1 ')'    {
	   int i=0;
	   for(i=$3;i<$5;i++){
	   printf("for loop statement\n");
	   }
         }
    | WHILE '(' NUMBERINT GT NUMBERINT ')' STARTF exp1 ENDF   {
										int i;
										printf("While LOOP: ");
										for(i=$3;i<=$5;i++)
										{
											printf("%d ",i);
										}
										printf("\n");
										printf("value of the expression: %d\n",$8);

	}


conditions:
     if_condition 	{
     					printf("the value of if bock is %d\n",$1);

     					}
    |switch_condition 		{
    						printf("switch block ended\n");   //ei conditions er ki hbe?? 

    						}
    ;

if_condition:
	IF '(' exp1 ')' STARTF exp1 SM ENDF %prec IFX {
								if($3)
								{
									printf("\nvalue of expression in IF: %d\n",($6));
								}
								else
								{
									printf("\ncondition value zero in IF block\n");
								}
							}

	| IF '(' exp1 ')' STARTF exp1 SM ENDF ELSE STARTF exp1 SM ENDF {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$11);
									}
								   }
	| IF '(' exp1 ')' STARTF IF '(' exp1 ')' STARTF exp1 SM ENDF ELSE STARTF exp1 SM ENDF exp1 SM ENDF ELSE STARTF exp1 SM ENDF %prec IFX {
								 	if($3)
									{
										if($8)
											printf("\nvalue of expression middle IF: %d\n",$11);
										else
											printf("\nvalue of expression middle ELSE: %d\n",$16);
										printf("\nvalue of expression in first IF: %d\n",$19);
									}
									else
									{
										printf("\nvalue of expression in else: %d\n",$24);
									}
								   }
	| IF '(' exp1 ')' STARTF exp1 SM ENDF ELIF '(' exp1 ')' STARTF exp1 SM ENDF ELSE STARTF exp1 SM ENDF {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else if($11)
									{
										printf("\nvalue of expression in ELIF: %d\n",$14);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$19);
									}
								   }
	;

if_condition1:
			exp1   {$$=$1;}
			|VARIABLE '=' exp1{$$=$3;}
			|if_condition1 VARIABLE '=' exp1
			{
			  $$=$4;
			}
			|if_condition1 exp1 {$$=$2;}
			;

	
output: 
      SHOW '(' VARIABLE ')'   { int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$3)==0)
									{ 
								 	 if(store[j].f==1)  
								 	{
							       printf("\nThe value of variable %s is %f \n",$3,store[j].n); 
								 	    }
								 	 else if(store[j].f==0) 
								 	 {
								 	   printf("The value of variable %s is %d \n",$3,store[j].nint); 
								 	    }
								 	 find=1;
								 	 break;      
								 	 }
								 	                 
									}
								if(find==0||store[j].f==-1) 
								{printf("Not assigned value at %s \n",$3);}  


                              }

	;

	assign:
	assign CM asgn   
	|assign asgn
	|asgn  {$$=$1;}   
	;	

asgn:
	VARIABLE '=' NUMBERFLOAT     { 
								
								int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								 	 $$=store[j].n=$3;
								 	 store[j].f=1;
								 	 printf("\nValue of the Variable %s=%f\t %d\n",store[j].s,store[j].n,j);
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0&&)
								{printf("Not declared \n");}
	                          } 
	
	|VARIABLE '=' exp1     { 
								
								int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{$$=store[j].nint=$3;
								 	 store[j].f=0;
								 	 find =1;			
								 	 break;
								 	 }
								 	 
									}
								if(find==0&&)
								{printf("%s Not declared \n",$1);}
	
	                          }
	|exp1                    {$$=$1;}       
                          

	


	;  

exp1:	
    NUMBERINT                { $$ = $1;
								
								}                                              
	| exp1 '+' exp1            {$$ = $1 + $3;
	 						//printf("PLUS \n");
	 						}
	|exp1 '-' exp1            {$$ = $1 - $3;
							//printf("MINUS \n");
							}
	|exp1 '*' exp1            {$$ = $1 * $3;
							//printf("MUL \n");
							}
	|exp1 '/' exp1            {$$ = $1 / $3;
							//printf("DIV \n");
							}

	|exp1 GT exp1            {$$ = $1 > $3; 
	                           l=$1;
	                           r=$3;
	                           g=1;
							//printf("GT \n");
							}
	|exp1 LT exp1            {$$ = $1<$3;
	                           l=$1;
	                           r=$3;
							//printf("DIV \n");
							}							
	|exp1 EQ exp1            {$$ = $1== $3;
							   l=$1;
	                           r=$3;
							//printf("DIV \n");
							}
	|exp1 NEQ exp1           {$$ = $1!= $3;
							  l=$1;
	                          r=$3;
							//printf("DIV \n");
							}
    |'(' exp1 ')'			{$$=$2;
                             //printf("DIV \n");
                             }                             								

	|VARIABLE  				{ 
								int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								  
								 	 if(store[j].f==1)
								 	{ $$=store[j].n;
								 	    
								 	    }
								 	 else if(store[j].f==0)
								 	 { $$=store[j].nint;
								 	    
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("5Not assigned value at %s \n",$1);}
								}
   |INCREMENT VARIABLE 		      { int find=0,j=0;
	                            for(j=0;j<i;j++)
								{inc=1;
							  	 if(strcmp(store[j].s,$2)==0)
									{ inc=1;
								  
								 	 if(store[j].f==1)
								 	{ $$=store[j].n=store[j].n+1;
								 	}
								 	 else if(store[j].f==0)
								 	 { $$=store[j].nint=store[j].nint+1;
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("4Not assigned value at %s \n",$2);}
								}
							                               
    |DECREMENT VARIABLE 		 {	int find=0,j=0;
	                            for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$2)==0)
									{ 
								     dec=1;
								 	 if(store[j].f==1)
								 	{ $$=store[j].n=store[j].n-1;}
								 	 else if(store[j].f==0)
								 	 { $$=store[j].nint=store[j].nint-1;
								 	    }
								 	 find=1;
								 	 break;
								 	 }
								 	 
									}
								if(find==0||store[j].f==-1)
								{printf("3Not assigned value at %s \n",$2);}
								}
							
  		
	;
	
	



declaration:
     type id1 SM ;





type: 
	INT   
	|FLOAT
	|CHAR
	|DOUBLE
	;

id1:
	id1 CM id    {/*printf(" id1\n");*/}
	|id  ;
id:
	VARIABLE                {
								store[i].s=$1;
								store[i].f=-1;
								printf("declared %s\n",store[i].s);
								i++;
	                          } 
	|VARIABLE '=' NUMBERFLOAT   {  int find=0,j=0;
								for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								 	 store[j].n=$3;
								 	 store[i].f=1;
								 	 printf("\nValue of the Variable %s=%f\t %d\n",store[j].s,store[j].n,j);
								 	 find=1;
								 	 break;
								 	 }
								}

								if(find==0)
								{
									store[i].s=$1;
									store[i].n=$3;
									store[i].f=1;
									printf("\nValue of the Variable %s=%f\t\n",store[i].s,store[i].n);
									i++;

								}
	
       						}
    |VARIABLE '=' NUMBERINT	{  int find=0,j=0;
								for(j=0;j<i;j++)
								{
							  	 if(strcmp(store[j].s,$1)==0)
									{ 
								 	 store[j].ni=$3;
								 	 store[i].f=0;
								 	 printf("\nValue of the Variable %s=%d\t %d\n",store[j].s,store[j].nint,j);
								 	 find=1;
								 	 break;
								 	 }
								}

								if(find==0)
								{
									store[i].s=$1;
									store[i].ni=$3;
									store[i].f=0;
									printf("\nValue of the Variable %s=%d\t\n",store[i].s,store[i].nint);
									i++;

								}
	
       						}
	   						
    ;






%%
int yywrap()
{
    return 1;
}

int main(void)
{
   yyin=freopen("in.txt","r",stdin);
	yyout=freopen("out.txt","w",stdout);

    yyparse();

    fclose(yyin);
    fclose(yyout);
    return 0;
}
void yyerror( char *s)
{
    printf("%s\n",s);
}
	