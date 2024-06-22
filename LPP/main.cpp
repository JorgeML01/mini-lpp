#include <iostream>
#include <fstream>
#include "LPPLexer.hpp"
#include "LPPParser.hpp"
#include <sstream>
#include <cstdio>
#include <string>

std::string EAsm_Path = "../EasyASM-x86";

// Función para ejecutar un comando y capturar su salida
int runCmd(const std::string& cmd, std::string& output)
{
    FILE *stream = popen(cmd.c_str(), "r");
    if (stream == nullptr) {
        throw std::runtime_error("popen() failed!");
    }

    std::ostringstream ssdata;
    char buffer[256] = {0};

    while (fgets(buffer, sizeof(buffer) - 1, stream)) {
        ssdata << buffer;
    }

    int status = pclose(stream);
    output = ssdata.str();
    return status == 0 ? 0 : 1;
}

// Función para escribir el código ensamblador en un archivo y ejecutarlo
int runAsm(const char *filename, const std::string& code, std::string& output)
{
    std::string asm_file = std::string(filename);

    std::ofstream out(asm_file, std::ios::out | std::ios::trunc);
    if (!out.is_open()) {
        throw std::runtime_error("Failed to open asm file for writing!");
    }
    out << code << "\n";
    out.close();

    std::string cmd = EAsm_Path + " --run " + asm_file + " 2>&1";
    return runCmd(cmd, output);
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

        std::string output;
        int status = runAsm(outputFile.c_str(), generatedCode, output);
        std::cout << output << std::endl;
        
        return status;

    } catch(const std::runtime_error& ex){
        std::cerr << ex.what() << "\n";   
        return 1; 
    } catch (...) {
        std::cerr << "An unknown error occurred\n";
        return 1; 
    }
}
