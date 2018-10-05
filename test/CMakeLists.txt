cmake_minimum_required(VERSION 3.5)
project(test)
include_directories(${PROJECT_SOURCE_DIR}/include)

file(GLOB_RECURSE _HDRS 
    "${PROJECT_SOURCE_DIR}/include/*.h"
    "${PROJECT_SOURCE_DIR}/include/*.hpp"
)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -g")

file(GLOB_RECURSE _SRCS "${PROJECT_SOURCE_DIR}/src/*.cpp")

add_executable(test ${_HDRS} ${_SRCS})
target_link_libraries(test antlr-runtime grammar)