cmake_minimum_required(VERSION 3.5)
project(bslint)
include_directories(
  ${PROJECT_SOURCE_DIR}/include
  ${PROJECT_SOURCE_DIR}/lib
)

file(GLOB_RECURSE _HDRS 
    "${PROJECT_SOURCE_DIR}/include/*.h"
    "${PROJECT_SOURCE_DIR}/include/*.hpp"
    "${PROJECT_SOURCE_DIR}/lib/*.h"
    "${PROJECT_SOURCE_DIR}/lib/*.hpp"
)

file(GLOB_RECURSE _SRCS "${PROJECT_SOURCE_DIR}/src/*.cpp")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(CMAKE_BINARY_DIR "${CMAKE_HOME_DIRECTORY}/dist")
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
message(STATUS "Outputing artifact to ${CMAKE_BINARY_DIR}")

add_executable(bslint ${_HDRS} ${_SRCS})
target_link_libraries(bslint antlr-runtime grammar)

#install(TARGETS bslint DESTINATION bin)