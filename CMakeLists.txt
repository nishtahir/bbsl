cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(bslint VERSION 0.1 LANGUAGES CXX)
set (CMAKE_CXX_STANDARD 11)

add_subdirectory(antlr)
add_subdirectory(grammar)
add_subdirectory(bslint)
add_subdirectory(test)