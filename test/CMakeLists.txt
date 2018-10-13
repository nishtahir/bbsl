cmake_minimum_required(VERSION 3.5)
project(TEST)
include_directories(${PROJECT_SOURCE_DIR}/include)

file(GLOB_RECURSE _HDRS 
    "${PROJECT_SOURCE_DIR}/include/*.h"
    "${PROJECT_SOURCE_DIR}/include/*.hpp"
)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -g")

file(GLOB_RECURSE _SRCS "${PROJECT_SOURCE_DIR}/src/*.cpp")

add_executable(TEST ${_HDRS} ${_SRCS})
target_link_libraries(TEST antlr-runtime grammar)