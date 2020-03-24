/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    STRLIT = 259,
    BOOLLIT = 260,
    PRINT = 261,
    PARSEINT = 262,
    DOTLENGHT = 263,
    PUBLIC = 264,
    RETURN = 265,
    STATIC = 266,
    STRING = 267,
    VOID = 268,
    WHILE = 269,
    INT = 270,
    DOUBLE = 271,
    IF = 272,
    ELSE = 273,
    BOOL = 274,
    CLASS = 275,
    EQ = 276,
    ASSIGN = 277,
    COMMA = 278,
    DIV = 279,
    RSHIFT = 280,
    LSHIFT = 281,
    XOR = 282,
    GE = 283,
    GT = 284,
    LE = 285,
    LT = 286,
    MINUS = 287,
    MOD = 288,
    NE = 289,
    NOT = 290,
    OR = 291,
    PLUS = 292,
    SEMICOLON = 293,
    STAR = 294,
    ARROW = 295,
    AND = 296,
    LBRACE = 297,
    RBRACE = 298,
    LPAR = 299,
    RPAR = 300,
    LSQ = 301,
    RSQ = 302,
    RESERVED = 303,
    INTLIT = 304,
    REALLIT = 305
  };
#endif
/* Tokens.  */
#define ID 258
#define STRLIT 259
#define BOOLLIT 260
#define PRINT 261
#define PARSEINT 262
#define DOTLENGHT 263
#define PUBLIC 264
#define RETURN 265
#define STATIC 266
#define STRING 267
#define VOID 268
#define WHILE 269
#define INT 270
#define DOUBLE 271
#define IF 272
#define ELSE 273
#define BOOL 274
#define CLASS 275
#define EQ 276
#define ASSIGN 277
#define COMMA 278
#define DIV 279
#define RSHIFT 280
#define LSHIFT 281
#define XOR 282
#define GE 283
#define GT 284
#define LE 285
#define LT 286
#define MINUS 287
#define MOD 288
#define NE 289
#define NOT 290
#define OR 291
#define PLUS 292
#define SEMICOLON 293
#define STAR 294
#define ARROW 295
#define AND 296
#define LBRACE 297
#define RBRACE 298
#define LPAR 299
#define RPAR 300
#define LSQ 301
#define RSQ 302
#define RESERVED 303
#define INTLIT 304
#define REALLIT 305

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 11 "jucompiler.y" /* yacc.c:1909  */

char* charvalue;
int intvalue;
float realvalue;

#line 160 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
