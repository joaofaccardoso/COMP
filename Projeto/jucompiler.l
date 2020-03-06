letters                 [a-zA-Z]
number                  [1-9]
number0                 [0-9]
scape                   \\[n|f|r|t|\\|\"]
integer                 {number}(_*{number0}+)*
integer0                {number0}(_*{number0}+)*
exp                     (e|E)("+"|"-")?{integer0}+
%{
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
%X COMMENT STRING
%%
<COMMENT>(\n|\r|\r\n)           {column=1; line++;}
<COMMENT>"*/"                   {lComment = 0; cComment = 0; BEGIN 0; column+=yyleng;}
<COMMENT>.                      {column++;}

<STRING>(\n|\r|\r\n)            {if(flag==1 || flag == 2) printf("Line %d, col %d: unterminated string literal\n",lString,cString); column=1; line++; BEGIN 0; string=1;}     
<STRING>{scape}                 {column+=yyleng;}
<STRING>\\.                     {if(flag==1 || flag==2) printf("Line %d, col %d: invalid escape sequence (%s)\n",line,column,yytext); column+=yyleng; string=1;}
<STRING>\"                      {column+=yyleng; if(flag==1 && string==0) printf("STRLIT(%s)\n",printString); BEGIN 0; string=0;}     
<STRING>(.)                     {column+=yyleng;}

\/\/([^\r\n])*                  {;}
(\n|\r|\r\n)                    {column=1; line++;}
System"."out"."print            {column+=yyleng; if(flag==1) printf("PRINT\n");}
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
boolean                         {column+=yyleng; if(flag==1) printf("BOOL\n");}
class                           {column+=yyleng; if(flag==1) printf("CLASS\n");}
(true|false)                    {column+=yyleng; if(flag==1) printf("BOOLLIT(%s)\n",yytext);}
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
"&&"                            {column+=yyleng; if(flag==1) printf("AND\n");}
"{"                             {column+=yyleng; if(flag==1) printf("LBRACE\n");}
"}"                             {column+=yyleng; if(flag==1) printf("RBRACE\n");}
"("                             {column+=yyleng; if(flag==1) printf("LPAR\n");}
")"                             {column+=yyleng; if(flag==1) printf("RPAR\n");}
"["                             {column+=yyleng; if(flag==1) printf("LSQ\n");}
"]"                             {column+=yyleng; if(flag==1) printf("RSQ\n");}
(float|Integer|System|null|"++"|"--"|abstract|assert|break|byte|case|catch|char|const|continue|default|do|enum|extends|final|finally|for|goto|implements|import|instanceof|interface|long|native|new|package|private|protected|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|volatile)                {column+=yyleng; if(flag==1) printf("RESERVED(%s)\n",yytext);}
\"                              {BEGIN (STRING); lString=line; cString=column; printString = yytext; column+=yyleng;}
"/*"                            {lComment = line; cComment = column; BEGIN (COMMENT); column+=yyleng;}
("_"|"$"|{letters})("_"|"$"|{letters}|{number0})*           {column+=yyleng; if(flag==1) printf("ID(%s)\n",yytext);}
(0|{integer})                                               {column+=yyleng; if(flag==1) printf("INTLIT(%s)\n",yytext);}
{integer0}"."{integer0}?{exp}?(f|F|d|D)?                      {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext);}
"."{integer0}{exp}?(f|F|d|D)?                      {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext);}
{integer0}({exp}?(f|F|d|D)|{exp}(f|F|d|D)?)                      {column+=yyleng; if(flag==1) printf("REALLIT(%s)\n",yytext);}


(.) {column++;}
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
        printf("Line %d, col %d: unterminated comment\n",lComment,cComment);
    }

    // printf("lines: %d\n",line);
    return 0;
}

int yywrap()
{
    return 1;
}
