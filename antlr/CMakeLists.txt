cmake_minimum_required(VERSION 3.5)
project(antlr-runtime)

include_directories(
        ${PROJECT_SOURCE_DIR}/src/
)

file(GLOB_RECURSE _HDRS "src/*.h")
file(GLOB_RECURSE _SRCS "src/*.cpp")

add_library(antlr-runtime ${_HDRS} ${_SRCS})
target_include_directories(antlr-runtime PUBLIC ${PROJECT_SOURCE_DIR}/src/)

install(TARGETS antlr-runtime DESTINATION antlr-runtime)
install(FILES ${_HDRS} DESTINATION include/antlr-runtime)