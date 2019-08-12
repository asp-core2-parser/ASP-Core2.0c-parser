%{
    #include <stdio.h>
    #include <stdlib.h>
    extern int yylex(void);
    extern int yylineno;
    extern int yyparse();
    extern int yyerror(char* s);
    extern FILE* yyin;
%}

%token ID VARIABLE STRING NUMBER ANONYMOUS_VARIABLE DOT COMMA QUERY_MARK COLON SEMICOLON OR NAF CONS WCONS PLUS MINUS TIMES DIV AT PAREN_OPEN PAREN_CLOSE SQUARE_OPEN SQUARE_CLOSE CURLY_OPEN CURLY_CLOSE EQUAL UNEQUAL LESS GREATER LESS_OR_EQ GREATER_OR_EQ AGGREGATE_COUNT AGGREGATE_MAX AGGREGATE_MIN AGGREGATE_SUM MINIMIZE MAXIMIZE

%type <number> NUMBER
%type <string> ID VARIABLE NAF CONS WCONS UNEQUAL LESS_OR_EQ GREATER_OR_EQ AGGREGATE_COUNT AGGREGATE_MAX AGGREGATE_MIN AGGREGATE_SUM MINIMIZE MAXIMIZE
%type <single> ANONYMOUS_VARIABLE DOT COMMA QUERY_MARK COLON SEMICOLON OR PLUS MINUS TIMES DIV AT PAREN_OPEN PAREN_CLOSE SQUARE_OPEN SQUARE_CLOSE CURLY_OPEN CURLY_CLOSE EQUAL LESS GREATER

%union{
    char single;
    char string[50];
    double number;
}
%left TIMES DIV
%left PLUS MINUS
%right EQUAL UNEQUAL GREATER LESS GREATER_OR_EQ LESS_OR_EQ
%%
start: program
|
;

program: statements 
|         query 
|         statements query
;

statements: statements statement
|            statement
;

statement: CONS body DOT
          | CONS DOT
          | head CONS DOT
          | head CONS body DOT
          | head DOT
          | WCONS body DOT SQUARE_OPEN weight_at_level SQUARE_CLOSE
          | WCONS DOT SQUARE_OPEN weight_at_level SQUARE_CLOSE
          | optimize DOT
;

query: classical_literal QUERY_MARK
;

head: disjunction | choice
;

body:  naf_literal
|      aggregate
|      NAF aggregate
|      body COMMA naf_literal
|      body COMMA aggregate
|      body COMMA NAF aggregate
;

disjunction: disjunction OR classical_literal
|             classical_literal
;

choice:  CURLY_OPEN CURLY_CLOSE
|        CURLY_OPEN CURLY_CLOSE binop term
|        CURLY_OPEN CURLY_CLOSE binop classical_literal
|        CURLY_OPEN choice_elements CURLY_CLOSE binop term
|	     CURLY_OPEN choice_elements CURLY_CLOSE binop classical_literal
|        CURLY_OPEN choice_elements CURLY_CLOSE
|        term binop CURLY_OPEN CURLY_CLOSE
|        term binop CURLY_OPEN CURLY_CLOSE binop term
|        term binop CURLY_OPEN CURLY_CLOSE binop classical_literal
|        term binop CURLY_OPEN choice_elements CURLY_CLOSE
|        term binop CURLY_OPEN choice_elements CURLY_CLOSE binop term
|        term binop CURLY_OPEN choice_elements CURLY_CLOSE binop classical_literal
|        classical_literal binop CURLY_OPEN CURLY_CLOSE
|        classical_literal binop CURLY_OPEN CURLY_CLOSE binop term
|        classical_literal binop CURLY_OPEN CURLY_CLOSE binop classical_literal
|        classical_literal binop CURLY_OPEN choice_elements CURLY_CLOSE
|        classical_literal binop CURLY_OPEN choice_elements CURLY_CLOSE binop term
|        classical_literal binop CURLY_OPEN choice_elements CURLY_CLOSE binop classical_literal
;

choice_elements: choice_elements SEMICOLON choice_element
|                 choice_element
;

choice_element: classical_literal COLON naf_literal
|               classical_literal COLON
|               classical_literal
;

