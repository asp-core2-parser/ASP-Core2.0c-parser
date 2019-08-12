%option noyywrap
%{
		#include "parser.tab.h"
    	#include <stdio.h>
    	#include <string.h>
%}
%x IN_COMMENT

%%

"not"              	{return NAF;}
[a-z][A-Za-z0-9_]* 	{return ID;}
[A-Z][A-Za-z0-9_]* 	{return VARIABLE;}
\"([^\"]|\\\")*\"  	{return STRING;}
"0"|[1-9][0-9]*    	{return NUMBER;}
"_"                	{return ANONYMOUS_VARIABLE;}
"."                	{return DOT;}
","                	{return COMMA;}
"?"                	{return QUERY_MARK;}
":"                	{return COLON;}
";"                	{return SEMICOLON;}
"|"                	{return OR;}
":-"               	{return CONS;}
":~"               	{return WCONS;}
"+"                	{return PLUS;}
"-"                	{return MINUS;}
"*"                	{return TIMES;}
"/"                	{return DIV;}
"@"                	{return AT;}
"("                	{return PAREN_OPEN;}
")"                	{return PAREN_CLOSE;}
"["                	{return SQUARE_OPEN;}
"]"                	{return SQUARE_CLOSE;}
"{"                	{return CURLY_OPEN;}
"}"                	{return CURLY_CLOSE;}
"="                	{return EQUAL;}
"<>"|"!="          	{return UNEQUAL;}
"<"                	{return LESS;}
"<="               	{return LESS_OR_EQ;}
">"                	{return GREATER;}
">="               	{return GREATER_OR_EQ;}
"#count"           	{return AGGREGATE_COUNT;}
"#max"             	{return AGGREGATE_MAX;}
"#min"             	{return AGGREGATE_MIN;}
"#sum"             	{return AGGREGATE_SUM;}
"#minimi"[zs]"e"   	{return MINIMIZE;}
"#maximi"[zs]"e"   	{return MAXIMIZE;}
^%.* 	            {printf("ciao"); /* ignore comments */}
[ \t]+           	{/* ignore blanks */}
\n					{++yylineno;}
<INITIAL>{
"/*"              BEGIN(IN_COMMENT);
}
<IN_COMMENT>{
"*/"      BEGIN(INITIAL);
[^*\n]+   // eat comment in chunks
"*"       // eat the lone star
\n        yylineno++;
}

%%

