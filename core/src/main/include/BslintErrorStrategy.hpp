#ifndef __BSLINT_ERROR_STRATEGY_H__
#define __BSLINT_ERROR_STRATEGY_H__
#include "DefaultErrorStrategy.h"
#include "StringUtils.h"

using namespace antlr4;

class BslintErrorStrategy : public DefaultErrorStrategy
{
protected:
  virtual void reportNoViableAlternative(Parser *recognizer, const NoViableAltException &e)
  {
    auto tokens = e.getExpectedTokens().toList();
    string expected_tokens;
    for (vector<ssize_t>::const_iterator item = tokens.begin(); item != tokens.end(); ++item)
    {
      expected_tokens += recognizer->getVocabulary().getDisplayName(*item);
      if (item != tokens.end() - 1)
      {
        expected_tokens += ",";
      }
    }

    auto offendingToken = e.getOffendingToken();
    auto msg = "mismatched input " + getTokenErrorDisplay(offendingToken) + "expecting" + expected_tokens;
    recognizer->notifyErrorListeners(offendingToken, msg, nullptr);
  }

  virtual void reportInputMismatch(Parser *recognizer, const InputMismatchException &e)
  {
    auto msg = "no viable at input " + escapeWSAndQuote(e.getOffendingToken()->getText());
    recognizer->notifyErrorListeners(e.getOffendingToken(), msg, nullptr);
  }
};

#endif
