#include <iostream>
#include <fstream>
#include "LPPLexer.hpp"
#include "LPPParser.hpp"
#include <sstream>
#include <cstdio>
#include <string>

std::string EAsm_Path = "../EasyASM-x86";

// Función para ejecutar un comando y capturar su salida
std::string runCmd(const std::string& cmd)
{
    FILE *stream = popen(cmd.c_str(), "r");
    if (stream == nullptr) {
        throw std::runtime_error("popen() failed!");
    }

    std::ostringstream ssdata;
    char buffer[256] = {0};

    while (fgets(buffer, sizeof(buffer) - 1, stream))
        ssdata << buffer;

    pclose(stream);
    return ssdata.str();
}

// Función para escribir el código ensamblador en un archivo y ejecutarlo
std::string runAsm(const char *filename, const std::string& code)
{
    std::string asm_file = std::string(filename);

    std::ofstream out(asm_file, std::ios::out | std::ios::trunc);
    if (!out.is_open()) {
        throw std::runtime_error("Failed to open asm file for writing!");
    }
    out << code << "\n";
    out.close();

    std::string cmd = EAsm_Path + " --run " + asm_file + " 2>&1";
    return runCmd(cmd);
}

int main(int argc, char *argv[]) 
{
    if (argc != 3) {
        std::cerr << "Not enough CLI arguments\n";
        return 1;
    }

    std::string inputFile = argv[1];
    std::string outputFile = argv[2];

    std::ifstream in(inputFile, std::ios::in);
    if (!in.is_open()) {
        std::cerr << "Cannot open input file\n";
        return 1;
    }

    LPPLexer lexer(in);
    LPPParser parser(lexer);
    try {
        parser.parse();
        std::string generatedCode = parser.getProgram()->genProgramCode(parser.getSymbolVectorDataTypes());

        std::string output = runAsm(outputFile.c_str(), generatedCode);
        std::cout << output << std::endl;

    } catch(const std::runtime_error& ex){
        std::cerr << ex.what() << "\n";   
    }

}

