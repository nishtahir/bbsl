#ifndef __TERMINAL_ERROR_STRATEGY_H__
#define __TERMINAL_ERROR_STRATEGY_H__

#include "DefaultErrorStrategy.h"
#include "string_utils.hpp"

class TerminalErrorStrategy : public antlr4::DefaultErrorStrategy
{
protected:
  void reportNoViableAlternative(antlr4::Parser *recognizer, const antlr4::NoViableAltException &e) override
  {
    auto offending_token = e.getOffendingToken();
    auto msg = "no viable alternative at input " + escapeWSAndQuote(e.getOffendingToken()->getText());
    recognizer->notifyErrorListeners(offending_token, msg, nullptr);
  }

  void reportInputMismatch(antlr4::Parser *recognizer, const antlr4::InputMismatchException &e) override
  {
    auto tokens = e.getExpectedTokens().toList();
    std::string expected_tokens = create_token_list(recognizer, tokens);

    auto offending_token = e.getOffendingToken();
    auto msg = "mismatched input " + getTokenErrorDisplay(offending_token) + " expecting " + expected_tokens;
    recognizer->notifyErrorListeners(e.getOffendingToken(), msg, nullptr);
  }

  void reportUnwantedToken(antlr4::Parser *recognizer) override
  {
    antlr4::Token *t = recognizer->getCurrentToken();
    std::string token = getTokenErrorDisplay(t);
    auto expecting = getExpectedTokens(recognizer).toList();

    std::string msg = "extraneous input " + token + " expecting " + create_token_list(recognizer, expecting);
    recognizer->notifyErrorListeners(t, msg, nullptr);
  }

  void reportMissingToken(antlr4::Parser *recognizer) override
  {
    antlr4::Token *t = recognizer->getCurrentToken();
    auto expecting = getExpectedTokens(recognizer).toList();
    std::string msg = "missing " + create_token_list(recognizer, expecting) + " at " + getTokenErrorDisplay(t);

    recognizer->notifyErrorListeners(t, msg, nullptr);
  }

private:
  std::string create_token_list(antlr4::Parser *recognizer, std::vector<ssize_t> tokens)
  {
    std::string expected_tokens;
    for (std::vector<ssize_t>::const_iterator item = tokens.begin(); item != tokens.end(); ++item)
    {
      auto display_name = recognizer->getVocabulary().getDisplayName(*item);
      to_lower(display_name);
      replace_all(display_name, '_', ' ');

      expected_tokens += display_name;
      if (item != tokens.end() - 1)
      {
        expected_tokens += ", ";
      }
    }
    return expected_tokens;
  }
};

#endif
