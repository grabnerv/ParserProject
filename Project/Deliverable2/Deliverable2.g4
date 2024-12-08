grammar Deliverable2;

start
    : statement+ EOF
    ;

statement
    : one_liner NEWLINE
    | compound_statement
    | INDENT one_liner NEWLINE
    ;

one_liner
    : assignment
    | arithmetic
    ;

compound_statement
    : if_stmt
    ;

assignment
    : LETTER ASSIGN arithmetic
    | LETTER MINUS_EQ arithmetic
    | LETTER PLUS_EQ arithmetic
    | LETTER MULT_EQ arithmetic
    | LETTER DIV_EQ arithmetic
    ;

arithmetic
    : arithmetic ('+' | '-') arithmetic
    | arithmetic ('*' | '/') arithmetic
    | arithmetic '%' arithmetic
    | '(' arithmetic ')'
    | NUMBER
    | LETTER
    | STRING
    | CHAR
    | array
    | BOOL
    ;

array
    : '[' elements ']'
    ;

elements
    : arithmetic (',' arithmetic)*
    ;

if_stmt
    : IF expr COLON NEWLINE INDENT statement+ DEDENT
      (ELIF expr COLON NEWLINE INDENT statement+ DEDENT)*
      (ELSE COLON NEWLINE INDENT statement+ DEDENT)?
    ;

expr
    : expr AND expr
    | expr OR expr
    | NOT expr
    | arithmetic comparison_operator arithmetic
    | arithmetic
    | BOOL
    | '(' expr ')'
    ;

comparison_operator
    : LESS
    | LESS_EQUAL
    | GREATER
    | GREATER_EQUAL
    | EQUALS
    | NOT_EQUALS
    ;

// Lexer rules
ASSIGN: '=';
PLUS_EQ: '+=';
MINUS_EQ: '-=';
MULT_EQ: '*=';
DIV_EQ: '/=';

PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
MOD: '%';

IF: 'if';
ELIF: 'elif';
ELSE: 'else';
AND: 'and';
OR: 'or';
NOT: 'not';
COLON: ':';
LESS: '<';
LESS_EQUAL: '<=';
GREATER: '>';
GREATER_EQUAL: '>=';
EQUALS: '==';
NOT_EQUALS: '!=';

LETTER: [a-zA-Z_][a-zA-Z_0-9]*;
NUMBER: [0-9]+ ('.' [0-9]+)?;
STRING: '"' (~["\r\n])* '"';
CHAR: '\'' (~['\r\n])* '\'';
BOOL: 'True' | 'False';

// Handle newlines and indentation
NEWLINE
    : [\r\n]+
    ;

INDENT
    : '    ' // Matches exactly four spaces
    ;

DEDENT
    : '<<<DEDENT>>>'
    ;

// Skip whitespace
WHITESPACE
    : [ \t]+ -> skip
    ;
