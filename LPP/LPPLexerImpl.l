%option noyywrap
%option reentrant
%option yylineno
%option case-insensitive
%option extra-type = "std::istream *"

%{
#include <iostream>
#include <cstdlib>
#include "LPPLexer.hpp"
#include "LPPAst.hpp"
#include <string>
#include <algorithm>



#define YY_DECL Token LPPLexer::nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval)

#define yyterminate() return Token::Eof

#define YY_INPUT(buf, result, max_size) \
    { \
        auto *in = yyget_extra(yyscanner); \
        in->read(buf, max_size); \
        result = in->gcount(); \
    }
%}

%x comment

%%
[ \t\n]	{  }
"//"[^\n]*\n { }
"/*" { BEGIN(comment); }
"entero"	{ return Token::ENTERO; }
"real"	{ return Token::REAL; }
"cadena"	{ return Token::CADENA; }
"booleano"	{ return Token::BOOLEANO; }
"caracter"	{ return Token::CARACTER; }
"arreglo"	{ return Token::ARREGLO; }
"de"	{ return Token::DE; }
"funcion"	{ return Token::FUNCION; }
"procedimiento"	{ return Token::PROCEDIMIENTO; }
"var"	{ return Token::VAR; }
"inicio"	{ return Token::INICIO; }
"fin"	{ return Token::FIN; }
"final"	{ return Token::FINAL; }
"si"	{ return Token::SI; }
"entonces"	{ return Token::ENTONCES; }
"sino"	{ return Token::SINO; }
"para"	{ return Token::PARA; }
"mientras"	{ return Token::MIENTRAS; }
"haga"	{ return Token::HAGA; }
"llamar"	{ return Token::LLAMAR; }
"repita"	{ return Token::REPITA; }
"hasta"	{ return Token::HASTA; }
"caso"	{ return Token::CASO; }
"o"	{ return Token::O; }
"y"	{ return Token::Y; }
"no"	{ return Token::NO; }
"div"	{ return Token::DIV; }
"mod"	{ return Token::MOD; }
"lea"	{ return Token::LEA; }
"escriba"	{ return Token::ESCRIBA; }
"retorne"	{ return Token::RETORNE; }
"tipo"	{ return Token::TIPO; }
"es"	{ return Token::ES; }
"registro"	{ return Token::REGISTRO; }
"archivo"	{ return Token::ARCHIVO; }
"secuencial"	{ return Token::SECUENCIAL; }
"abrir"	{ return Token::ABRIR; }
"como"	{ return Token::COMO; }
"lectura"	{ return Token::LECTURA; }
"escritura"	{ return Token::ESCRITURA; }
"cerrar"	{ return Token::CERRAR; }
"leer"	{ return Token::LEER; }
"escribir"	{ return Token::ESCRIBIR; }
"sino si"   { return Token::SINO_SI; }
"fin si"    { return Token::FIN_SI; }

"verdadero"	{ *lval = new BooleanExpr(1); return Token::VERDADERO; } 
"falso"	{ *lval = new BooleanExpr(0); return Token::FALSO; }      
"CADENA"    { return Token::CADENA; }
"\""[^\"]*"\""          { 
                            std::string text = std::string(yytext); text.erase(std::remove(text.begin(), text.end(), '\"'), text.end());
                            *lval = new CadenaExpr(text); return Token::IDENT_CADENA; 
                        }
\'[^\']\'               { 
                            std::string text = std::string(yytext); text.erase(std::remove(text.begin(), text.end(), '\''), text.end());
                            *lval = new CaracterExpr(text); return Token::IDENT_CARACTER; 
                        }

[0-9]+(\.[0-9]+)?	{  *lval = new NumExpr(std::atoi(yytext)); return Token::NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* {  *lval = new IdentExpr(std::string(yytext));  return Token::ID; }
"+"		{ return Token::OP_ADD; }
"-"     { return Token::OP_SUB; }
"*"		{ return Token::OP_MULT; }
"("		{ return Token::OPEN_PAR; }
")"		{ return Token::CLOSE_PAR; }
":"     { return Token::COLON; }
"<-"     { return Token::OP_ASSIGN; }
"["     { return Token::OPEN_BRA; }
"]"     { return Token::CLOSE_BRA; }
">"     { return Token::OP_GT; }
"<"     { return Token::OP_LT; }
">="    { return Token::OP_GE; }
"<="    { return Token::OP_LE; }
"<>"    { return Token::OP_NE; }
","     { return Token::COMMA; }
"^"     { return Token::CARET; }
"\""    { return Token::QUOTE; }
"="     { return Token::OP_EQ; }
.		{ std::cerr << "Invalid symbol\n"; return Token::Error; }

<comment>"*/" { BEGIN(INITIAL); }
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }
%%