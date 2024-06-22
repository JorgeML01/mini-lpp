#ifndef __LPP_PARSER_HPP__
#define __LPP_PARSER_HPP__

#include "LPPLexer.hpp"
#include "LPPParserImpl.hpp"
#include "LPPAst.hpp"

class LPPParser {

private:
    LPPLexer& lexer;
    AstNode* program;
    SymbolVectorDataTypes vecDataTypes;

public:
    LPPParser(LPPLexer& lexer) : lexer(lexer) {  
    }

    int parse();
    void yyerror(const char *msg);

    SymbolVectorDataTypes& getSymbolVectorDataTypes() {
        for (int i = 0; i < vecDataTypes.size(); i++) {
            std::cout << vecDataTypes[i].id << " " << vecDataTypes[i].type << std::endl;
        }

        return vecDataTypes;
    }

    void addVectorDataType(std::string name,  std::string type) {
        bool found = isDataTypeDeclared(name);
        if (found) {
            std::cerr << "Error: Data type " << name << " already declared" << std::endl;
            exit(1);
        }

        vecDataTypes.push_back({name, type});
    }

    bool isDataTypeDeclared(std::string name) {
        for (auto& dataType : vecDataTypes) {
            if (dataType.id == name) {
                return true;
            }
        }
        return false;
    }

    LPPLexer& getLexer() const {
        return lexer;
    }

    void setProgram(AstNode* program){
        this->program = program;
    }

    AstNode* getProgram() {
        return program;
    }

};

#endif