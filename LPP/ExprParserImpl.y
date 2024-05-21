
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
%token OP_ASSIGN "<-"
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
%token QUOTE "\""
%token IDENT_CADENA "identificador cadena"
%token IDENT_CARACTER "identificador caracter"
%token OP_EQ "="

%% 

input: declaraciones inicio
;

declaraciones: declaracion 
             | declaraciones declaracion
             |
;

declaracion:   dec_funcion 
            |  dec_procedimiento
            |  dec_variable 
            |  dec_funcion
;

dec_funcion: FUNCION ID OPEN_PAR params CLOSE_PAR COLON type declaraciones block { }
;

params: param
      | params COMMA param
;

param: VAR ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type ID
     | type ID
;

type: ENTERO
    | BOOLEANO
    | CARACTER
;

block: INICIO statement_list FIN 
;


dec_procedimiento: 
;

dec_variable: dec_entero 
            | dec_booleano
            | dec_caracter
            | dec_arreglo
;

dec_entero: ENTERO lista_dec_enteros
;

lista_dec_enteros : ID
                 | lista_dec_enteros COMMA ID


dec_booleano: BOOLEANO lista_dec_booleanos
;

lista_dec_booleanos : ID
                 | lista_dec_booleanos COMMA ID

dec_caracter: CARACTER lista_dec_cadenas
;

dec_arreglo:  ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE ENTERO ID 
            | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE BOOLEANO ID 
            | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE CARACTER ID
;

lista_dec_cadenas: ID
                 | lista_dec_cadenas COMMA ID

inicio: INICIO statement_list FIN
;

statement_list: statement
            | statement_list statement
;

statement:  | print_statement
            | assign_statement
            | si_statement
            | llamar_statement
            | return_statement
;

return_statement: RETORNE expr
                | 

assign_statement: ID OP_ASSIGN expr 
                | ID OPEN_BRA NUMBER CLOSE_BRA OP_ASSIGN expr
;

print_statement: ESCRIBA IDENT_CADENA { }
                | ESCRIBA expr
;

si_statement: SI expr ENTONCES statement_list SINO statement_list FIN SI { }
            | SI expr ENTONCES statement_list SINO si_statement FIN SI { }
            | SI expr ENTONCES statement_list FIN SI { }

llamar_statement: LLAMAR ID OPEN_PAR args CLOSE_PAR { }

args: expr
    | args COMMA expr
;

expr: expr OP_ADD term   { }
    | expr OP_SUB term   { }
    | expr OP_GT term       { }
    | expr OP_GE term       { }
    | expr OP_LT term       { }
    | expr OP_LE term       { }
    | expr OP_EQ term       { }
    | expr Y expr           { }
    | expr O expr           { }
    | term                  { }
;

term: term OP_MULT factor      { }
    | factor                  { }
;

factor: OPEN_PAR expr CLOSE_PAR {}
    | NUMBER { }
    | ID  { } 
    | IDENT_CARACTER { }
    | VERDADERO { }
    | FALSO     { }
    | ID OPEN_BRA NUMBER CLOSE_BRA { }
    | ID OPEN_PAR args CLOSE_PAR { }
;
%%
