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

input: start { parse.setProgram(new Program($1)); }
;


start: dec_variable declaraciones_func_proc block { $$ = new InitialBlockStmt($1, $2, $3); } // {$$ = new Block(new Block($1, $2), $3); }
;

// BLOQUES.
block: INICIO statement_list FIN { $$ = $2; }
;

// PARÁMETROS.
params: param {$$ = new EmptyNode(); }
      | params COMMA param {$$ = new EmptyNode(); }
;

param: VAR ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type ID {$$ = new EmptyNode(); }
     | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type ID {$$ = new EmptyNode(); }
     | VAR type ID {$$ = new EmptyNode(); }
     | type ID {$$ = new EmptyNode(); }
;

type: ENTERO {$$ = new EmptyNode(); }
    | BOOLEANO {$$ = new EmptyNode(); }
    | CARACTER {$$ = new EmptyNode(); }
    | ID {$$ = new EmptyNode(); }
;

// declaraciones_func_proc.
declaraciones_func_proc: declaracion {  {$$ = new EmptyNode(); } }
             | declaraciones_func_proc declaracion { {$$ = new EmptyNode(); } }
             | {$$ = new EmptyNode(); }
;

declaracion:   dec_funcion {$$ = new EmptyNode(); }
            |  dec_procedimiento {$$ = new EmptyNode(); }
            |  {$$ = new EmptyNode(); }
;

dec_funcion: FUNCION ID OPEN_PAR params CLOSE_PAR COLON type dec_variable block {{$$ = new EmptyNode(); }}
            |FUNCION ID COLON type dec_variable block  {{$$ = new EmptyNode(); }}
            | {$$ = new EmptyNode(); } 
;


dec_procedimiento:  PROCEDIMIENTO ID OPEN_PAR params CLOSE_PAR dec_variable block {{$$ = new EmptyNode(); }}
                    | PROCEDIMIENTO ID dec_variable block {{$$ = new EmptyNode(); }}
;


dec_variable: dec_entero { $$ = $1; }
            | dec_booleano { $$ = $1; }
            | dec_caracter { $$ = $1;}
            | dec_arreglo
            | dec_tipo
            | dec_variable dec_entero { $$ = new DecVarStmt($1, $2);}
            | dec_variable dec_booleano { $$ = new DecVarStmt($1, $2); }
            | dec_variable dec_caracter { $$ = new DecVarStmt($1, $2); }
            | dec_variable dec_arreglo
            | dec_variable dec_tipo { }
            | {$$ = new EmptyNode(); }
;

dec_tipo:   TIPO ID ES type 
            | TIPO ID ES ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE type
            | nuevo_tipo

nuevo_tipo: ID
            | ID COMMA nuevo_tipo
;

dec_entero: ENTERO lista_dec_enteros { $$ = $2;}
;

lista_dec_enteros : ID { $$ = $1; {parse.addVectorDataType(((IdentExpr*)$1)->text, "entero");}}
                 | lista_dec_enteros COMMA ID { $$ = new IntDecl($1, (IdentExpr*)$3); parse.addVectorDataType(((IdentExpr*)$3)->text, "entero"); }
                 |  
;

dec_booleano: BOOLEANO lista_dec_booleanos { $$ = $2;}
;

lista_dec_booleanos : ID { $$ = $1; parse.addVectorDataType(((IdentExpr*)$1)->text, "booleano");}
                 | lista_dec_booleanos COMMA ID { $$ = new IntDecl($1, (IdentExpr*)$3); parse.addVectorDataType(((IdentExpr*)$3)->text, "booleano");}
                 |
;

dec_caracter: CARACTER lista_dec_caracteres  { $$ = $2; }
;

lista_dec_caracteres: ID { $$ = $1; parse.addVectorDataType(((IdentExpr*)$1)->text, "caracter");}
                 | lista_dec_caracteres COMMA ID { $$ = new IntDecl($1, (IdentExpr*)$3); parse.addVectorDataType(((IdentExpr*)$3)->text, "caracter");}
;

