#ifndef __TREE_UTILS_H__
#define __TREE_UTILS_H__

#include <iostream>
#include "antlr4-runtime.h"
#include "json.hpp"

nlohmann::json to_json(antlr4::ParserRuleContext *ctx, antlr4::Parser *parser)
{
    nlohmann::json json;

    std::vector<nlohmann::json> children = {};
    for (auto child : ctx->children)
    {
        if (antlr4::ParserRuleContext *child_ctx = dynamic_cast<antlr4::ParserRuleContext *>(child))
        {
            children.push_back(to_json(child_ctx, parser));
        }
        else if (antlr4::tree::TerminalNode *terminal_node = dynamic_cast<antlr4::tree::TerminalNode *>(child))
        {
            children.push_back(terminal_node->getText());
        }
    }
    std::string rule_name = parser->getRuleNames()[ctx->getRuleIndex()];
    json[rule_name] = children;
    return json;
}

#endif