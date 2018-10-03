cmake_minimum_required(VERSION 3.5)
project(grammar)

include_directories(
        ${PROJECT_SOURCE_DIR}/build/generated/
)

# The sources for the grammar are generated via the Gradle Antlr plugin
file(GLOB_RECURSE _HDRS "${PROJECT_SOURCE_DIR}/generated/*.h")
file(GLOB_RECURSE _SRCS "${PROJECT_SOURCE_DIR}/generated/*.cpp")

add_library(grammar ${_HDRS} ${_SRCS})

target_include_directories(grammar PUBLIC 
        ${PROJECT_SOURCE_DIR}/generated/
)

target_link_libraries(grammar antlr-runtime)

install(TARGETS grammar DESTINATION grammar)
install(FILES ${_HDRS} DESTINATION include/grammar)