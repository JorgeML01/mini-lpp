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
    OP_ADD = 258,
    OP_SUB = 259,
    OP_MULT = 260,
    OPEN_PAR = 261,
    CLOSE_PAR = 262,
    NUMBER = 263,
    COLON = 264,
    ID = 265,
    OP_EQ = 266,
    OPEN_BRA = 267,
    CLOSE_BRA = 268,
    OP_GT = 269,
    OP_LT = 270,
    OP_GE = 271,
    OP_LE = 272,
    OP_NE = 273,
    ENTERO = 274,
    REAL = 275,
    CADENA = 276,
    BOOLEANO = 277,
    CARACTER = 278,
    ARREGLO = 279,
    DE = 280,
    FUNCION = 281,
    PROCEDIMIENTO = 282,
    VAR = 283,
    INICIO = 284,
    FIN = 285,
    FINAL = 286,
    SI = 287,
    ENTONCES = 288,
    SINO = 289,
    PARA = 290,
    MIENTRAS = 291,
    HAGA = 292,
    LLAMAR = 293,
    REPITA = 294,
    HASTA = 295,
    CASO = 296,
    O = 297,
    Y = 298,
    NO = 299,
    DIV = 300,
    MOD = 301,
    LEA = 302,
    ESCRIBA = 303,
    RETORNE = 304,
    TIPO = 305,
    ES = 306,
    REGISTRO = 307,
    ARCHIVO = 308,
    SECUENCIAL = 309,
    ABRIR = 310,
    COMO = 311,
    LECTURA = 312,
    ESCRITURA = 313,
    CERRAR = 314,
    LEER = 315,
    ESCRIBIR = 316,
    VERDADERO = 317,
    FALSO = 318,
    COMMA = 319,
    CARET = 320,
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
