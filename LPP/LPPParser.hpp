#ifndef __LPP_PARSER_HPP__
#define __LPP_PARSER_HPP__

#include "LPPLexer.hpp"
#include "LPPParserImpl.h"

class LPPParser {

private:
    LPPLexer& lexer;
    std::unordered_map<std::string, double> var_map;

public:
    LPPParser(LPPLexer& lexer) : lexer(lexer) {
        addConstValues();        
    }

    int parse();
    void yyerror(const char *msg);

    LPPLexer& getLexer() const {
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