aggregate:  aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE binop term
|           aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE binop classical_literal
|           aggregate_function CURLY_OPEN CURLY_CLOSE binop term
|           aggregate_function CURLY_OPEN CURLY_CLOSE binop classical_literal
|           aggregate_function CURLY_OPEN CURLY_CLOSE
|           aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE
|           left_binop aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE
|           left_binop aggregate_function CURLY_OPEN CURLY_CLOSE binop term
|           left_binop aggregate_function CURLY_OPEN CURLY_CLOSE binop classical_literal
|           left_binop aggregate_function CURLY_OPEN CURLY_CLOSE
|           left_binop aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE binop term
|           left_binop aggregate_function CURLY_OPEN aggregate_elements CURLY_CLOSE binop classical_literal
;

aggregate_elements: aggregate_elements SEMICOLON aggregate_element
|                    aggregate_element
;

aggregate_element: terms COLON naf_literals
|                   terms
|                   terms COLON
|                   COLON
|                   COLON naf_literals
;

aggregate_function: AGGREGATE_COUNT | AGGREGATE_MAX | AGGREGATE_MIN | AGGREGATE_SUM
;

optimize:  optimize_function CURLY_OPEN optimize_elements CURLY_CLOSE
|          optimize_function CURLY_OPEN CURLY_CLOSE
;

optimize_function:  MAXIMIZE | MINIMIZE
;

optimize_elements:  optimize_elements SEMICOLON optimize_element 
|                   optimize_element
;

optimize_element:  weight_at_level COLON naf_literals
|                  weight_at_level COLON
|                  weight_at_level
;

weight_at_level:  term AT term COMMA terms
|                 term AT classical_literal COMMA terms
|                 term AT term
|                 term AT classical_literal
|                 term
|                 term COMMA terms
|                 classical_literal AT term COMMA terms
|                 classical_literal AT classical_literal COMMA terms
|                 classical_literal AT term
|                 classical_literal AT classical_literal
|                 classical_literal
;

naf_literals: naf_literals COMMA naf_literal 
|              naf_literal
;

naf_literal: classical_literal
|             NAF classical_literal
|             builtin_atom
;

builtin_atom: left_binop term | left_binop classical_literal
;

binop: EQUAL | UNEQUAL | LESS | GREATER | LESS_OR_EQ | GREATER_OR_EQ
;

terms: terms COMMA term 
|       terms COMMA classical_literal
|       term
|       classical_literal
;

term:  NUMBER
|      STRING
|      VARIABLE
|      ANONYMOUS_VARIABLE
|      MINUS NUMBER
|      MINUS STRING
|      MINUS VARIABLE
|      MINUS ANONYMOUS_VARIABLE
|      PAREN_OPEN term PAREN_CLOSE
|      PAREN_OPEN ID PAREN_CLOSE
|      PAREN_OPEN ID PAREN_OPEN PAREN_CLOSE PAREN_CLOSE
|      PAREN_OPEN ID PAREN_OPEN terms PAREN_CLOSE PAREN_CLOSE
|      left_arithop term
|      left_arithop ID
|      left_arithop ID PAREN_OPEN PAREN_CLOSE
|      left_arithop ID PAREN_OPEN terms PAREN_CLOSE
|      left_arithop MINUS classical_literal
;

left_arithop: NUMBER arithop
|      STRING arithop
|      VARIABLE arithop
|      ANONYMOUS_VARIABLE arithop
|      PAREN_OPEN left_arithop PAREN_CLOSE arithop
|      PAREN_OPEN term PAREN_CLOSE arithop
|      ID PAREN_OPEN terms PAREN_CLOSE arithop
|      ID arithop
|      ID PAREN_OPEN PAREN_CLOSE arithop
|      MINUS classical_literal arithop
|      MINUS NUMBER arithop
|      MINUS STRING arithop
|      MINUS VARIABLE arithop
|      MINUS ANONYMOUS_VARIABLE arithop
;


arithop: PLUS | MINUS | TIMES | DIV
;

classical_literal: ID
|   ID PAREN_OPEN PAREN_CLOSE
|   ID PAREN_OPEN terms PAREN_CLOSE
|      MINUS classical_literal
;

left_binop: term binop
|   classical_literal binop
;
%%
int yyerror(char *s){
    printf("%s at line %d \n",s, yylineno);
    return 0;
}

int main(){
    extern int yydebug;
    yydebug = 0;
    yyparse();
    return 0;
}