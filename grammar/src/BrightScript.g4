grammar BrightScript;

startRule
    : componentHead* componentBody* EOF
    ;

componentHead
    : libraryStatement
    | conditionalCompilationStatement
    ;

componentBody
    : functionDeclaration
    | subDeclaration
    ;

block
    : assignmentStatmenet
    | conditionalCompilationStatement
    | dimStatement
    | exitStatement
    | forStatement
    | forEachStatement
    | ifThenElseStatement
    | gotoStatement
    | labelStatement
    | nextStatement
    | printStatement
    | returnStatement
    | stopStatement
    | whileStatement
    | endStatement
    | expression
    ;

assignmentStatmenet
    : LET? identifier EQUALS assignableExpression
    ;

arrayInitializer
    : OPEN_BRACKET (arrayElement (COMMA arrayElement)*)? CLOSE_BRACKET
    ;

arrayElement
    : expression
    | arrayInitializer
    | associativeArrayInitializer;

associativeArrayInitializer
    : OPEN_BRACE (associativeElementInitializer (COMMA associativeElementInitializer)*)?  CLOSE_BRACE
    ;

associativeElementInitializer
    : (identifier | stringLiteral) COLON assignableExpression
    ;

conditionalCompilationStatement
    : CONDITIONAL_CONST untypedIdentifier EQUALS expression
    | CONDITIONAL_ERROR .*?
    | conditionalCompilationIfBlockStatement conditionalCompilationIfElseIfBlockStatement* conditionalCompilationIfElseBlockStatement? CONDITIONAL_ENDIF
    ;

conditionalCompilationIfBlockStatement
    : CONDITIONAL_IF expression THEN? conditionalCompilationBlock*
    ;

conditionalCompilationIfElseIfBlockStatement
    : CONDITIONAL_ELSEIF expression THEN? conditionalCompilationBlock*
    ;

conditionalCompilationIfElseBlockStatement
    : CONDITIONAL_ELSE conditionalCompilationBlock*
    ;

conditionalCompilationBlock
    : componentBody
    | block
    ;

dimStatement
    : DIM identifier OPEN_BRACKET parameterList CLOSE_BRACKET
    ;

endStatement
    : END
    ;

exitStatement
    : EXIT WHILE
    | EXITWHILE
    | EXIT FOR
    ;

forStatement
    : FOR identifier EQUALS expression TO expression (STEP expression)? block* nextStatement? (END FOR)?
    ;

forEachStatement
    : FOR EACH identifier IN expression block* (nextStatement | END FOR)
    ;

gotoStatement
    : GOTO IDENTIFIER
    ;

ifThenElseStatement
    : IF expression THEN? block* (ELSEIF block*)* (ELSE block)? END IF
    ;

labelStatement
    : IDENTIFIER COLON
    ;

libraryStatement
    : LIBRARY STRING_LITERAL
    ;

nextStatement
    : NEXT
    ;

printStatement
    : PRINT expression (SEMICOLON expression)*
    ;

returnStatement
    : RETURN assignableExpression?
    ;

stopStatement
    : STOP
    ;

whileStatement
    : WHILE expression block* (ENDWHILE | END WHILE)
    ;

anonymousFunctionDeclaration
    : FUNCTION parameterList (AS baseType)? block* (ENDFUNCTION | END FUNCTION)
    ;

functionDeclaration
    : FUNCTION untypedIdentifier parameterList (AS baseType)? block* (ENDFUNCTION | END FUNCTION)
    ;

anonymousSubDeclaration
    : SUB parameterList block* (ENDSUB | END SUB)
    ;

subDeclaration
    : SUB untypedIdentifier parameterList block* (ENDSUB | END SUB)
    ;

parameterList
    : OPEN_PARENTHESIS (parameter (COMMA parameter)*)? CLOSE_PARENTHESIS
    ;

parameter
    : (literal | identifier) (EQUALS assignableExpression)? (AS baseType)?
    ;

baseType
    : BOOLEAN
    | DOUBLE
    | DYNAMIC
    | FLOAT
    | FUNCTION
    | INTEGER
    | OBJECT
    | STRING
    | VOID
    ;

expressionList
    : (expression | associativeArrayInitializer | arrayInitializer) (COMMA (expression | associativeArrayInitializer | arrayInitializer))*
    ;

