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

%token INT
%token IDENT
%token EQUALS
%left PLUS
%left MINUS
%left TIMES
%left DIVIDE
%token LPAREN
%token RPAREN
%token FLOAT
%token ASSIGN
%token IF
%token FOR
%token ELIF
%token ELSE
%token WHILE
%token END


%%

/* After the %% divider we put the grammar rules, which are similar to the CFG grammar rules we
 * will work with in class.  There are a few extra features, that just simplify the specification
 * of the grammar. The LHS of the rule is on the left, followed by a colon.  Then the RHS is to the right.
 * additional rules follow, one per line, with a semi-colon marking the end of a set of rules for a given LHS
 */

assignments:     assign                 // First rule allows a sequence of assignment statements of any length
|                assign assignments
| assign S
| S
;
assign:     IDENT EQUALS INT | IDENT EQUALS S          { parseprint("assign -> id = int"); }
;

S: L
| L S

;

L: end
| E1 end
end: END {parseprint("End");}
;


E1: E1 plus E1
| E1 minus E1
| E2
;
plus: PLUS { parseprint("Plus "); };
minus: MINUS { parseprint("Minus"); }
;

E2: E2 times E2
| E2 divide E2
| E3;
times: TIMES { parseprint("Times "); }
;
divide: DIVIDE { parseprint("Divide"); }
;


E3: int
| float
| ident
| lparen E1 rparen
;

int: INT { parseprint("int recognized"); }
;
float: FLOAT { parseprint("float recognized"); }
;
ident: IDENT { parseprint("ident recognized"); }
;
lparen: LPAREN { parseprint("lparen recognized"); }
;
rparen: RPAREN { parseprint("rparen recognized"); }
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
