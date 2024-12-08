grammar Deliverable3;

@lexer::header {
    import java.util.LinkedList;
    import java.util.Queue;
    import java.util.Deque;
}

@lexer::members {
    public static final int INDENT_TOKEN = Deliverable3Parser.INDENT;
    public static final int DEDENT_TOKEN = Deliverable3Parser.DEDENT;
    public static final int NEWLINE_TOKEN = Deliverable3Parser.NEWLINE;
    
    private Queue<Token> tokenQueue = new LinkedList<>();
    private Deque<Integer> indentStack = new LinkedList<>();
    private int currentIndent = 0;
    
    {
        indentStack.push(0);
    }
    
    private Token createToken(int type, String text) {
        CommonToken token = new CommonToken(this._tokenFactorySourcePair, type, DEFAULT_TOKEN_CHANNEL, getCharIndex() - text.length(), getCharIndex());
        token.setLine(getLine());
        token.setCharPositionInLine(getCharPositionInLine());
        token.setText(text);
        return token;
    }
    
    @Override
    public Token nextToken() {
        if (!tokenQueue.isEmpty()) {
            Token next = tokenQueue.poll();
            return next;
        }
        
        Token next = super.nextToken();
        
        if (next.getType() == EOF) {
            while (indentStack.size() > 1) {
                indentStack.pop();
                Token dedent = createToken(DEDENT_TOKEN, "DEDENT");
                tokenQueue.offer(dedent);
            }
            if (!tokenQueue.isEmpty()) {
                return tokenQueue.poll(); 
            }
        }
        
        return next;
    }
}

tokens {
    INDENT,
    DEDENT
}

start
    : NEWLINE* statement* EOF
    ;

statement
    : NEWLINE
    | simple_stmt
    | compound_stmt
    ;

simple_stmt
    : (small_stmt NEWLINE)
    ;

small_stmt
    : assignment
    | arithmetic
    ;

compound_stmt
    : if_stmt
    | while_stmt
    | for_stmt
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
    | range_expr
    ;

array
    : '[' elements ']'
    ;

elements
    : arithmetic (',' arithmetic)*
    ;

if_stmt
    : IF expr COLON NEWLINE block
      (ELIF expr COLON NEWLINE block)*
      (ELSE COLON NEWLINE block)?
    ;

while_stmt
    : WHILE expr COLON NEWLINE block
    ;

for_stmt
    : FOR LETTER IN (LETTER | range_expr) COLON NEWLINE block
    ;

block
    : INDENT statement+ DEDENT
    ;

range_expr
    : RANGE '(' arithmetic (',' arithmetic)* ')'
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

ASSIGN: '=';
PLUS_EQ: '+=';
MINUS_EQ: '-=';
MULT_EQ: '*=';
DIV_EQ: '/=';

IF: 'if';
ELIF: 'elif';
ELSE: 'else';
WHILE: 'while';
FOR: 'for';
IN: 'in';
RANGE: 'range';
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
NUMBER: '-'? [0-9]+ ('.' [0-9]+)?;
STRING: '"' (~["\r\n])* '"';
CHAR: '\'' (~['\r\n])* '\'';
BOOL: 'True' | 'False';

COMMENT: '#' ~[\r\n]* -> skip;
MULTILINE_COMMENT: '\'\'\'' .*? '\'\'\'' -> skip;

NEWLINE
    : ('\r'? '\n' | '\r') [ \t]*
    {
        String spaces = getText().substring(getText().lastIndexOf('\n') + 1);
        int indent = spaces.length();
        
        if (indent > currentIndent) {
            indentStack.push(indent);
            currentIndent = indent;
            tokenQueue.offer(createToken(INDENT_TOKEN, "INDENT"));
        } else if (indent < currentIndent) {
            while (!indentStack.isEmpty() && indent < indentStack.peek()) {
                indentStack.pop();
                tokenQueue.offer(createToken(DEDENT_TOKEN, "DEDENT"));
            }
            currentIndent = indent;
        }
        setCharPositionInLine(0);
    }
    ;

WS
    : [ \t]+ -> skip
    ;