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
char * printString;
%}
%X COMMENT STRINGFLAG
%%
<COMMENT>"*/"                   {BEGIN 0; column+=yyleng;}
<COMMENT>(\n|\r|\r\n)           {column=1; line++;}
<COMMENT><<EOF>>                {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated comment\n",lComment,cComment); BEGIN 0;}
<COMMENT>.                      {column+=yyleng;}

<STRINGFLAG>\"                      {column+=yyleng; if(flag==1 && string==0) printf("STRLIT(%s)\n",printString); BEGIN 0; string=0; yylval.charvalue=(char*)strdup(yytext); return STRING;}
<STRINGFLAG>(\n|\r|\r\n)            {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; string=0; BEGIN 0;}
<STRINGFLAG><<EOF>>                 {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; string=0; BEGIN 0;}
<STRINGFLAG>{escape}                {column+=yyleng;}
<STRINGFLAG>\\.?                    {if(flag==1 || flag == 2 || flag == 0) printf("Line %d, col %d: invalid escape sequence (%s)\n",line,column,yytext); column+=yyleng; string=1;}
<STRINGFLAG>(.)                     {column+=yyleng;}

\/\/([^\r\n])*                  {;}
{whiteSpace}                    {column+=yyleng;}
(\n|\r|\r\n)                    {column=1; line++;}
System"."out"."print            {column+=yyleng; if(flag==1) printf("PRINT\n"); yylval.charvalue=(char*)strdup(yytext); return PRINT;}
Integer"."parseInt              {column+=yyleng; if(flag==1) printf("PARSEINT\n"); yylval.charvalue=(char*)strdup(yytext); return PARSEINT;}
"."length                       {column+=yyleng; if(flag==1) printf("DOTLENGHT\n"); yylval.charvalue=(char*)strdup(yytext); return DOTLENGHT;}
public                          {column+=yyleng; if(flag==1) printf("PUBLIC\n"); yylval.charvalue=(char*)strdup(yytext); return PUBLIC;}
return                          {column+=yyleng; if(flag==1) printf("RETURN\n"); yylval.charvalue=(char*)strdup(yytext); return RETURN;}
static                          {column+=yyleng; if(flag==1) printf("STATIC\n"); yylval.charvalue=(char*)strdup(yytext); return STATIC;}
String                          {column+=yyleng; if(flag==1) printf("STRING\n"); yylval.charvalue=(char*)strdup(yytext); return STRING;}
void                            {column+=yyleng; if(flag==1) printf("VOID\n"); yylval.charvalue=(char*)strdup(yytext); return VOID;}
while                           {column+=yyleng; if(flag==1) printf("WHILE\n"); yylval.charvalue=(char*)strdup(yytext); return WHILE;}
int                             {column+=yyleng; if(flag==1) printf("INT\n"); yylval.charvalue=(char*)strdup(yytext); return INT;}
double                          {column+=yyleng; if(flag==1) printf("DOUBLE\n"); yylval.charvalue=(char*)strdup(yytext); return DOUBLE;}
if                              {column+=yyleng; if(flag==1) printf("IF\n"); yylval.charvalue=(char*)strdup(yytext); return IF;}
else                            {column+=yyleng; if(flag==1) printf("ELSE\n"); yylval.charvalue=(char*)strdup(yytext); return ELSE;}
boolean                         {column+=yyleng; if(flag==1) printf("BOOL\n"); yylval.charvalue=(char*)strdup(yytext); return BOOL;}
class                           {column+=yyleng; if(flag==1) printf("CLASS\n"); yylval.charvalue=(char*)strdup(yytext); return CLASS;}
(true|false)                    {column+=yyleng; if(flag==1) printf("BOOLLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return BOOLLIT;}
==                              {column+=yyleng; if(flag==1) printf("EQ\n"); yylval.charvalue=(char*)strdup(yytext); return EQ;}
=                               {column+=yyleng; if(flag==1) printf("ASSIGN\n"); yylval.charvalue=(char*)strdup(yytext); return ASSIGN;}
","                             {column+=yyleng; if(flag==1) printf("COMMA\n"); yylval.charvalue=(char*)strdup(yytext); return COMMA;}
"/"                             {column+=yyleng; if(flag==1) printf("DIV\n"); yylval.charvalue=(char*)strdup(yytext); return DIV;}
">>"                            {column+=yyleng; if(flag==1) printf("RSHIFT\n"); yylval.charvalue=(char*)strdup(yytext); return RSHIFT;}
"<<"                            {column+=yyleng; if(flag==1) printf("LSHIFT\n"); yylval.charvalue=(char*)strdup(yytext); return LSHIFT;}
"^"                             {column+=yyleng; if(flag==1) printf("XOR\n"); yylval.charvalue=(char*)strdup(yytext); return XOR;}
">="                            {column+=yyleng; if(flag==1) printf("GE\n"); yylval.charvalue=(char*)strdup(yytext); return GE;}
">"                             {column+=yyleng; if(flag==1) printf("GT\n"); yylval.charvalue=(char*)strdup(yytext); return GT;}
"<="                            {column+=yyleng; if(flag==1) printf("LE\n"); yylval.charvalue=(char*)strdup(yytext); return LE;}
"<"                             {column+=yyleng; if(flag==1) printf("LT\n"); yylval.charvalue=(char*)strdup(yytext); return LT;}
"-"                             {column+=yyleng; if(flag==1) printf("MINUS\n"); yylval.charvalue=(char*)strdup(yytext); return MINUS;}
"%"                             {column+=yyleng; if(flag==1) printf("MOD\n"); yylval.charvalue=(char*)strdup(yytext); return MOD;}
"!="                            {column+=yyleng; if(flag==1) printf("NE\n"); yylval.charvalue=(char*)strdup(yytext); return NE;}
"!"                             {column+=yyleng; if(flag==1) printf("NOT\n"); yylval.charvalue=(char*)strdup(yytext); return NOT;}
"||"                            {column+=yyleng; if(flag==1) printf("OR\n"); yylval.charvalue=(char*)strdup(yytext); return OR;}
"+"                             {column+=yyleng; if(flag==1) printf("PLUS\n"); yylval.charvalue=(char*)strdup(yytext); return PLUS;}
";"                             {column+=yyleng; if(flag==1) printf("SEMICOLON\n"); yylval.charvalue=(char*)strdup(yytext); return SEMICOLON;}
"*"                             {column+=yyleng; if(flag==1) printf("STAR\n"); yylval.charvalue=(char*)strdup(yytext); return STAR;}
"->"                            {column+=yyleng; if(flag==1) printf("ARROW\n"); yylval.charvalue=(char*)strdup(yytext); return ARROW;}
"&&"                            {column+=yyleng; if(flag==1) printf("AND\n"); yylval.charvalue=(char*)strdup(yytext); return AND;}
"{"                             {column+=yyleng; if(flag==1) printf("LBRACE\n"); yylval.charvalue=(char*)strdup(yytext); return LBRACE;}
"}"                             {column+=yyleng; if(flag==1) printf("RBRACE\n"); yylval.charvalue=(char*)strdup(yytext); return RBRACE;}
"("                             {column+=yyleng; if(flag==1) printf("LPAR\n"); yylval.charvalue=(char*)strdup(yytext); return LPAR;}
")"                             {column+=yyleng; if(flag==1) printf("RPAR\n"); yylval.charvalue=(char*)strdup(yytext); return RPAR;}
"["                             {column+=yyleng; if(flag==1) printf("LSQ\n"); yylval.charvalue=(char*)strdup(yytext); return LSQ;}
"]"                             {column+=yyleng; if(flag==1) printf("RSQ\n"); yylval.charvalue=(char*)strdup(yytext); return RSQ;}
{reserved}                      {column+=yyleng; if(flag==1) printf("RESERVED(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return RESERVED;}
\"                              {BEGIN (STRINGFLAG); lString=line; cString=column; printString = yytext; column+=yyleng;}
"/*"                            {lComment = line; cComment = column; BEGIN (COMMENT); column+=yyleng;}
("_"|"$"|{letters})("_"|"$"|{letters}|{number0})*           {column+=yyleng; if(flag==1) printf("ID(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return ID;}
(0|{integer})                                               {column+=yyleng; if(flag==1) printf("INTLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return INTLIT;}
{integer0}"."{integer0}?{exp}?                              {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}
"."{integer0}{exp}?                                         {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}
{integer0}{exp}                                             {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext); yylval.charvalue=(char*)strdup(yytext); return REALLIT;}


(.)                             {if (flag == 1 || flag == 2 || flag == 0) printf("Line %d, col %d: illegal character (%s)\n",line,column,yytext); column+=yyleng;}
%%


int yywrap(){
    return 1;
}

void yyerror (const char *s) {
    if (flag == 0 || flag == 3) {
        printf ("Line %d, col %d: %s: %s\n", line, column-1, s, yytext);
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
