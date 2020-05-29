%option c++ prefix="og_scanner_" outfile="og_scanner.cpp"
%option stack noyywrap yylineno 8bit
%{ 
// make relevant includes before including the parser's tab file
#include <string>
#include <sstream>
#include <errno.h>
#include <limits.h>
#include <math.h>
#include <cdk/ast/sequence_node.h>
#include <cdk/ast/expression_node.h>
#include <cdk/ast/lvalue_node.h>
#include "og_parser.tab.h"

static std::ostringstream stream;

inline void yyerror(const char *msg) { std::cout << msg << std::endl; }

// don't change this
#define yyerror LexerError
%}
%x X_STRING X_COMMENT X_BACKSLASH X_IGNORE
%%

 /*COMENTARIOS*/

"//".*\n                ; /*EXPLICATIVOS*/
"/*"                    yy_push_state(X_COMMENT);
<X_COMMENT>"/*"         yy_push_state(X_COMMENT);
<X_COMMENT>"*/"         yy_pop_state();
<X_COMMENT>.|\n         ; /*OPERACIONAIS*/


 /*TIPOS DE DADOS*/

"int"                   return tINT;
"real"                  return tREAL;
"string"                return tSTR;
"ptr"                   return tPTR;
"auto"                  return tAUTO;


 /*DECLARACAO*/

"public"                return tPUBLIC;
"require"               return tREQUIRE;
"procedure"             return tPROCEDURE;

 /*EXPRESSAO DE DIMENSAO*/

"sizeof"                return tSIZEOF;

 /*PONTEIROS*/

"nullptr"               return tNULLPTR;

 /*LEITURA E ESCRITA*/

"input"                 return tINPUT;
"writeln"               return tWRITELN;
"write"                 return tWRITE;        


 /*INSTRUCAO CONTINUACAO , TERMINACAO E RETORNO*/

"break"                 return tBREAK;
"continue"              return tCONTINUE;
"return"                return tRETURN;

 /*INSTRUCAO CONDICIONAL*/

"if"                    return tIF;
"then"                  return tTHEN;
"else"                  return tELSE;
"elif"                  return tELIF;

 /*INSTRUCAO DE ITERACAO*/  

"for"                   return tFOR;
"do"                    return tDO;

 /*OPERACOES ARITMETICAS*/

">="                    return tGE; 
"<="                    return tLE; 
"=="                    return tEQ; 
"!="                    return tNE;
"||"                    return tOR;
"&&"                    return tAND;

 /* RESTANTES CARATERES */ 

[-()\{\}\[\]<>=+*/%;,?@~]        return *yytext;


 /*IDENTIFICADOR*/

[A-Za-z][A-Za-z0-9_]*       yylval.s = new std::string(yytext); return tIDENTIFIER;

 /*REAL*/

([0-9]*\.[0-9]+|[0-9]+\.[0-9])([Ee]([-+])?[0-9]+)?|[0-9]+[Ee]([-+])?[0-9]+  { 
                                                                            double val = strtod(yytext, NULL);
                                                                            if(errno == ERANGE && val == HUGE_VAL){
                                                                                yyerror("Real overflow");
                                                                            }
                                                                            else{
                                                                                yylval.d = val;
                                                                                return tREALVAL;
                                                                            }
                                                                            }


 /*STRING*/

"\""                            yy_push_state(X_STRING);              
<X_STRING>"\""                  {
                                yylval.s = new std::string(stream.str());
                                stream.str("");
                                yy_pop_state(); 
                                return tSTRING;
                                }
<X_STRING>"\\"                  yy_push_state(X_BACKSLASH);
<X_STRING>.                     stream << *yytext;

<X_IGNORE>"\""                  {
                                yy_pop_state();yy_pop_state();yy_pop_state();
                                yylval.s = new std::string(stream.str());
                                stream.str("");
                                return tSTRING;
                                }
                                
<X_IGNORE>.                     ;

<X_BACKSLASH>n                  stream << "\n";yy_pop_state();
<X_BACKSLASH>r                  stream << "\r";yy_pop_state();
<X_BACKSLASH>t                  stream << "\t";yy_pop_state();
<X_BACKSLASH>"\""               stream << "\"";yy_pop_state();
<X_BACKSLASH>"\\"               stream << "\\";yy_pop_state();


<X_BACKSLASH>[A-Fa-f1-9]|[A-Fa-f0-9][A-Fa-f0-9]   { stream << (char)(unsigned char)strtoul(yytext, NULL, 16);
                                                    yy_pop_state();}    

<X_BACKSLASH>0                  yy_push_state(X_IGNORE);

<X_BACKSLASH>.                  {stream << *yytext;yy_pop_state();}

 /*INTEIROS*/

[0-9]+                  {   
                            try{
                                yylval.i = std::stoi(yytext, nullptr, 10);
                                return tINTEGER;
                            } catch(std::out_of_range& e){
                                yyerror("Integer overflow");
                            }
                        }

0x[A-Fa-f0-9]+          {   
                            try{
                                yylval.i = std::stoi(yytext, nullptr, 16);
                                return tINTEGER;
                            } catch(std::out_of_range& e){
                                yyerror("Integer overflow");
                            }
                        }

[ \t\n\r]+               ; /* ignore whitespace */

.                      yyerror("Unknown character");

%%