expression
    : primary
    | NOT expression
    | ADD expression
    | SUBTRACT expression
    | OPEN_PARENTHESIS expression CLOSE_PARENTHESIS
    | expression OPEN_PARENTHESIS expressionList? CLOSE_PARENTHESIS
    | expression DOT expression
    | expression ATTRIBUTE_OPERATOR expression
    | expression INCREMENT
    | expression DECREMENT
    | expression MULTIPLY expression
    | expression DIVIDE expression
    | expression MOD expression
    | expression DIVIDE_INTEGER expression
    | expression ADD expression
    | expression SUBTRACT expression
    | expression BITSHIFT_LEFT expression
    | expression BITSHIFT_RIGHT expression
    | expression GREATER_THAN expression
    | expression LESS_THAN expression
    | expression EQUALS expression
    | expression NOT_EQUAL expression
    | expression GREATER_THAN_OR_EQUAL expression
    | expression LESS_THAN_OR_EQUAL expression
    | expression AND expression
    | expression OR expression
    ;

primary
    : literal
    | identifier
    ;

literal
    : numberLiteral
    | stringLiteral
    | booleanLiteral
    | invalidLiteral
    ;

assignableExpression
    : arrayInitializer
    | associativeArrayInitializer
    | anonymousFunctionDeclaration
    | anonymousSubDeclaration
    | expression
    ;

numberLiteral
    : INT_LITERAL
    | FLOAT_LITERAL
    ;

stringLiteral
    : STRING_LITERAL
    ;

booleanLiteral
    :  TRUE
    |  FALSE
    ;

invalidLiteral
    : INVALID
    ;

identifier
    : IDENTIFIER IDENTIFIER_TYPE_DECLARATION?
    ;

untypedIdentifier
    : IDENTIFIER
    ;

reservedWord
    : AND
    | BOX
    | DIM
    | EACH
    | ELSE
    | ELSEIF
    | END
    | ENDFUNCTION
    | ENDIF
    | ENDSUB
    | ENDWHILE
    | EXIT
    | EXITWHILE
    | FALSE
    | FOR
    | FUNCTION
    | GOTO
    | IF
    | INVALID
    | LET
    | LINE_NUM
    | NEXT
    | NOT
    | OBJFUN
    | OR
    | POS
    | PRINT
    | REM
    | RETURN
    | STEP
    | STOP
    | SUB
    | TAB
    | THEN
    | TO
    | TRUE
    | WHILE
    ;

AND
    : A N D
    ;

AS  : A S
    ;

BOOLEAN
    : B O O L E A N
    ;

BOX
    : B O X
	;

DIM
    : D I M
	;

DOUBLE
    : D O U B L E
    ;

DYNAMIC
    : D Y N A M I C
    ;

EACH
    : E A C H
	;

ELSE
    : E L S E
	;

ELSEIF
    : E L S E I F
	;

END
    : E N D
	;

ENDFUNCTION
    : E N D F U N C T I O N
	;

ENDIF
    : E N D I F
	;

ENDSUB
    : E N D S U B
	;

ENDWHILE
    : E N D W H I L E
	;

EXIT
    : E X I T
	;

EXITWHILE
    : E X I T W H I L E
	;

FALSE
    : F A L S E
	;

FLOAT
    : F L O A T
    ;

FOR
    : F O R
	;

FUNCTION
    : F U N C T I O N
	;

GOTO
    : G O T O
	;

IF
    : I F
	;

IN
    : I N
    ;

INTEGER
    : I N T E G E R
    ;

INTERFACE
    : I N T E R F A C E
    ;

INVALID
    : I N V A L I D
	;

LET
    : L E T
	;

LIBRARY
    : L I B R A R Y
    ;

LINE_NUM
    : L I N E '_' N U M
    ;

MOD
    : M O D
    ;

NEXT
    : N E X T
	;

NOT
    : N O T
	;

OBJECT
    : O B J E C T
    ;

OBJFUN
    : O B J F U N
	;

OR
    : O R
	;

POS
    : P O S
	;

PRINT
    : P R I N T
	;

REM
    : R E M
	;

RETURN
    : R E T U R N
	;

STEP
    : S T E P
	;

STOP
    : S T O P
	;

STRING
    : S T R I N G
    ;

SUB
    : S U B
	;

TAB
    : T A B
	;

THEN
    : T H E N
	;

TO
    : T O
	;

TRUE
    : T R U E
	;

VOID
    : V O I D
    ;

WHILE
    : W H I L E
	;

