#include "ExprParser.hpp"


int ExprParser::parse(){
    return yyparse(*this);
}

void ExprParser::addConstValues() {
    var_map["PI"] = 3.14159265358979323846;
    var_map["E"] = 2.71828182845904523536;
}
