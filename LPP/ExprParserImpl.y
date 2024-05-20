
%define parse.error verbose
%define api.pure full

%parse-param {ExprParser& parse} 

%code top { // parseIml.cpp

    #include <iostream>
    #include <string>
    #include <stdexcept>
    #include "ExprLexerImpl.h"
    #include "ExprLexer.hpp"
    #include "ExprParser.hpp"
    #include "ExprParserImpl.h"

    #define yylex(v) static_cast<int>(parse.getLexer().nextToken(v))

void yyerror(const ExprParser& parse, const char *msg)\
{\
    throw std::runtime_error(std::string(msg) + " at line " + std::to_string(parse.getLexer().getLine()));
}\

}

%code requires // parseIml.hpp
{
      #include <unordered_map>
      #include <string>
      #include <variant>

      class ExprParser;

      using ParserValueType = std::variant<std::string, double, bool>;
      #define YYSTYPE ParserValueType
      #define YYSTYPE_IS_DECLARED 1
}


%token OP_ADD "+"
%token OP_SUB "-"
%token OP_MULT "*"
%token OPEN_PAR "("
%token CLOSE_PAR ")"
%token NUMBER "number"
%token COLON ":"
%token ID "ID"
%token OP_EQ "="
%token OPEN_BRA "["
%token CLOSE_BRA "]"
%token OP_GT ">"
%token OP_LT "<"
%token OP_GE ">="
%token OP_LE "<="
%token OP_NE "<>"
%token ENTERO "ENTERO"
%token REAL "REAL"
%token CADENA "CADENA"
%token BOOLEANO "BOOLEANO"
%token CARACTER "CARACTER"
%token ARREGLO "ARREGLO"
%token DE "DE"
%token FUNCION "FUNCION"
%token PROCEDIMIENTO "PROCEDIMIENTO"
%token VAR "VAR"
%token INICIO "INICIO"
%token FIN "FIN"
%token FINAL "FINAL"
%token SI "SI"
%token ENTONCES "ENTONCES"
%token SINO "SINO"
%token PARA "PARA"
%token MIENTRAS "MIENTRAS"
%token HAGA "HAGA"
%token LLAMAR "LLAMAR"
%token REPITA "REPITA"
%token HASTA "HASTA"
%token CASO "CASO"
%token O "O"
%token Y "Y"
%token NO "NO"
%token DIV "DIV"
%token MOD "MOD"
%token LEA "LEA"
%token ESCRIBA "ESCRIBA"
%token RETORNE "RETORNE"
%token TIPO "TIPO"
%token ES "ES"
%token REGISTRO "REGISTRO"
%token ARCHIVO "ARCHIVO"
%token SECUENCIAL "SECUENCIAL"
%token ABRIR "ABRIR"
%token COMO "COMO"
%token LECTURA "LECTURA"
%token ESCRITURA "ESCRITURA"
%token CERRAR "CERRAR"
%token LEER "LEER"
%token ESCRIBIR "ESCRIBIR"
%token VERDADERO "VERDADERO"
%token FALSO "FALSO"
%token COMMA ","
%token CARET "^"

%% 

input: statement_list
;

statement_list: statement
            | statement_list statement
;

statement:  | print_statement
            | assign_statement
;

assign_statement:ID OP_EQ expr { }
;

print_statement: ID            { }
;


expr: expr OP_ADD term   { }
    | expr OP_SUB term   { }

    | expr OP_GT term       { }
    | expr OP_GE term       { }
    | expr OP_LT term       { }
    | expr OP_LE term       { }

    | term              { }
;

term: term OP_MULT factor      { }
    | factor                  { }
;

factor: OPEN_PAR expr CLOSE_PAR {}
      | NUMBER { }
      | ID  { } 
;
%%
