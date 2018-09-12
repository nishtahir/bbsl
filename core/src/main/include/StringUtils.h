#ifndef __STRING_UTILS_H__
#define __STRING_UTILS_H__

#include <string>
#include <vector>
#include <iostream>

using namespace std;

inline string join(const vector<string> &v, char c)
{
    string s;
    for (vector<string>::const_iterator p = v.begin(); p != v.end(); ++p)
    {
        s += *p;
        if (p != v.end() - 1)
        {
            s += c;
        }
    }
    return s;
}

#endif