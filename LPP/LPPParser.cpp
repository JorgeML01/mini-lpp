#include "LPPParser.hpp"


int LPPParser::parse(){
    return yyparse(*this);
}
