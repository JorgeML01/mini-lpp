#include "LPPAst.hpp"

class ParserDataTypes {
    public:
    SymbolVectorDataTypes symbolVectorDataTypes;

    void setSymbolVectorDataTypes(SymbolVectorDataTypes symbolVectorDataTypes){
        this->symbolVectorDataTypes = symbolVectorDataTypes;
    }

    SymbolVectorDataTypes getSymbolVectorDataTypes(){
        return symbolVectorDataTypes;
    }
};