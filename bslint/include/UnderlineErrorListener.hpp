#ifndef __UNDERLINE_ERROR_LISTENER_H__
#define __UNDERLINE_ERROR_LISTENER_H__

#include <iostream>

#include "BaseErrorListener.h"
#include "Recognizer.h"
#include "IntStream.h"
#include "antlr4-runtime.h"
#include "StringUtils.hpp"

class UnderlineErrorListener : public antlr4::BaseErrorListener
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
        std::cerr << file_name << ":" << line << ":" << charPositionInLine << ":"
                  << "error: " << msg << std::endl;

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
            std::cerr << underline << std::endl;
        }
    }
};

#endif