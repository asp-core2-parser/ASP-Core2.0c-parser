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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
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
    VARIABLE = 259,
    STRING = 260,
    NUMBER = 261,
    ANONYMOUS_VARIABLE = 262,
    DOT = 263,
    COMMA = 264,
    QUERY_MARK = 265,
    COLON = 266,
    SEMICOLON = 267,
    OR = 268,
    NAF = 269,
    CONS = 270,
    WCONS = 271,
    PLUS = 272,
    MINUS = 273,
    TIMES = 274,
    DIV = 275,
    AT = 276,
    PAREN_OPEN = 277,
    PAREN_CLOSE = 278,
    SQUARE_OPEN = 279,
    SQUARE_CLOSE = 280,
    CURLY_OPEN = 281,
    CURLY_CLOSE = 282,
    EQUAL = 283,
    UNEQUAL = 284,
    LESS = 285,
    GREATER = 286,
    LESS_OR_EQ = 287,
    GREATER_OR_EQ = 288,
    AGGREGATE_COUNT = 289,
    AGGREGATE_MAX = 290,
    AGGREGATE_MIN = 291,
    AGGREGATE_SUM = 292,
    MINIMIZE = 293,
    MAXIMIZE = 294,
    COMMENT = 295,
    MULTI_LINE_COMMENT = 296,
    BLANK = 297
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "parser.y" /* yacc.c:1909  */

    char single;
    char string[50];
    double number;

#line 103 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
