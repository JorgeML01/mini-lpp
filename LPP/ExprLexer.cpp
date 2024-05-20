#include <fstream>
#include "ExprLexer.hpp"
#include "ExprLexerImpl.h"
#include <unordered_map>
#include <iostream>

ExprLexer::ExprLexer(std::istream& _in)
  : in(_in)
{
    yylex_init_extra(&in, &yyscanner);
}

ExprLexer::~ExprLexer()
{
    yylex_destroy(yyscanner);
}

std::string ExprLexer::text() const
{
    return std::string(yyget_text(yyscanner));
}

int ExprLexer::getLine() const
{
    return yyget_lineno(yyscanner);
}

const char *ExprLexer::tokenString(Token tk)
{
    return "Unknown";
}

