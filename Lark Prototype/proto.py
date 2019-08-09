#!/usr/bin/env python3

import sys

from lark import Lark

aspCoreParser = Lark(r'''
s : program | "^"
program : statements
|         query
|         statements query
statements : statements statement
|            statement
statement : CONS body DOT
          | CONS DOT
          | head CONS DOT
          | head CONS body DOT
          | head DOT
          | WCONS body DOT SQUARE_OPEN weight_at_level SQUARE_CLOSE
          | WCONS DOT SQUARE_OPEN weight_at_level SQUARE_CLOSE
          | optimize DOT

query : classical_literal QUERY_MARK

head : disjunction | choice

body : naf_literal
|      aggregate
|      NAF aggregate
|      body COMMA naf_literal
|      body COMMA aggregate
|      body COMMA NAF aggregate

disjunction : disjunction OR classical_literal
|             classical_literal

choice : CURLY_OPEN choice_elements CURLY_CLOSE binop term
|        CURLY_OPEN CURLY_CLOSE binop term
|        CURLY_OPEN CURLY_CLOSE
|        CURLY_OPEN choice_elements CURLY_CLOSE
|        term binop CURLY_OPEN choice_elements CURLY_CLOSE
|        term binop CURLY_OPEN CURLY_CLOSE binop term
|        term binop CURLY_OPEN CURLY_CLOSE
|        term binop CURLY_OPEN choice_elements CURLY_CLOSE binop term

choice_elements : choice_elements SEMICOLON choice_element
|                 choice_element

choice_element : classical_literal COLON naf_literal
|               classical_literal COLON
|               classical_literal

aggregate : aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE binop term
|        aggregate_function CURLY_OPEN CURLY_CLOSE binop term
|        aggregate_function CURLY_OPEN CURLY_CLOSE
|        aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE
|        term binop aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE
|        term binop aggregate_function CURLY_OPEN CURLY_CLOSE binop term
|        term binop aggregate_function CURLY_OPEN CURLY_CLOSE
|        term binop aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE binop term

aggregate_elements : aggregate_elements SEMICOLON aggregate_element
|                    aggregate_element

aggregate_element : terms COLON naf_literals
|                   terms
|                   terms COLON
|                   COLON
|                   COLON naf_literals

aggregate_function : AGGREGATE_COUNT | AGGREGATE_MAX | AGGREGATE_MIN | AGGREGATE_SUM

optimize : optimize_function CURLY_OPEN optimize_elements CURLY_CLOSE
|          optimize_function CURLY_OPEN CURLY_CLOSE

optimize_function : MAXIMIZE | MINIMIZE

optimize_elements : optimize_elements SEMICOLON optimize_element 
|                   optimize_element

optimize_element : weight_at_level COLON naf_literals
|                  weight_at_level COLON
|                  weight_at_level

weight_at_level : term AT term COMMA terms
|                 term AT term
|                 term


naf_literals : naf_literals COMMA naf_literal 
|              naf_literal

naf_literal : classical_literal
|             NAF classical_literal
|             builtin_atom

classical_literal : MINUS ID PAREN_OPEN terms PAREN_CLOSE
|                   ID PAREN_OPEN terms PAREN_CLOSE
|                   MINUS ID
|                   MINUS ID PAREN_OPEN PAREN_CLOSE
|                   ID PAREN_OPEN PAREN_CLOSE
|                   ID


builtin_atom : term binop term

binop : EQUAL | UNEQUAL | LESS | GREATER | LESS_OR_EQ | GREATER_OR_EQ

terms : terms COMMA term | term

term : ID PAREN_OPEN terms PAREN_CLOSE
|      ID PAREN_OPEN PAREN_CLOSE
|      ID
|      NUMBER
|      STRING
|      VARIABLE
|      ANONYMOUS_VARIABLE
|      PAREN_OPEN term PAREN_CLOSE
|      MINUS term


arithop : PLUS | MINUS | TIMES | DIV

ID: /[a-z][A-Za-z0-9_]*/
VARIABLE: /[A-Z][A-Za-z0-9_]*/
STRING: "\"" ("\\\""|/[^"]/)* "\""
NUMBER: "0"|/[1-9][0-9]*/
ANONYMOUS_VARIABLE: "_"
DOT: "."
COMMA: ","
QUERY_MARK: "?"
COLON: ":"
SEMICOLON: ";"
OR: "|"
NAF: "not"
CONS: ":-"
WCONS: ":~"
PLUS: "+"
MINUS: "-"
TIMES: "*"
DIV: "/"
AT: "@"
PAREN_OPEN: "("
PAREN_CLOSE: ")"
SQUARE_OPEN: "["
SQUARE_CLOSE: "]"
CURLY_OPEN: "{"
CURLY_CLOSE: "}"
EQUAL: "="
UNEQUAL: "<>"|"!="
LESS: "<"
GREATER: ">"
LESS_OR_EQ: "<="
GREATER_OR_EQ: ">="
AGGREGATE_COUNT: "#count"
AGGREGATE_MAX: "#max"
AGGREGATE_MIN: "#min"
AGGREGATE_SUM: "#sum"
MINIMIZE: "#minimi" /[zs]/ "e"
MAXIMIZE: "#maximi" /[zs]/ "e"
COMMENT: "%" /([^*\n][^\n]*)?\n/
MULTI_LINE_COMMENT: "%*" /([^*]|\*[^%])/* "*%"
BLANK: /[ \t\n]/+

%ignore COMMENT
%ignore MULTI_LINE_COMMENT
%ignore BLANK
''', start="s", parser='lalr',debug=True)

print (aspCoreParser.parse(sys.stdin.read()).pretty())