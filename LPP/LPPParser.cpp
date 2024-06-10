#include "LPPParser.hpp"


int LPPParser::parse(){
    return yyparse(*this);
}

void LPPParser::addConstValues() {
    var_map["PI"] = 3.14159265358979323846;
    var_map["E"] = 2.71828182845904523536;
}
