cmake_minimum_required (VERSION 2.6)
project (LPP)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX)
find_package(BISON)

find_program (TREECC treecc
              PATHS /usr /usr/local /opt /opt/local $ENV{TREECC_DIR}
              PATH_SUFFIXES treecc/bin bin )

if (TREECC)
    message(STATUS "Using treecc executable ${TREECC}")
else(TREECC)
    message(FATAL_ERROR "treecc was not found. Try setting TREECC_DIR environment variable")
endif(TREECC)

# Run treecc to generate the AST
add_custom_command (
  OUTPUT LPPAst.cpp LPPAst.hpp
  COMMAND ${TREECC} -o LPPAst.cpp -h LPPAst.hpp ${PROJECT_SOURCE_DIR}/LPPAst.tc
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/LPPAst.tc
  )

FLEX_TARGET(LPPLexer LPPLexerImpl.l
            ${CMAKE_CURRENT_BINARY_DIR}/LPPLexerImpl.cpp
            DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/LPPLexerImpl.hpp
            )

BISON_TARGET(LPPParser LPPParserImpl.y
            ${CMAKE_CURRENT_BINARY_DIR}/LPPParserImpl.cpp
            DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/LPPParserImpl.hpp
            )

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_SOURCE_DIR})

add_executable(${PROJECT_NAME}
    ${FLEX_LPPLexer_OUTPUTS}
    ${BISON_LPPParser_OUTPUTS}
    LPPLexer.hpp
    LPPLexer.cpp
    LPPParser.hpp
    LPPParser.cpp
    LPPAst.hpp
    LPPAst.cpp
    main.cpp
 )
