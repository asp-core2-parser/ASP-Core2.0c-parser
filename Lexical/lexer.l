%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
%}

%%

"not"              {printf("NOT"); //written before ID otherwise Flex can't match it}
[a-z][A-Za-z0-9_]* {printf("ID");}
[A-Z][A-Za-z0-9_]* {printf("VARIABLE");}
\"([^\"]|\\\")*\"  {printf("STRING");}
"0"|[1-9][0-9]*    {printf("NUMBER");}
"_"                {printf("ANONYMOUS_VARIABLE");}
"."                {printf("DOT");}
","                {printf("COMMA");}
"?"                {printf("QUERY_MARK");}
":"                {printf("COLON");}
";"                {printf("SEMICOLON");}
"|"                {printf("OR");}
":-"               {printf("CONS");}
":~"               {printf("WCONS");}
"+"                {printf("PLUS");}
"-"                {printf("MINUS");}
"*"                {printf("TIMES");}
"/"                {printf("DIV");}
"@"                {printf("AT");}
"("                {printf("PAREN_OPEN");}
")"                {printf("PAREN_CLOSE");}
"["                {printf("SQUARE_OPEN");}
"]"                {printf("SQUARE_CLOSE");}
"{"                {printf("CURLY_OPEN");}
"}"                {printf("CURLY_CLOSE");}
"="                {printf("EQUAL");}
"<>"|"!="          {printf("UNEQUAL");}
"<"                {printf("LESS");}
"<="               {printf("LESS_OR_EQ");}
">"                {printf("GREATER");}
">="               {printf("GREATER_OR_EQ");}
"#count"           {printf("AGGREGATE_COUNT");}
"#max"             {printf("AGGREGATE_MAX");}
"#min"             {printf("AGGREGATE_MIN");}
"#sum"             {printf("AGGREGATE_SUM");}
"#minimi"[zs]"e"   {printf("MINIMIZE");}
"#maximi"[zs]"e"   {printf("MAXIMIZE");}
%([^*\n][^\n]*)?\n {printf("COMMENT");}
"%*"([^*]|\*[^%])*"*%" {printf("MULTI_LINE_COMMENT");}
[ \t\n]+           {printf("BLANK");}
%%

int main(int argc, char** argv){
    yylex();
    return 0;
}