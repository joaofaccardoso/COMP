lower                                                           [a-z]
upper                                                           [A-Z]
numero                                                          [0-9]
%%
"\""(("\\""\""(lower|upper|numero)*"\\""\"")|(lower|upper|numero)*)"\""     {printf("STRLIT\n");}
static                                                          {printf("STATIC\n");}
public                                                          {printf("PUBLIC\n");}
return                                                          {printf("RETURN\n");}
void                                                            {printf("VOID\n");}
while                                                           {printf("WHILE\n");}
String                                                          {printf("STRING\n");}
boolean                                                         {printf("BOOL\n");}
class                                                           {printf("CLASS\n");}
"."length                                                       {printf("DOTLENGTH\n");}
double                                                          {printf("DOUBLE\n");}
else                                                            {printf("ELSE\n");}
if                                                              {printf("IF\n");}
int                                                             {printf("INT\n");}
System.out.print                                                {printf("PRINT\n");}
Integer.parseInt                                                {printf("PARSEINT\n");}
(true|false)                                                    {printf("BOOLIT\n");}
"&&"                                                            {printf("AND\n");}
"<<"                                                            {printf("LSHIFT\n");}
">>"                                                            {printf("RSHIFT\n");}
">="                                                            {printf("GE\n");}
">"                                                             {printf("GT\n");}
"<="                                                            {printf("LE\n");}
"<"                                                             {printf("LT\n");}
"!="                                                            {printf("NE\n");}
"!"                                                             {printf("NOT\n");}
"||"                                                            {printf("OR\n");}
"+"                                                             {printf("PLUS\n");}
"->"                                                            {printf("ARROW\n");}
"^"                                                             {printf("XOR\n");}
","                                                             {printf("COMMA\n");}
";"                                                             {printf("SEMICOLON\n");}
"*"                                                             {printf("STAR\n");}
"/"                                                             {printf("DIV\n");}
"-"                                                             {printf("MINUS\n");}
"%"                                                             {printf("MOD\n");}
"{"                                                             {printf("LBRACE\n");}
"}"                                                             {printf("RBRACE\n");}
"("                                                             {printf("LPAR\n");}
")"                                                           {printf("RPAR\n");}
"["                                                             {printf("LSQ\n");}
"]"                                                             {printf("RSQ\n");}
({lower}|{upper}|{numero}|_|$)+                                 {printf("ID\n");}
==                                                              {printf("EQ\n");}
=                                                               {printf("ASSIGN\n");}

%% 

int main()
{
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
