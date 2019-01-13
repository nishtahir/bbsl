#ifndef __JSON_ERROR_LISTENER_H__
#define __JSON_ERROR_LISTENER_H__
#include "BaseErrorListener.h"
#include "json.hpp"

class JsonErrorListener : public antlr4::BaseErrorListener
{
  public:
    JsonErrorListener(std::vector<std::string> *error_list) : errors(error_list) {}

    void syntaxError(antlr4::Recognizer *recognizer,
                     antlr4::Token *offendingSymbol,
                     size_t line,
                     size_t charPositionInLine,
                     const std::string &msg,
                     std::exception_ptr e)
    {
        nlohmann::json json;
        json["msg"] = msg;
        json["line"] = line;
        json["column"] = charPositionInLine;
        errors->push_back(json.dump());
    }

  private:
    std::vector<std::string> *errors;
};

#endif