dec_arreglo:  ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE ENTERO ID 
            | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE BOOLEANO ID 
            | ARREGLO OPEN_BRA NUMBER CLOSE_BRA DE CARACTER ID
;

// STATEMENTS.
statement_list:  statement_list statement { $$ = new BlockStmt($1, $2); }
                | statement   { $$ = $1; {} }
;

block_statement: block_statement statement { $$ = new BlockStmt($1, $2); }
                | statement { $$ = $1; }
                | { $$ = new EmptyNode(); }
;

statement:  | print_statement { $$ = $1; }
            | assign_statement { $$ = $1;}
            | llamar_statement 
            | return_statement
            | mientras_statement { $$ = $1;}
            | para_statement { $$ = $1; }
            | repita_statement { $$ = $1;}
            | lea_statement { $$ = $1; }
            | si_statement { $$ = $1; }
            |
;

si_statement: SI expr ENTONCES block_statement si_else_statement
{
    $$ = new IfStmt($2, $4, $5);
}
;

si_else_statement: SINO_SI expr ENTONCES block_statement si_else_statement { $$ = new IfStmt($2, $4, $5);}
                 | SINO block_statement FIN_SI { $$ = new IfStmt(new BooleanExpr(1), $2, new EmptyNode());}
                 | FIN_SI { $$ = new EmptyNode(); }
;

return_statement: RETORNE expr
                | 
;

assign_statement: ID OP_ASSIGN expr { $$ = new AssignStmt($1, $3);}
                | ID OPEN_BRA expr CLOSE_BRA OP_ASSIGN expr
;

print_statement: ESCRIBA text { $$ = new PrintStmt($2);}
;

text: expr
    | expr COMMA text
;

lea_statement: LEA ID { $$ = new LeaStmt($2);}
            | LEA ID OPEN_BRA expr CLOSE_BRA
;

llamar_statement: LLAMAR ID OPEN_PAR args CLOSE_PAR 
                | LLAMAR ID
;

mientras_statement: MIENTRAS expr HAGA block_statement FIN MIENTRAS
{
    $$ = new WhileStmt($2, $4);
}
;

para_statement: PARA ID OP_ASSIGN expr HASTA expr HAGA block_statement FIN PARA
{
    $$ = new ForStmt(new AssignStmt($2, $4), $6, $8);
}
;

repita_statement: REPITA block_statement HASTA expr
{
    $$ = new RepitaStmt($4, $2);
}
;

// EXPRESSIONS.
args: expr
    | args COMMA expr
    |
;

expr: expr OP_ADD term { $$ = new AddExpr($1, $3);}  
    | expr OP_SUB term   { $$ = new SubExpr($1, $3);}
    | expr OP_GT term       { $$ = new GreaterExpr($1, $3); }
    | expr OP_GE term       { $$ = new GreaterOrEqualExpr($1, $3); }
    | expr OP_LT term       { $$ = new LessExpr($1, $3); }
    | expr OP_LE term       { $$ = new LessOrEqualExpr($1, $3);}
    | expr OP_EQ term       { $$ = new EqualExpr($1, $3); }
    | expr OP_NE term       { $$ = new NotEqualExpr($1, $3);}
    | expr Y term           { $$ = new AndExpr($1, $3); }
    | expr O term           { $$ = new OrExpr($1, $3); }
    | expr MOD term           { $$ = new ModExpr($1, $3);}
    | expr DIV term           { $$ = new DivExpr($1, $3);}
    | expr CARET term        { }
    | NO expr                  {  }
    | term                      { $$ = $1; }
;

term: term OP_MULT factor  { $$ = new MultExpr($1, $3); }
    | factor { $$ = $1; }                
;

factor: OPEN_PAR expr CLOSE_PAR 
    | NUMBER { $$ = $1; }
    | OP_SUB NUMBER 
    | ID  { $$ = $1;}
    | IDENT_CARACTER { $$ = $1; }
    | IDENT_CADENA  { $$ = $1; }
    | VERDADERO { $$ = $1; }
    | FALSO     { $$ = $1; }
    | ID OPEN_BRA expr CLOSE_BRA 
    | ID OPEN_PAR args CLOSE_PAR 
;

%%