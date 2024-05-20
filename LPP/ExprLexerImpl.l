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
"if"    { return Token::IF; }
"else"  { return Token::ELSE; }
"int"   { return Token::INT; }
"for"   { return Token::FOR; }
"+"		{ return Token::OpAdd; }
"-"     { return Token::OpSub; }
"*"		{ return Token::OpMult; }
"("		{ return Token::OpenPar; }
")"		{ return Token::ClosePar; }
";"     { return Token::SemiColon; }
[0-9]+(\.[0-9]+)?	{ *lval = std::atof(yytext); return Token::Number; }
[a-zA-Z_][a-zA-Z0-9_]* { *lval = std::string(yytext); return Token::ID; }
"="     { return Token::OpEq; }
"{"     { return Token::OpCurBra; }
"}"     { return Token::OpCloBra; }
">"     { return Token::OpGt; }
"<"     { return Token::OpLt; }
">="    { return Token::OpGe; }
"<="    { return Token::OpLe; }
"!="    { return Token::OpNe; }
"++"    { return Token::OpInc; }
"--"    { return Token::OpDec; }
.		{ std::cerr << "Invalid symbol\n"; return Token::Error; }

<comment>"*/" { BEGIN(INITIAL); }
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }
%%
