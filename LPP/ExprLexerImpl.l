%option noyywrap
%option reentrant
%option yylineno
%option extra-type = "std::istream *"

%{
#include <iostream>
#include <cstdlib>
#include "ExprLexer.hpp"

#define YY_DECL Token ExprLexer::nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval)

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
[Ee][Nn][Tt][Ee][Rr][Oo]	{ return Token::ENTERO; }
[Rr][Ee][Aa][Ll]	{ return Token::REAL; }
[Cc][Aa][Dd][Ee][Nn][Aa]	{ return Token::CADENA; }
[Bb][Oo][Oo][Ll][Ee][Aa][Nn][Oo]	{ return Token::BOOLEANO; }
[Cc][Aa][Rr][Aa][Cc][Tt][Ee][Rr]	{ return Token::CARACTER; }
[Aa][Rr][Rr][Ee][Gg][Ll][Oo]	{ return Token::ARREGLO; }
[Dd][Ee]	{ return Token::DE; }
[Ff][Uu][Nn][Cc][Ii][Oo][Nn]	{ return Token::FUNCION; }
[Pp][Rr][Oo][Cc][Ee][Dd][Ii][Mm][Ii][Ee][Nn][Tt][Oo]	{ return Token::PROCEDIMIENTO; }
[Vv][Aa][Rr]	{ return Token::VAR; }
[Ii][Nn][Ii][Cc][Ii][Oo]	{ return Token::INICIO; }
[Ff][Ii][Nn]	{ return Token::FIN; }
[Ff][Ii][Nn][Aa][Ll]	{ return Token::FINAL; }
[Ss][Ii]	{ return Token::SI; }
[Ee][Nn][Tt][Oo][Nn][Cc][Ee][Ss]	{ return Token::ENTONCES; }
[Ss][Ii][Nn][Oo]	{ return Token::SINO; }
[Pp][Aa][Rr][Aa]	{ return Token::PARA; }
[Mm][Ii][Ee][Nn][Tt][Rr][Aa][Ss]	{ return Token::MIENTRAS; }
[Hh][Aa][Gg][Aa]	{ return Token::HAGA; }
[Ll][Ll][Aa][Mm][Aa][Rr]	{ return Token::LLAMAR; }
[Rr][Ee][Pp][Ii][Tt][Aa]	{ return Token::REPITA; }
[Hh][Aa][Ss][Tt][Aa]	{ return Token::HASTA; }
[Cc][Aa][Ss][Oo]	{ return Token::CASO; }
[Oo]	{ return Token::O; }
[Yy]	{ return Token::Y; }
[Nn][Oo]	{ return Token::NO; }
[Dd][Ii][Vv]	{ return Token::DIV; }
[Mm][Oo][Dd]	{ return Token::MOD; }
[Ll][Ee][Aa]	{ return Token::LEA; }
[Ee][Ss][Cc][Rr][Ii][Bb][Aa]	{ return Token::ESCRIBA; }
[Rr][Ee][Tt][Oo][Rr][Nn][Ee]	{ return Token::RETORNE; }
[Tt][Ii][Pp][Oo]	{ return Token::TIPO; }
[Ee][Ss]	{ return Token::ES; }
[Rr][Ee][Gg][Ii][Ss][Tt][Rr][Oo]	{ return Token::REGISTRO; }
[Aa][Rr][Cc][Hh][Ii][Vv][Oo]	{ return Token::ARCHIVO; }
[Ss][Ee][Cc][Uu][Ee][Nn][Cc][Ii][Aa][Ll]	{ return Token::SECUENCIAL; }
[Aa][Bb][Rr][Ii][Rr]	{ return Token::ABRIR; }
[Cc][Oo][Mm][Oo]	{ return Token::COMO; }
[Ll][Ee][Cc][Tt][Uu][Rr][Aa]	{ return Token::LECTURA; }
[Ee][Ss][Cc][Rr][Ii][Tt][Uu][Rr][Aa]	{ return Token::ESCRITURA; }
[Cc][Ee][Rr][Rr][Aa][Rr]	{ return Token::CERRAR; }
[Ll][Ee][Ee][Rr]	{ return Token::LEER; }
[Ee][Ss][Cc][Rr][Ii][Bb][Ii][Rr]	{ return Token::ESCRIBIR; }

[Vv][Ee][Rr][Dd][Aa][Dd][Ee][Rr][Oo]	{ *lval = std::atof("1"); return Token::VERDADERO; }
[Ff][Aa][Ll][Ss][Oo]	{ *lval = std::atof("0"); return Token::FALSO; }
"."    { *lval = std::string(yytext); return Token::CADENA; }
[0-9]+(\.[0-9]+)?	{ *lval = std::atof(yytext); return Token::NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { *lval = std::string(yytext); return Token::ID; }
"+"		{ return Token::OP_ADD; }
"-"     { return Token::OP_SUB; }
"*"		{ return Token::OP_MULT; }
"("		{ return Token::OPEN_PAR; }
")"		{ return Token::CLOSE_PAR; }
":"     { return Token::COLON; }
"<-"     { return Token::OP_EQ; }
"["     { return Token::OPEN_BRA; }
"]"     { return Token::CLOSE_BRA; }
">"     { return Token::OP_GT; }
"<"     { return Token::OP_LT; }
">="    { return Token::OP_GE; }
"<="    { return Token::OP_LE; }
"<>"    { return Token::OP_NE; }
","     { return Token::COMMA; }
"^"     { return Token::CARET; }
.		{ std::cerr << "Invalid symbol\n"; return Token::Error; }

<comment>"*/" { BEGIN(INITIAL); }
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }
%%
