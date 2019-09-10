lexer grammar ASPCoreLexer;

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
