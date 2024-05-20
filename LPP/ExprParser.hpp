#ifndef __EXPR_PARSER_HPP__
#define __EXPR_PARSER_HPP__

#include "ExprLexer.hpp"
#include "ExprParserImpl.h"

class ExprParser {

private:
    ExprLexer& lexer;
    std::unordered_map<std::string, double> var_map;

public:
    ExprParser(ExprLexer& lexer) : lexer(lexer) {
        addConstValues();        
    }

    int parse();
    void yyerror(const char *msg);

    ExprLexer& getLexer() const {
        return lexer;
    }

    void addVar(const std::string id, double val){
        var_map[id] = val;
    }

    double getVar(const std::string id){
        return var_map[id];
    }

    void addConstValues();

};

#endif