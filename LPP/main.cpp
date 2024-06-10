#include <iostream>
#include <fstream>
#include "LPPLexer.hpp"
#include "LPPParser.hpp"


int main(int argc, char *argv[]) 
{
    if (argc != 2) {
        std::cerr << "Not enough CLI arguments\n";
        return 1;
    }
    
    std::ifstream in(argv[1], std::ios::in);

    if (!in.is_open()) {
        std::cerr << "Cannot open file\n";
        return 1;
    }

    LPPLexer lexer(in);
    LPPParser parser(lexer);

    try {
        parser.parse();

    } catch(const std::runtime_error ex){
        std::cerr << ex.what() << "\n";   
    }
}
