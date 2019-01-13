#ifdef EMSCRIPTEN
#include <emscripten.h>
#define ENV_EMSCRIPEN
/*
reference https://code.woboq.org/userspace/glibc/posix/glob.h.html#_M/GLOB_TILDE
 */
#define GLOB_TILDE (1 << 12)
#else
#define ENV_UNIX
#endif

#include <iostream>
#include <fstream>
#include <string>
#include <cerrno>
#include <regex>
#include <glob.h>

#include "antlr4-runtime.h"
#include "BrightScriptLexer.h"
#include "BrightScriptParser.h"
#include "Recognizer.h"

#include "file_utils.hpp"
#include "cxxopts.hpp"
#include "terminal_error_strategy.hpp"
#include "terminal_error_listener.hpp"
#include "tree_utils.hpp"

using namespace antlr4;
using namespace std;
using namespace cxxopts;

struct Config
{
    bool print_parse_tree;
    bool verbose;
    bool no_lint;
    bool full_grammar;
};

extern "C" vector<string> parseFile(string content) {
    
}

void parseFiles(vector<string> paths, Config &config)
{

    if (config.verbose)
    {
        for (const auto &path : paths)
        {
            cout << path << endl;
        }
    }

    for (const auto &path : paths)
    {
        if (!file_exists(path))
        {
            cerr << "File not found for '" + path + "'" << endl;
            continue;
        }

        ANTLRFileStream input(path);
        BrightScriptLexer lexer(&input);
        CommonTokenStream tokens(&lexer);
        BrightScriptParser parser(&tokens);

        parser.removeErrorListeners();

        antlr4::ParserRuleContext *tree;
        try
        {
            parser.setErrorHandler(make_shared<BailErrorStrategy>());
            auto interpreter = parser.getInterpreter<atn::ParserATNSimulator>();
            interpreter->setPredictionMode(atn::PredictionMode::SLL);
            tree = parser.startRule();
        }
        catch (ParseCancellationException &)
        {
            if (config.no_lint == false)
            {
                tokens.reset();
                parser.reset();

                auto err_listener = TerminalErrorListener();
                parser.addErrorListener(&err_listener);
                parser.setErrorHandler(make_shared<TerminalErrorStrategy>());

                auto interpreter = parser.getInterpreter<atn::ParserATNSimulator>();
                interpreter->setPredictionMode(atn::PredictionMode::LL);

                tree = parser.startRule();
            }
        }

        if (config.print_parse_tree && tree != nullptr)
        {
            std::cout << to_json(tree, &parser) << std::endl;
        }
    }
}

vector<string> expand_paths(vector<string> &glob_paths)
{
#if defined(ENV_EMSCRIPEN)
    chdir("/working");
#endif
    glob_t globbuf;
    vector<string> file_list = {};

    for (auto pattern : glob_paths)
    {
        glob(pattern.c_str(), GLOB_TILDE, NULL, &globbuf);
        for (size_t i = 0; i < globbuf.gl_pathc; ++i)
        {
            file_list.push_back(globbuf.gl_pathv[i]);
        }
    }

    if (globbuf.gl_pathc > 0)
    {
        globfree(&globbuf);
    }

    return file_list;
}

void setup_file_system()
{
#if defined(ENV_EMSCRIPEN)
    EM_ASM(
        FS.mkdir('/working');
        FS.mount(NODEFS, {root : '.'}, '/working'););
#endif
}

int main(int argc, char **argv)
{
    setup_file_system();
    try
    {
        Options options(argv[0]);
        auto options_adder = options.add_options();
        options_adder("v,verbose", "Show verbose output", value<bool>());
        options_adder("h,help", "Print help");
        options_adder("print-tree", "Print parse tree as JSON");
        options_adder("no-lint", "Disable error reporting");
        options_adder("full-grammar", "Lint against the full Brightscript Language specification");
        options_adder("sources", "Source files", value<vector<string>>());

        options.parse_positional("sources");
        options.positional_help("<source files>").show_positional_help();

        auto parse_result = options.parse(argc, argv);

        if (parse_result.count("help"))
        {
            cout << options.help() << endl;
            exit(0);
        }

        Config conf;
        conf.no_lint = parse_result.count("no-lint");
        conf.print_parse_tree = parse_result.count("print-tree");
        conf.verbose = parse_result.count("verbose");
        conf.full_grammar = parse_result.count("full-grammar");

        if (parse_result.count("sources"))
        {
            auto glob_paths = parse_result["sources"].as<vector<string>>();
            auto file_list = expand_paths(glob_paths);
            parseFiles(file_list, conf);
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
