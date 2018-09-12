#include <iostream>

#include "antlr4-runtime.h"
#include "BrightScriptLexer.h"
#include "BrightScriptParser.h"
#include "cxxopts.hpp"

using namespace antlr4;
using namespace std;
using namespace cxxopts;

#include <fstream>
#include <string>
#include <cerrno>

int parseFiles(vector<string> paths)
{
    for (const auto &path : paths)
    {
        cout << path << endl;
        ifstream file_stream(path, ios::in | ios::binary);
        if (file_stream)
        {
            ANTLRInputStream input(file_stream);
            BrightScriptLexer lexer(&input);
            CommonTokenStream tokens(&lexer);
            BrightScriptParser parser(&tokens);
            
            tree::ParseTree *tree = parser.startRule();

            file_stream.close();
        }
        else
        {
            throw(errno);
        }

        // parser.removeErrorListeners();
    }
}

int main(int argc, char **argv)
{
    try
    {
        Options options(argv[0]);
        auto options_adder = options.add_options();
        options_adder("v,verbose", "Show verbose output", value<bool>());
        options_adder("h,help", "Print help");
        options_adder("sources", "Source files", value<vector<string>>());

        options.parse_positional("sources");
        options.positional_help("<source files>").show_positional_help();

        auto parse_result = options.parse(argc, argv);

        if (parse_result.count("help"))
        {
            cout << options.help() << endl;
            exit(0);
        }

        if (parse_result.count("sources"))
        {
            auto &files = parse_result["sources"].as<vector<string>>();
            parseFiles(files);
        }
        else
        {
            cout << options.help() << endl;
        }
    }
    catch (const cxxopts::OptionException &e)
    {
        cout << "Error parsing options: " << e.what() << endl;
        exit(1);
    }

    return 0;
}
