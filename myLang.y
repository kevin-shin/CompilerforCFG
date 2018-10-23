/* ********************************************************************* */

/* The code between the %{ ... %} brackets below will be placed at the top
 * of the C file that bison creates.  It is a place to put includes and declarations
 * that are best done at the top of the file.
 */


%{

#include<stdio.h>
#include<stdlib.h>


void yyerror(const char* s) {
  fprintf(stderr, "%s\n", s);
};

int yylex();  // forward declaration of yylex, provided by flex

void parseprint(char*);  // forward declaration of printing function

%}

/* Next is the list of tokens this expects from the lexical analyzer.  We also specify
 * for tokens that are binary operations whether they are left-associative or right-associative.
 * a left-associative operation is one where if we see a - b - c we prefer the interpretation
 * (a - b) - c over a - (b - c).
 */

%token END
%token IDENT
%token EQUALS ASSIGN LESSTHAN GREATERTHAN
%token INT FLOAT
%token LPAREN RPAREN
%left PLUS MINUS
%left TIMES DIVIDE
%token LCURLY RCURLY
%token IF FOR ELSE ELIF WHILE



%%

/* After the %% divider we put the grammar rules, which are similar to the CFG grammar rules we
 * will work with in class.  There are a few extra features, that just simplify the specification
 * of the grammar. The LHS of the rule is on the left, followed by a colon.  Then the RHS is to the right.
 * additional rules follow, one per line, with a semi-colon marking the end of a set of rules for a given LHS
 */


S: L {parseprint("S1");}
| L S {parseprint("S2");}
;

L: end {parseprint("ENDLINE");}
| E1 end {parseprint("ARITHMETIC");}
| statements end {parseprint("STATEMENTS");}
| expressions end {parseprint("EXPRESSIONS");}
;
end: END {parseprint("End");}
;

statements: assignments
| ifstate
| elifstate
| elsestate
| forstate
| whilestate
| block
;

expressions: IDENT EQUALS E1  { parseprint("expressions recognized"); }
| IDENT EQUALS E1 expressions
| IDENT LESSTHAN E1
| IDENT GREATERTHAN E1
| IDENT LESSTHAN E1 expressions
| IDENT GREATERTHAN E1 expressions
;


assignments: assign
| assign assignments
;
assign:	 IDENT ASSIGN E1 { parseprint("assignment works"); }
;

ifstate : IF condition block { parseprint("if statement recognized"); }
;

elifstate : ELIF condition block { parseprint("elif statement recognized"); }
;

elsestate : ELSE block { parseprint("elif statement recognized"); }
;

forstate: FOR rangecount block { parseprint("for statement recognized"); }
;

whilestate: WHILE condition block { parseprint("while statement recognized"); }
;

rangecount: LPAREN IDENT ASSIGN INT END IDENT LESSTHAN INT END IDENT PLUS PLUS RPAREN
| LPAREN IDENT EQUALS INT END IDENT GREATERTHAN INT END IDENT MINUS MINUS RPAREN
;

condition: LPAREN expressions RPAREN {parseprint("Condition Works");};

block: LCURLY S RCURLY { parseprint("Block works"); };

E1: E1 plus E1
| E1 minus E1
| E2
;
plus: PLUS { parseprint("Plus recognized"); };
minus: MINUS { parseprint("Minus recognized"); }
;

E2: E2 times E2
| E2 divide E2
| E3;
times: TIMES { parseprint("Times recognized"); }
divide: DIVIDE { parseprint("Divide recognized"); }
;


E3: int
| float
| ident
| LPAREN E1 RPAREN
;
int: INT| MINUS INT { parseprint("int recognized"); }
float: FLOAT { parseprint("float recognized"); }
ident: IDENT { parseprint("ident recognized"); }
;



%%

/* After the next %% divider, we put the code at the end.  I included a printing function, just in case, but
 * the biggest item here is a main to do the parsing. Bison builds a function called yyparse, which parses
 * input, calling the yylex function provided by Flex to get the next token.  If yyparse returns zero, then
 * the parse worked correctly to the end of input.  Other values indicate different problems with the parse.
 */


void parseprint(char* str)
{
  printf("             PARSED: %s\n", str);
}


int main() {
  fprintf(stderr, "Enter statements/expressions to parse:\n");
  int res = yyparse();
  if (res == 0)
    fprintf(stderr, "Successful parsing.\n");
  else if (res == 1)
    fprintf(stderr, "Parsing failed due to incorrect input.\n");
  else if (res == 2)
    fprintf(stderr, "Parsing failed due to lack of memory.\n");
  else
    fprintf(stderr, "Weird value: %d\n", res);
}
