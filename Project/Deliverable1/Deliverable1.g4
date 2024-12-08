grammar Deliverable1;

start: statement+;
statement: assignment | arithmetic;

assignment:
      LETTER ASSIGN arithmetic
    | LETTER MINUS_EQ arithmetic
    | LETTER PLUS_EQ arithmetic
    | LETTER MULT_EQ arithmetic
    | LETTER DIV_EQ arithmetic
    ;

arithmetic:
      arithmetic ('+'|'-') arithmetic
    | arithmetic ('*'|'/') arithmetic
    | arithmetic '%' arithmetic
    | '(' arithmetic ')'
    | NUMBER
    | LETTER
    | STRING
    | CHAR
    | array
    | BOOL
    ;

array: '[' elements ']';

elements: arithmetic (',' arithmetic)*;

ASSIGN: '=';
MULT: '*';
MULT_EQ: '*=';
DIV: '/';
DIV_EQ: '/=';
PLUS: '+';
PLUS_EQ: '+=';
MINUS: '-';
MINUS_EQ: '-=';
MOD: '%';

LETTER: [a-zA-Z_][a-zA-Z_0-9]*;
NUMBER: [0-9]+ ('.' [0-9]+)?;
STRING: '"' (~["\r\n])* '"';
CHAR: '\'' (~['\r\n])* '\'';
BOOL: 'True' | 'False';
WHITESPACE: [ \t\r\n]+ -> skip;