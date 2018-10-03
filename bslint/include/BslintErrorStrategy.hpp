#ifndef __BSLINT_ERROR_STRATEGY_H__
#define __BSLINT_ERROR_STRATEGY_H__
#include "DefaultErrorStrategy.h"
#include "StringUtils.hpp"

class BslintErrorStrategy : public antlr4::DefaultErrorStrategy
{
protected:
  virtual void reportNoViableAlternative(antlr4::Parser *recognizer, const antlr4::NoViableAltException &e)
  {
    auto tokens = e.getExpectedTokens().toList();
    std::string expected_tokens;
    for (std::vector<ssize_t>::const_iterator item = tokens.begin(); item != tokens.end(); ++item)
    {
      auto display_name = recognizer->getVocabulary().getDisplayName(*item);
      to_lower(display_name);

      expected_tokens += display_name;
      if (item != tokens.end() - 1)
      {
        expected_tokens += ", ";
      }
    }

    auto offending_token = e.getOffendingToken();
    auto msg = "mismatched input " + getTokenErrorDisplay(offending_token) + " expecting " + expected_tokens;
    recognizer->notifyErrorListeners(offending_token, msg, nullptr);
  }

  virtual void reportInputMismatch(antlr4::Parser *recognizer, const antlr4::InputMismatchException &e)
  {
    auto msg = "no viable at input " + escapeWSAndQuote(e.getOffendingToken()->getText());
    recognizer->notifyErrorListeners(e.getOffendingToken(), msg, nullptr);
  }
};

#endif
