#ifndef __FILE_UTILS_H__
#define __FILE_UTILS_H__

#include <iostream>

inline bool file_exists(const std::string &path)
{
    if (FILE *file = fopen(path.c_str(), "r"))
    {
        fclose(file);
        return true;
    }
    return false;
}

#endif