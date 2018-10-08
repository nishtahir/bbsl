#include <iostream>
#include <fstream>
#include <string>
#include <cerrno>
#include <regex>

#include "antlr4-runtime.h"
#include "BrightScriptLexer.h"
#include "BrightScriptParser.h"
#include "Recognizer.h"

#include "cxxopts.hpp"
#include "terminal_error_strategy.hpp"
#include "terminal_error_listener.hpp"
#include "tree_utils.hpp"

using namespace antlr4;
using namespace std;
using namespace cxxopts;

void parseFiles(vector<string> paths, bool print_parse_tree = false, bool report_errors = true)
{
    for (const auto &path : paths)
    {
        ANTLRFileStream input(path);
        BrightScriptLexer lexer(&input);
        CommonTokenStream tokens(&lexer);
        BrightScriptParser parser(&tokens);

        antlr4::ParserRuleContext *tree;

        try
        {
            parser.setErrorHandler(make_shared<BailErrorStrategy>());
            auto interpreter = parser.getInterpreter<atn::ParserATNSimulator>();
            interpreter->setPredictionMode(atn::PredictionMode::SLL);
            tree = parser.startRule();
        }
        catch (ParseCancellationException e)
        {
            if (report_errors)
            {
                parser.reset();
                auto interpreter = parser.getInterpreter<atn::ParserATNSimulator>();
                interpreter->setPredictionMode(atn::PredictionMode::LL);

                auto err_listener = TerminalErrorListener();
                parser.removeErrorListeners();
                parser.addErrorListener(&err_listener);
                parser.setErrorHandler(make_shared<TerminalErrorStrategy>());
            }
        }

        if (print_parse_tree)
        {
            std::cout << to_json(tree, &parser) << std::endl;
        }
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
        options_adder("print-tree", "Print parse tree");
        options_adder("no-lint", "Disable error reporting");
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
            auto report_errors = !parse_result.count("no-lint");
            auto print_tree = parse_result.count("print-tree");

            parseFiles(files, print_tree, report_errors);
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
