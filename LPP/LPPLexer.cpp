#include <fstream>
#include "LPPLexer.hpp"
#include "LPPLexerImpl.hpp"
#include <unordered_map>
#include <iostream>

LPPLexer::LPPLexer(std::istream& _in)
  : in(_in)
{
    yylex_init_extra(&in, &yyscanner);
}

LPPLexer::~LPPLexer()
{
    yylex_destroy(yyscanner);
}

std::string LPPLexer::text() const
{
    return std::string(yyget_text(yyscanner));
}

int LPPLexer::getLine() const
{
    return yyget_lineno(yyscanner);
}

const char *LPPLexer::tokenString(Token tk)
{
    return "Unknown";
}

