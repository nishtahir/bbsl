#ifndef __STRING_UTILS_H__
#define __STRING_UTILS_H__

#include <string>
#include <vector>
#include <iostream>
#include <sstream>

inline std::string join(const std::vector<std::string> &v, char c)
{
    std::string s;
    for (std::vector<std::string>::const_iterator p = v.begin(); p != v.end(); ++p)
    {
        s += *p;
        if (p != v.end() - 1)
        {
            s += c;
        }
    }
    return s;
}

inline void to_lower(std::string &s)
{
    for (std::string::iterator p = s.begin(); p != s.end(); ++p)
    {
        *p = tolower(*p);
    }
}

inline std::vector<std::string> split(std::string str, char delimiter)
{
    std::vector<std::string> internal;
    std::stringstream ss(str);
    std::string tok;

    while (getline(ss, tok, delimiter))
    {
        internal.push_back(tok);
    }
    return internal;
}

inline void left_pad(std::string &str, const size_t num, const char paddingChar = ' ')
{
    if (num > str.size())
    {
        str.insert(0, num - str.size(), paddingChar);
    }
}

inline void right_pad(std::string &str, const size_t num, const char paddingChar = ' ')
{
    str.append(num, paddingChar);
}

inline std::string &ltrim(std::string &s, const char *t = " \t\n\r\f\v")
{
    s.erase(0, s.find_first_not_of(t));
    return s;
}

inline std::string &rtrim(std::string &s, const char *t = " \t\n\r\f\v")
{
    s.erase(s.find_last_not_of(t) + 1);
    return s;
}

inline std::string &trim(std::string &s, const char *t = " \t\n\r\f\v")
{
    return ltrim(rtrim(s, t), t);
}

inline void replace_all(std::string &str, char ch1, char ch2)
{
    for (size_t i = 0; i < str.length(); ++i)
    {
        if (str[i] == ch1)
            str[i] = ch2;
    }
}

#endif