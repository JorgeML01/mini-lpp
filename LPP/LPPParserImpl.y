
%define parse.error verbose
%define api.pure full

%parse-param {LPPParser& parse} 

%code top {

    #include "LPPAst.hpp"

    #include <iostream>
    #include <string>
    #include <stdexcept>
    #include "LPPLexerImpl.hpp"
    #include "LPPLexer.hpp"
    #include "LPPParser.hpp"
    #include "LPPParserImpl.hpp"


    #define yylex(v) static_cast<int>(parse.getLexer().nextToken(v))

void yyerror(const LPPParser& parse, const char *msg)\
{\
    throw std::runtime_error(std::string(msg) + " at line " + std::to_string(parse.getLexer().getLine()));
}\

}

%code requires
{
      #include <unordered_map>
      #include <string>


      class LPPParser;

      using ParserValueType = AstNode*;
      #define YYSTYPE ParserValueType
      #define YYSTYPE_IS_DECLARED 1
}

%{

%}


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
%token SINO_SI "SINO SI"
%token FIN_SI "FIN SI"

%% 

input: start { parse.setProgram(new AddExpr(new NumExpr(2), new NumExpr(3))); }
;

start: dec_variable declaraciones block
;

// BLOQUES.
block: INICIO statement_list FIN 
;

// PARÁMETROS.
params: param
      | params COMMA param
;

param: VAR ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type ID
     | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type ID
     | VAR type ID
     | type ID
;

type: ENTERO
    | BOOLEANO
    | CARACTER
    | ID
;


// DECLARACIONES.
declaraciones: declaracion 
             | declaraciones declaracion
             |
;

declaracion:   dec_funcion 
            |  dec_procedimiento
            |  
;

dec_funcion: FUNCION ID OPEN_PAR params CLOSE_PAR COLON type dec_variable block 
            |FUNCION ID COLON type dec_variable block 
;


dec_procedimiento:  PROCEDIMIENTO ID OPEN_PAR params CLOSE_PAR dec_variable block
                    | PROCEDIMIENTO ID dec_variable block
;


dec_variable: dec_entero 
            | dec_booleano
            | dec_caracter
            | dec_arreglo
            | dec_tipo
            | dec_variable dec_entero 
            | dec_variable dec_booleano
            | dec_variable dec_caracter
            | dec_variable dec_arreglo
            | dec_variable dec_tipo
            |
;


dec_tipo:   TIPO ID ES type 
            | TIPO ID ES ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type
            | nuevo_tipo

nuevo_tipo: ID
            | ID COMMA nuevo_tipo
;

dec_entero: ENTERO lista_dec_enteros
;

lista_dec_enteros : ID
                 | lista_dec_enteros COMMA ID
;

dec_booleano: BOOLEANO lista_dec_booleanos
;

lista_dec_booleanos : ID
                 | lista_dec_booleanos COMMA ID
;

dec_caracter: CARACTER lista_dec_cadenas
;

dec_arreglo:  ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE ENTERO ID 
            | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE BOOLEANO ID 
            | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE CARACTER ID
;

lista_dec_cadenas: ID
                 | lista_dec_cadenas COMMA ID
;

// STATEMENTS.
statement_list:  statement_list statement 
                | statement 
;

block_statement: block_statement statement
                | statement
;

statement:  | print_statement
            | assign_statement
            | llamar_statement
            | return_statement
            | mientras_statement
            | para_statement
            | repita_statement
            | lea_statement
            | si_statement
;

si_statement: SI expr ENTONCES block_statement si_else_statement
;

si_else_statement: SINO_SI expr ENTONCES block_statement si_else_statement
                 | SINO block_statement FIN_SI
                 | FIN_SI
;

return_statement: RETORNE expr
                | 
;

assign_statement: ID OP_ASSIGN expr 
                | ID OPEN_BRA expr CLOSE_BRA OP_ASSIGN expr
;

print_statement: ESCRIBA text
;

text: expr
    | expr COMMA text
;

lea_statement: LEA ID
            | LEA ID OPEN_BRA expr CLOSE_BRA
;

llamar_statement: LLAMAR ID OPEN_PAR args CLOSE_PAR 
                | LLAMAR ID
;

mientras_statement: MIENTRAS expr HAGA block_statement FIN MIENTRAS
;

para_statement: PARA ID OP_ASSIGN expr HASTA expr HAGA block_statement FIN PARA
;

repita_statement: REPITA block_statement HASTA expr
;


// EXPRESSIONS.
args: expr
    | args COMMA expr
    |
;



expr: expr OP_ADD term   
    | expr OP_SUB term   
    | expr OP_GT term       
    | expr OP_GE term       
    | expr OP_LT term       
    | expr OP_LE term       
    | expr OP_EQ term
    | expr OP_NE term       
    | expr Y term           
    | expr O term           
    | expr MOD term           
    | expr DIV term           
    | expr CARET term
    | NO expr
    | term                  
;

term: term OP_MULT factor      
    | factor                  
;

factor: OPEN_PAR expr CLOSE_PAR 
    | NUMBER 
    | OP_SUB NUMBER
    | ID  
    | IDENT_CARACTER 
    | IDENT_CADENA
    | VERDADERO 
    | FALSO     
    | ID OPEN_BRA expr CLOSE_BRA 
    | ID OPEN_PAR args CLOSE_PAR 
;

%%