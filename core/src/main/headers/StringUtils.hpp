#ifndef __STRING_UTILS_H__
#define __STRING_UTILS_H__

#include <string>
#include <vector>
#include <iostream>

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

#endif