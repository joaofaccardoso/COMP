lower                                                           [a-z]
upper                                                           [A-Z]
number                                                          [0-9]
%{
int line = 1;
int column = 1;
int lComment = 0; 
int cComment = 0; 
int lBrace = 0; 
int cBrace = 0;
int lPar = 0; 
int cPar = 0; 
int lSQ = 0; 
int cSQ = 0; 
int lError = 0;
int cError = 0;
int flag;
%}
%X MULTCOMMENT
%%
<MULTCOMMENT>"\n"                            {column=1; line++;}
<MULTCOMMENT>"*/"                            {lComment = 0; cComment = 0; BEGIN 0; column+=yyleng;}
<MULTCOMMENT>.                               {column++;}

System"."out"."print(ln)?       {column+=yyleng; if(flag==1) printf("PRINT\n");}
Integer"."parseInt              {column+=yyleng; if(flag==1) printf("PARSEINT\n");}
"."length                       {column+=yyleng; if(flag==1) printf("DOTLENGHT\n");}
public                          {column+=yyleng; if(flag==1) printf("PUBLIC\n");}
return                          {column+=yyleng; if(flag==1) printf("RETURN\n");}
static                          {column+=yyleng; if(flag==1) printf("STATIC\n");}
String                          {column+=yyleng; if(flag==1) printf("STRING\n");}
void                            {column+=yyleng; if(flag==1) printf("VOID\n");}
while                           {column+=yyleng; if(flag==1) printf("WHILE\n");}
int                             {column+=yyleng; if(flag==1) printf("INT\n");}
double                          {column+=yyleng; if(flag==1) printf("DOUBLE\n");}
if                              {column+=yyleng; if(flag==1) printf("IF\n");}
else                            {column+=yyleng; if(flag==1) printf("ELSE\n");}
bool                            {column+=yyleng; if(flag==1) printf("BOOLEAN\n");}
class                           {column+=yyleng; if(flag==1) printf("CLASS\n");}
(true|false)                    {column+=yyleng; if(flag==1) printf("BOOLIT\n");}
==                              {column+=yyleng; if(flag==1) printf("EQ\n");}
=                               {column+=yyleng; if(flag==1) printf("ASSIGN\n");}
","                             {column+=yyleng; if(flag==1) printf("COMMA\n");}
"/"                             {column+=yyleng; if(flag==1) printf("DIV\n");}
">>"                            {column+=yyleng; if(flag==1) printf("RSHIFT\n");}
"<<"                            {column+=yyleng; if(flag==1) printf("LSHIFT\n");}
"^"                             {column+=yyleng; if(flag==1) printf("XOR\n");}
">="                            {column+=yyleng; if(flag==1) printf("GE\n");}
">"                             {column+=yyleng; if(flag==1) printf("GT\n");}
"<="                            {column+=yyleng; if(flag==1) printf("LE\n");}
"<"                             {column+=yyleng; if(flag==1) printf("LT\n");}
"-"                             {column+=yyleng; if(flag==1) printf("MINUS\n");}
"%"                             {column+=yyleng; if(flag==1) printf("MOD\n");}
"!="                            {column+=yyleng; if(flag==1) printf("NE\n");}
"!"                             {column+=yyleng; if(flag==1) printf("NOT\n");}
"||"                            {column+=yyleng; if(flag==1) printf("OR\n");}
"+"                             {column+=yyleng; if(flag==1) printf("PLUS\n");}
";"                             {column+=yyleng; if(flag==1) printf("SEMICOLON\n");}
"*"                             {column+=yyleng; if(flag==1) printf("STAR\n");}
"->"                            {column+=yyleng; if(flag==1) printf("ARROW\n");}
"&&"                            {column+=yyleng; if(flag==1) printf("&&\n");}
"\n"                            {column=1; line++;}
"/*"                            {lComment = line; cComment = column; BEGIN MULTCOMMENT; column+=yyleng;}
"*/"                            {lError = line; cError = column; column+=yyleng;}
"{"                             {column+=yyleng; printf("LBRACE\n");}
"}"                             {column+=yyleng; printf("RBRACE\n");}
"("                             {column+=yyleng; printf("LPAR\n");}
")"                             {column+=yyleng; printf("RPAR\n");}
"["                             {column+=yyleng; printf("LSQ\n");}
"]"                             {column+=yyleng; printf("RSQ\n");}
(_|$|{lower}|{upper})(_|$|{lower}|{upper}|{number})*            {column+=yyleng; if(flag==1) printf("ID(%s)\n",yytext);}
(0|{number}({number0}|"_")*{number0})                 {column+=yyleng; if(flag==1) printf("INTLIT(%s)\n",yytext);}
(({integer}"."{integer}?((e|E)("+"|"-")?{integer})?)|{integer}?"."{integer}((e|E)("+"|"-")?{integer})?|{number}(e|E)("+"|"-")?{integer})         {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext);}

(.|"//".*) {column++;}
%% 

#include <string.h>
#include <stdio.h>
int main(int argc, char *argv[])
{
    if(argc > 1){
        if(strcmp(argv[1],"-l")==0){
            flag = 1;
        }
        else if(strcmp(argv[1],"-e1")==0){
            flag = 2;
        }
    }
    yylex();
    if(lComment != 0){
        printf("Line <%d>, col <%d>: unterminated comment\n",lComment,cComment);
    }
    // printf("lines: %d\n",line);
    return 0;
}

int yywrap()
{
    return 1;
}
