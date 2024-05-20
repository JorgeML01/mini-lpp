#ifndef __ExprLexer_HPP__
#define __ExprLexer_HPP__

#include <iosfwd>
#include <string>
#include <iostream> 
#include <variant>
#include <vector>

enum class Token: int {
    Eof = 0,
    Error = 256,
    Undef = 257,
    OpAdd = 258,
    OpSub = 259,
    OpMult = 260,
    OpenPar = 261,
    ClosePar = 262,
    Number = 263,
    SemiColon = 264,
    ID = 265,
    OpEq = 266,
    OpCurBra = 267,
    OpCloBra = 268,
    INT = 269,
    FOR = 270, 
    OpGt = 271,
    OpLt = 272,
    OpGe = 273,
    OpLe = 274,
    OpNe = 275,
    OpInc = 276,
    OpDec = 277,
    IF = 278,
    ELSE = 279
};

class ExprLexer
{
public:
    using yyscan_t = void*;
    using ParserValueType = std::variant<std::string, double, bool>;

public:
    ExprLexer(std::istream& _in);
    ~ExprLexer();

    Token nextToken(ParserValueType *lval)
    { 
        return nextTokenHelper(yyscanner, lval); 
    }

    std::string text() const;
    int getLine() const;
    static const char *tokenString(Token tk);

private:
    Token nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval);
    
private:
    std::istream& in;
    yyscan_t yyscanner;
    
};

#endif
