#ifndef __LPP_PARSER_HPP__
#define __LPP_PARSER_HPP__

#include "LPPLexer.hpp"
#include "LPPParserImpl.hpp"
#include "LPPAst.hpp"

class LPPParser {

private:
    LPPLexer& lexer;
    AstNode* program;

public:
    LPPParser(LPPLexer& lexer) : lexer(lexer) {  
    }

    int parse();
    void yyerror(const char *msg);

    LPPLexer& getLexer() const {
        return lexer;
    }

    void setProgram(AstNode* program){
        this->program = program;
    }

    AstNode* getProgram(){
        return program;
    }


};

#endif