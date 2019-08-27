grammar ASPCore2_0c;

program : statements <EOF> | query <EOF> | statements query <EOF> | <EOF>;
statements : statement*;
query : classical_literal QUERY_MARK;
statement : CONS  body? DOT
          | head  (CONS  body?)? DOT
          | WCONS  body? DOT SQUARE_OPEN weight_at_level SQUARE_CLOSE
          | optimize DOT;
head : disjunction | choice;
body : (naf_literal |  NAF? aggregate)  (COMMA body)?;
disjunction :  classical_literal (OR disjunction)?;
choice :  (term binop)? CURLY_OPEN  choice_elements? CURLY_CLOSE  (binop term)?;
choice_elements : choice_element (SEMICOLON choice_elements)?;
choice_element : classical_literal  (COLON  naf_literals?)?;
aggregate :  (term binop)? aggregate_function CURLY_OPEN  aggregate_elements? CURLY_CLOSE  (binop term)?;
aggregate_elements :  aggregate_element (SEMICOLON aggregate_elements)?;
aggregate_element :  terms?  (COLON  naf_literals?)?;
aggregate_function : AGGREGATE_COUNT | AGGREGATE_MAX | AGGREGATE_MIN | AGGREGATE_SUM;
optimize : optimize_function CURLY_OPEN  optimize_elements? CURLY_CLOSE;
optimize_elements : optimize_element (SEMICOLON optimize_elements)?;
optimize_element : weight_at_level  (COLON  naf_literals?)?;
optimize_function : MAXIMIZE | MINIMIZE;
weight_at_level : term  (AT term)?  (COMMA terms)?;
naf_literals :  naf_literal (COMMA naf_literals)?;
naf_literal :  NAF? classical_literal | builtin_atom;
classical_literal :  MINUS? ID  (PAREN_OPEN  terms? PAREN_CLOSE)?;
builtin_atom : term binop term;
binop : EQUAL | UNEQUAL | LESS | GREATER | LESS_OR_EQ | GREATER_OR_EQ;
terms :  term (COMMA terms)?;
term : ID  (PAREN_OPEN  terms? PAREN_CLOSE)?
     | NUMBER
     | STRING
     | VARIABLE
     | ANONYMOUS_VARIABLE
     | PAREN_OPEN term PAREN_CLOSE
     | MINUS term
     | term arithop term;
arithop : PLUS
        | MINUS
        | TIMES
        | DIV;

NAF: 'not';
ID: [a-z][A-Za-z0-9_]*;
VARIABLE: [A-Z]([A-Za-z0-9_]*);
STRING: '"'.*?'"';
NUMBER: '0'|[1-9][0-9]*;
ANONYMOUS_VARIABLE: '_';
DOT: '.';
COMMA: ',';
QUERY_MARK: '?';
COLON: ':';
SEMICOLON: ';';
OR: '|';
CONS: ':-';
WCONS: ':~';
PLUS: '+';
MINUS: '-';
TIMES: '*';
DIV: '/';
AT: '@';
PAREN_OPEN: '(';
PAREN_CLOSE: ')';
SQUARE_OPEN: '[';
SQUARE_CLOSE: ']';
CURLY_OPEN: '{';
CURLY_CLOSE: '}';
EQUAL: '=';
UNEQUAL: '<>'|'!=';
LESS: '<';
GREATER: '>';
LESS_OR_EQ: '<=';
GREATER_OR_EQ: '>=';
AGGREGATE_COUNT: '#count';
AGGREGATE_MAX: '#max';
AGGREGATE_MIN: '#min';
AGGREGATE_SUM: '#sum';
MINIMIZE: '#minimi' [zs] 'e';
MAXIMIZE: '#maximi' [zs] 'e';
COMMENT
    : '%*' .*? '*%' -> skip
;

LINE_COMMENT
    : '%' ~[\r\n]* -> skip
;
BLANK: [ \t\n]+ -> skip;