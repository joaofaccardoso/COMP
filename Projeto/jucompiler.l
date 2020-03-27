letters                 [a-zA-Z]
number                  [1-9]
number0                 [0-9]
escape                   \\[nfrt\\\"]
integer                 {number}(_*{number0}+)*
integer0                {number0}(_*{number0}+)*
exp                     (e|E)("+"|"-")?{integer0}+
reserved                float|Integer|System|null|"++"|"--"|abstract|assert|break|byte|case|catch|char|const|continue|default|do|enum|extends|final|finally|for|goto|implements|import|instanceof|interface|long|native|new|package|private|protected|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|volatile
whiteSpace              (" "|\t|\f)
%{
#include <string.h>
#include <stdio.h>
#include "y.tab.h"
int line = 1;
int column = 1;
int lError = 0;
int cError = 0;
int lComment = 0;
int cComment = 0;
int lString = 0;
int cString = 0;
int string = 0;
int flag;
int first = 1;
int initCol = 1;
char * printString;
%}
%X COMMENT STRINGFLAG
%%
<COMMENT>"*/"                   {BEGIN 0; column+=yyleng; initCol=column;}
<COMMENT>(\n|\r|\r\n)           {column=1; initCol=column; line++;}
<COMMENT><<EOF>>                {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated comment\n",lComment,cComment); BEGIN 0;}
<COMMENT>.                      {column+=yyleng; initCol=column;}

<STRINGFLAG>\"                      {column+=yyleng; if(flag==1 && string==0) printf("STRLIT(%s)\n",printString); BEGIN 0; string=0; yylval.charvalue=(char*)strdup(yytext); return STRING;}
<STRINGFLAG>(\n|\r|\r\n)            {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; string=0; BEGIN 0;}
<STRINGFLAG><<EOF>>                 {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; string=0; BEGIN 0;}
<STRINGFLAG>{escape}                {column+=yyleng;}
<STRINGFLAG>\\.?                    {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: invalid escape sequence (%s)\n",line,column,yytext); column+=yyleng; string=1;}
<STRINGFLAG>(.)                     {column+=yyleng;}

\/\/([^\r\n])*                  {;}
{whiteSpace}                    {column+=yyleng; initCol=column;}
(\n|\r|\r\n)                    {column=1; initCol=1; line++;}
System"."out"."print            {initCol=column; column+=yyleng; if(flag==1) printf("PRINT\n"); yylval.charvalue=(char*)strdup(yytext); return PRINT;}
Integer"."parseInt              {initCol=column; column+=yyleng; if(flag==1) printf("PARSEINT\n"); yylval.charvalue=(char*)strdup(yytext); return PARSEINT;}
"."length                       {initCol=column; column+=yyleng; if(flag==1) printf("DOTLENGHT\n"); yylval.charvalue=(char*)strdup(yytext); return DOTLENGHT;}
public                          {initCol=column; column+=yyleng; if(flag==1) printf("PUBLIC\n"); yylval.charvalue=(char*)strdup(yytext); return PUBLIC;}
return                          {initCol=column; column+=yyleng; if(flag==1) printf("RETURN\n"); yylval.charvalue=(char*)strdup(yytext); return RETURN;}
static                          {initCol=column; column+=yyleng; if(flag==1) printf("STATIC\n"); yylval.charvalue=(char*)strdup(yytext); return STATIC;}
String                          {initCol=column; column+=yyleng; if(flag==1) printf("STRING\n"); yylval.charvalue=(char*)strdup(yytext); return STRING;}
void                            {initCol=column; column+=yyleng; if(flag==1) printf("VOID\n"); yylval.charvalue=(char*)strdup(yytext); return VOID;}
while                           {initCol=column; column+=yyleng; if(flag==1) printf("WHILE\n"); yylval.charvalue=(char*)strdup(yytext); return WHILE;}
int                             {initCol=column; column+=yyleng; if(flag==1) printf("INT\n"); yylval.charvalue=(char*)strdup(yytext); return INT;}
double                          {initCol=column; column+=yyleng; if(flag==1) printf("DOUBLE\n"); yylval.charvalue=(char*)strdup(yytext); return DOUBLE;}
if                              {initCol=column; column+=yyleng; if(flag==1) printf("IF\n"); yylval.charvalue=(char*)strdup(yytext); return IF;}
else                            {initCol=column; column+=yyleng; if(flag==1) printf("ELSE\n"); yylval.charvalue=(char*)strdup(yytext); return ELSE;}
boolean                         {initCol=column; column+=yyleng; if(flag==1) printf("BOOL\n"); yylval.charvalue=(char*)strdup(yytext); return BOOL;}
class                           {initCol=column; column+=yyleng; if(flag==1) printf("CLASS\n"); yylval.charvalue=(char*)strdup(yytext); return CLASS;}
(true|false)                    {initCol=column; column+=yyleng; if(flag==1) printf("BOOLLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return BOOLLIT;}
==                              {initCol=column; column+=yyleng; if(flag==1) printf("EQ\n"); yylval.charvalue=(char*)strdup(yytext); return EQ;}
=                               {initCol=column; column+=yyleng; if(flag==1) printf("ASSIGN\n"); yylval.charvalue=(char*)strdup(yytext); return ASSIGN;}
","                             {initCol=column; column+=yyleng; if(flag==1) printf("COMMA\n"); yylval.charvalue=(char*)strdup(yytext); return COMMA;}
"/"                             {initCol=column; column+=yyleng; if(flag==1) printf("DIV\n"); yylval.charvalue=(char*)strdup(yytext); return DIV;}
">>"                            {initCol=column; column+=yyleng; if(flag==1) printf("RSHIFT\n"); yylval.charvalue=(char*)strdup(yytext); return RSHIFT;}
"<<"                            {initCol=column; column+=yyleng; if(flag==1) printf("LSHIFT\n"); yylval.charvalue=(char*)strdup(yytext); return LSHIFT;}
"^"                             {initCol=column; column+=yyleng; if(flag==1) printf("XOR\n"); yylval.charvalue=(char*)strdup(yytext); return XOR;}
">="                            {initCol=column; column+=yyleng; if(flag==1) printf("GE\n"); yylval.charvalue=(char*)strdup(yytext); return GE;}
">"                             {initCol=column; column+=yyleng; if(flag==1) printf("GT\n"); yylval.charvalue=(char*)strdup(yytext); return GT;}
"<="                            {initCol=column; column+=yyleng; if(flag==1) printf("LE\n"); yylval.charvalue=(char*)strdup(yytext); return LE;}
"<"                             {initCol=column; column+=yyleng; if(flag==1) printf("LT\n"); yylval.charvalue=(char*)strdup(yytext); return LT;}
"-"                             {initCol=column; column+=yyleng; if(flag==1) printf("MINUS\n"); yylval.charvalue=(char*)strdup(yytext); return MINUS;}
"%"                             {initCol=column; column+=yyleng; if(flag==1) printf("MOD\n"); yylval.charvalue=(char*)strdup(yytext); return MOD;}
"!="                            {initCol=column; column+=yyleng; if(flag==1) printf("NE\n"); yylval.charvalue=(char*)strdup(yytext); return NE;}
"!"                             {initCol=column; column+=yyleng; if(flag==1) printf("NOT\n"); yylval.charvalue=(char*)strdup(yytext); return NOT;}
"||"                            {initCol=column; column+=yyleng; if(flag==1) printf("OR\n"); yylval.charvalue=(char*)strdup(yytext); return OR;}
"+"                             {initCol=column; column+=yyleng; if(flag==1) printf("PLUS\n"); yylval.charvalue=(char*)strdup(yytext); return PLUS;}
";"                             {initCol=column; column+=yyleng; if(flag==1) printf("SEMICOLON\n"); yylval.charvalue=(char*)strdup(yytext); return SEMICOLON;}
"*"                             {initCol=column; column+=yyleng; if(flag==1) printf("STAR\n"); yylval.charvalue=(char*)strdup(yytext); return STAR;}
"->"                            {initCol=column; column+=yyleng; if(flag==1) printf("ARROW\n"); yylval.charvalue=(char*)strdup(yytext); return ARROW;}
"&&"                            {initCol=column; column+=yyleng; if(flag==1) printf("AND\n"); yylval.charvalue=(char*)strdup(yytext); return AND;}
"{"                             {initCol=column; column+=yyleng; if(flag==1) printf("LBRACE\n"); yylval.charvalue=(char*)strdup(yytext); return LBRACE;}
"}"                             {initCol=column; column+=yyleng; if(flag==1) printf("RBRACE\n"); yylval.charvalue=(char*)strdup(yytext); return RBRACE;}
"("                             {initCol=column; column+=yyleng; if(flag==1) printf("LPAR\n"); yylval.charvalue=(char*)strdup(yytext); return LPAR;}
")"                             {initCol=column; column+=yyleng; if(flag==1) printf("RPAR\n"); yylval.charvalue=(char*)strdup(yytext); return RPAR;}
"["                             {initCol=column; column+=yyleng; if(flag==1) printf("LSQ\n"); yylval.charvalue=(char*)strdup(yytext); return LSQ;}
"]"                             {initCol=column; column+=yyleng; if(flag==1) printf("RSQ\n"); yylval.charvalue=(char*)strdup(yytext); return RSQ;}
{reserved}                      {initCol=column; column+=yyleng; if(flag==1) printf("RESERVED(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return RESERVED;}
\"                              {BEGIN (STRINGFLAG); lString=line; cString=column; printString = yytext; column+=yyleng;}
"/*"                            {lComment = line; cComment = column; BEGIN (COMMENT); column+=yyleng; initCol=column;}
("_"|"$"|{letters})("_"|"$"|{letters}|{number0})*           {initCol=column; column+=yyleng; if(flag==1) printf("ID(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return ID;}
(0|{integer})                                               {initCol=column; column+=yyleng; if(flag==1) printf("INTLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return INTLIT;}
{integer0}"."{integer0}?{exp}?                              {initCol=column; column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}
"."{integer0}{exp}?                                         {initCol=column; column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}
{integer0}{exp}                                             {initCol=column; column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}


(.)                             {if (flag == 1 || flag == 2 || flag == 0) printf("Line %d, col %d: illegal character (%s)\n",line,column,yytext); column+=yyleng;}
%%


int yywrap(){
    return 1;
}

void yyerror (const char *s) {
    if (flag == 0 || flag == 3) {
        printf ("Line %d, col %d: %s: %s\n", line, initCol, s, yytext);
    }
}

int main(int argc, char *argv[]){
    int x;
    if(argc > 1){
        if(strcmp(argv[1],"-l")==0){
            flag = 1;
            x = -1;
            while(x!=0){
                x = yylex();
            }
        }
        else if(strcmp(argv[1],"-e1")==0){
            flag = 2;
            x = -1;
            while(x!=0){
                x = yylex();
            }
        }
        else if(strcmp(argv[1],"-t")==0){
            flag = 3;
            yyparse();
        }
        else if(strcmp(argv[1],"-e2")==0){
            flag = 0;
            yyparse();
        }
        else{
            yyparse();
        }
    }
    else{
        flag = 0;
        yyparse();
    }
    
    return 0;
}