STRING_LITERAL
    : '"' (~["\r\n] | '""')* '"'
    ;

INT_LITERAL
    : [0-9]+ '&'?
    | '&' H [0-9A-Fa-f]+ '&'?
    ;

FLOAT_LITERAL
    : [0-9]* '.' [0-9]+ (((E | D) ('+' | '-') [0-9]+) | ('!' | '#'))?
    ;

IDENTIFIER
    : [a-zA-Z_][a-zA-Z_0-9]*
    ;

IDENTIFIER_TYPE_DECLARATION
    : [$%!#&]
    ;

COMMENT
    : (SINGLE_QUOTE | (REM (WS))) ~[\r\n\u2028\u2029]* -> channel(HIDDEN)
    ;

WS
    : [ \t\r\n\u2028\u2029]+ -> skip
    ;

CONDITIONAL_CONST
    : '#' C O N S T
    ;

CONDITIONAL_ELSE
    : '#' ELSE
    ;

CONDITIONAL_ELSEIF
    : '#' (ELSE WS IF | ELSEIF)
    ;

CONDITIONAL_ENDIF
    : '#' (END WS IF | ENDIF)
    ;

CONDITIONAL_ERROR
    : '#' E R R O R
    ;

CONDITIONAL_IF
    : '#' IF
    ;

SINGLE_QUOTE
    : '\''
    ;

QUESTION_MARK
    : '?'
    ;

ATTRIBUTE_OPERATOR
    : '@'
    ;

INCREMENT
    : '++'
    ;

DECREMENT
    : '--'
    ;

OPEN_BRACKET
    : '['
    ;

CLOSE_BRACKET
    : ']'
    ;

OPEN_BRACE
    : '{'
    ;

CLOSE_BRACE
    : '}'
    ;

OPEN_PARENTHESIS
    : '('
    ;

CLOSE_PARENTHESIS
    : ')'
    ;

COMMA
    : ','
    ;

SEMICOLON
    : ';'
    ;

COLON
    : ':'
    ;

EQUALS
    : '='
    ;

DOT
    : '.'
    ;

ADD
    : '+'
    ;

SUBTRACT
    : '-'
    ;

MULTIPLY
    : '*'
    ;

DIVIDE
    : '/'
    ;

DIVIDE_INTEGER
    : '\\'
    ;

BITSHIFT_LEFT
    : '<<'
    ;

BITSHIFT_RIGHT
    : '>>'
    ;

GREATER_THAN
    : '>'
    ;

LESS_THAN
    : '<'
    ;

GREATER_THAN_OR_EQUAL
    : '>='
    ;

LESS_THAN_OR_EQUAL
    : '<='
    ;

NOT_EQUAL
    : '<>'
    ;

ASSIGNMENT_ADD
    : '+='
    ;

ASSIGNMENT_SUBTRACT
    : '-='
    ;

ASSIGNMENT_MULTIPLY
    : '*='
    ;

ASSIGNMENT_DIVIDE
    : '/='
    ;

ASSIGNMENT_DIVIDE_INTEGER
    : '\\='
    ;

ASSIGNMENT_BITSHIFT_LEFT
    : '<<='
    ;

ASSIGNMENT_BITSHIFT_RIGHT
    : '>>='
    ;

fragment A
    : ('a' | 'A')
    ;

fragment B
    : ('b' | 'B')
    ;

fragment C
    : ('c' | 'C')
    ;

fragment D
    : ('d' | 'D')
    ;

fragment E
    : ('e' | 'E')
    ;

fragment F
    : ('f' | 'F')
    ;

fragment G
    : ('g' | 'G')
    ;

fragment H
    : ('h' | 'H')
    ;

fragment I
    : ('i' | 'I')
    ;

fragment J
    : ('j' | 'J')
    ;

fragment K
    : ('k' | 'K')
    ;

fragment L
    : ('l' | 'L')
    ;

fragment M
    : ('m' | 'M')
    ;

fragment N
    : ('n' | 'N')
    ;

fragment O
    : ('o' | 'O')
    ;

fragment P
    : ('p' | 'P')
    ;

fragment Q
    : ('q' | 'Q')
    ;

fragment R
    : ('r' | 'R')
    ;

fragment S
    : ('s' | 'S')
    ;

fragment T
    : ('t' | 'T')
    ;

fragment U
    : ('u' | 'U')
    ;

fragment V
    : ('v' | 'V')
    ;

fragment W
    : ('w' | 'W')
    ;

fragment X
    : ('x' | 'X')
    ;

fragment Y
    : ('y' | 'Y')
    ;

fragment Z
    : ('z' | 'Z')
    ;
