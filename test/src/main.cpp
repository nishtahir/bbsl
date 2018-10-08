#define CATCH_CONFIG_MAIN
#include "catch.hpp"

#include <iostream>
#include <fstream>
#include <string>
#include <cerrno>

#include "antlr4-runtime.h"
#include "BrightScriptLexer.h"
#include "BrightScriptParser.h"
#include "Recognizer.h"

using namespace std;
using namespace antlr4;

unsigned int Factorial(unsigned int number)
{
    return number <= 1 ? number : Factorial(number - 1) * number;
}

TEST_CASE("Factorials are computed", "[factorial]")
{
    REQUIRE(Factorial(1) == 1);
    REQUIRE(Factorial(2) == 2);
    REQUIRE(Factorial(3) == 6);
    REQUIRE(Factorial(10) == 3628800);
}

tree::ParseTree *build_parse_tree(string path)
{
    ANTLRFileStream input(path);
    BrightScriptLexer lexer(&input);
    CommonTokenStream tokens(&lexer);
    BrightScriptParser parser(&tokens);
    return parser.startRule();
}