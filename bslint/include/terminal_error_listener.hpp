#ifndef __UNDERLINE_ERROR_LISTENER_H__
#define __UNDERLINE_ERROR_LISTENER_H__

#include <iostream>

#include "antlr4-runtime.h"
#include "BaseErrorListener.h"
#include "Recognizer.h"
#include "IntStream.h"
#include "rang.hpp"

#include "string_utils.hpp"

class TerminalErrorListener : public antlr4::BaseErrorListener
{

  protected:
    virtual void syntaxError(antlr4::Recognizer *recognizer,
                             antlr4::Token *offendingSymbol,
                             size_t line,
                             size_t charPositionInLine,
                             const std::string &msg,
                             std::exception_ptr e)
    {

        auto input_stream = recognizer->getInputStream();
        auto file_name = input_stream->getSourceName();

        print_err(file_name, line, charPositionInLine, msg);

        if (antlr4::CommonTokenStream *tokenStream = dynamic_cast<antlr4::CommonTokenStream *>(input_stream))
        {
            auto source = tokenStream->getTokenSource()->getInputStream()->toString();
            auto lines = split(source, '\n');

            auto error_line = lines[line - 1];
            std::cerr << error_line << std::endl;

            std::string underline = "";
            right_pad(underline, charPositionInLine);

            int start = offendingSymbol->getStartIndex();
            int stop = offendingSymbol->getStopIndex();
            int size = (stop - start) + 1;

            if (size > 0)
            {
                right_pad(underline, size, '^');
            }
            std::cerr << rang::fg::red << underline << rang::style::reset << std::endl;
        }
    }

    void print_err(const std::string &path, int line, int column, const std::string &msg)
    {
        std::cerr << rang::style::bold
                  << path << ":" << line << ":" << column << ":"
                  << rang::fg::red << "error"
                  << rang::style::reset << ": " << msg
                  << std::endl;
    }
};

#endif