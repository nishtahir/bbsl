cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(bbsl VERSION 0.1 LANGUAGES CXX)
set (CMAKE_CXX_STANDARD 11)

add_subdirectory(antlr)
add_subdirectory(grammar)
add_subdirectory(bin)
add_subdirectory(test)