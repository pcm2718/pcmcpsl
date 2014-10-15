cmake_minimum_required(VERSION 3.0)

# The lex and yacc processing needs to be done first.
project(lexcpsl)
project(yacccpsl)

project(pcmcpsl)

#set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)
message(STATUS "Compiling ${PROJECT_NAME} .")



# Function to list all header files in the current directory, recursing into sub-directories
# HEADER_FILES - To be filled with the found header files
function(sdk_list_header_files HEADER_FILES)
	file(GLOB_RECURSE HEADER_FILES_TMP "*.h" "*.hpp")
	set(HEADER_FILES ${HEADER_FILES_TMP} PARENT_SCOPE)
endfunction()

# Function to list all source files in the current directory, recursing into sub-directories
# SOURCE_FILES - To be filled with the found source files
function(sdk_list_source_files HEADER_FILES)
	file(GLOB_RECURSE SOURCE_FILES_TMP "*.c" "*.cpp")
	set(SOURCE_FILES ${SOURCE_FILES_TMP} PARENT_SCOPE)
endfunction()



# This flag choice here is from
# https://github.com/Jesse-V/Folding-Atomata/blob/master/src/CMakeLists.txt .
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "-lfl -g -O3 --std=c++11 -Wno-c++98-compat-pedantic -pedantic -Weverything -Wno-unused-parameter -Wno-global-constructors -Wno-exit-time-destructors -Wno-non-virtual-dtor -Wno-weak-vtables -Wno-padded -Wno-cast-align -Wno-gnu -Wno-nested-anon-types -Wno-documentation-unknown-command -Wno-unknown-pragmas")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "-lfl -g -O3 --std=c++11 -Wall -Wextra -Wdouble-promotion -Wfloat-equal -Wunsafe-loop-optimizations -Wno-unused-parameter")
endif()



FIND_PACKAGE(BISON REQUIRED)
SET(BisonOutput src/lexyacc/pcmcpsl.tab.hpp src/lexyacc/pcmcpsl.tab.cpp)
SET(BISON_EXECUTABLE bison)
IF(BISON_FOUND)
    ADD_CUSTOM_COMMAND(
      OUTPUT ${BisonOutput}
      COMMAND ${BISON_EXECUTABLE}
              --defines=src/lexyacc/pcmcpsl.tab.hpp
              --output=src/lexyacc/pcmcpsl.tab.cpp
              src/lexyacc/pcmcpsl.y
      COMMENT "Generating pcmcpsl.tab.hpp"
      COMMENT "Generating pcmcpsl.tab.cpp"
    )
ENDIF()

FIND_PACKAGE(FLEX REQUIRED)
SET(FlexOutput src/lexyacc/pcmcpsl.yy.cpp)
SET(FLEX_EXECUTABLE flex)
IF(FLEX_FOUND)
    ADD_CUSTOM_COMMAND(
      OUTPUT ${FlexOutput}
      COMMAND ${FLEX_EXECUTABLE}
              --outfile=${FlexOutput}
              src/lexyacc/pcmcpsl.l
      COMMENT "Generating pcmcpsl.yy.cpp"
    )
ENDIF()

# ADD_LIBRARY(MyLib ${BisonOutput} ${FlexOutput})



set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin)
add_executable( pcmcpsl

		src/main.cpp
		src/compiler.hpp
		src/compiler.cpp


		${BisonOutput}
		${FlexOutput})



# Add some sweet install features here later.



#include_directories("${PROJECT_SOURCE_DIR}/src")
#add_subdirectory(src)
