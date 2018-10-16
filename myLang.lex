enablePackage(language-c)
/* ********************************************************************* */

/* The code between the brackets below will be included verbatim at the
 * top of the C file flex creates.  This includes any needed include
 * files and a few declarations...
 */

%{
#include<stdio.h>
#include<stdlib.h>
#include "example1.tab.h"


void printer(char*);  // Forward declaration of printing function


%}


/* After the verbatim code, we may declare names that correspond to
 * common patterns that will show up in the rules.  A lot may be
 * done here, but I typically keep this simple, and let the rules
 * handle everything else
 */

digit	[0-9]
alpha	[a-z,A-Z]
boolean [tf]
comparison [<>=]
change [PM]
anything [{digit}|{alpha}|{boolean}|{comparison}|{change}]



/* Below the %% are the "rules" for the lexical analyzer.  They are
 * a sequence of regular expressions on the left, and a fragment
 * of C code on the right.  The code may do anything you like, but
 * any procedures you need for it should be declared at the bottom
 * of the file.
 */
%%

"_"*{alpha}({alpha}|{digit}|"_")*	{ printer("Identifier"); }
("+"|"-"|""){digit}+	 	{ printer("Integer"); }
"="                     { printer("Equals"); }
("+") {printer("Plus");}
("-") {printer ("Minus");}
("*") {printer ("Times");}
("/") {printer ("Divide");}
("(") {printer ("LParen");}
(")") {printer ("RParen");}
{digit}+"."{digit}+ {printer ("Float");}
{alpha}+" = "({alpha}|{digit})* {printer ("Assign");}
"if("{boolean}") {"{alpha}+"}" {printer ("Boolean Correct");}
"for("{alpha}"="{digit}", "{alpha}{comparison}{digit}+", "{alpha}":"{change}") ""{"{alpha}+"}" {printer ("For Loop");}
"elif("{boolean}") {"{alpha}+"}" {printer ("elif Boolean Correct");}
"else ""{"{alpha}+"}" {printer ("Else Correct");}
"while("{boolean}") {"anything"}" {printer ("while loop correct"); }



[ \t\n]+		;  /*when see whitespace, do nothing*/



%%

/* this section contains any procedures you might want to declare, anything
 * that the C fragments above might need.  Like the section at the top,
 * the code you put here will be included, verbatim.
 */

void printer(char* str)
{
  printf("      Recognized %s: %s\n", str, yytext);
}
