
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


%token OpAdd "+"
%token OpSub "-"
%token OpMult "*"
%token OpenPar "("
%token ClosePar ")"
%token Number "number"
%token SemiColon ";"
%token ID "ID"
%token OpEq "="
%token OpCurBra "{"
%token OpCloBra "}"
%token INT "int"
%token FOR "for"
%token OpGt ">"
%token OpLt "<"
%token OpGe ">="
%token OpLe "<="
%token OpNe "!="
%token OpInc "++"
%token OpDec "--"
%token IF, "if",
%token ELSE, "else"

%% 

input: statement_list
;

statement_list: statement
            | statement_list statement
;

statement:  | print_statement
            | assign_statement
            | if_statement
           
;

assign_statement:ID OpEq expr SemiColon { 
                                            parse.addVar(std::get<std::string>($1), std::get<double>($3));
                                        }
;

print_statement: ID SemiColon           { 
                                            std::cout <<  std::get<std::string>($1) << "=" << parse.getVar(std::get<std::string>($1)) << std::endl;
                                        }
;

if_statement: IF OpenPar expr ClosePar OpCurBra statement_list OpCloBra {

    if (std::get<bool>($3))
    {
        std::cout << "TRUE " << std::get<bool>($3) << std::endl;
    }
    {
        std::cout << "FALSE " << std::get<bool>($3) << std::endl;
    }
}
;

expr: expr OpAdd term   { $$ = std::get<double>($1) + std::get<double>($3);}
    | expr OpSub term   { $$ = std::get<double>($1) - std::get<double>($3);}

    | expr OpGt term       { $$ = std::get<double>($1) > std::get<double>($3);}
    | expr OpGe term       { $$ = std::get<double>($1) >= std::get<double>($3);}
    | expr OpLt term       { $$ = std::get<double>($1) < std::get<double>($3);}
    | expr OpLe term       { $$ = std::get<double>($1) <= std::get<double>($3);}

    | term              { $$ = $1;}
;

term: term OpMult factor      { $$ = std::get<double>($1) * std::get<double>($3);}
    | factor                  { $$ = $1;}
;

factor: OpenPar expr ClosePar { $$ = $2; }
      | Number { $$ = $1;}
      | ID  { 
                $$ = parse.getVar(std::get<std::string>($1));
            } 
;
%%
