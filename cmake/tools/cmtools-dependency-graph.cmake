##################################################################################
# MIT License                                                                    #
#                                                                                #
# Copyright (c) 2022 Mohammed Boujemaoui Boulaghmoudi                            #
#                                                                                #
# Permission is hereby granted, free of charge, to any person obtaining a copy   #
# of this software and associated documentation files (the "Software"), to deal  #
# in the Software without restriction, including without limitation the rights   #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      #
# copies of the Software, and to permit persons to whom the Software is          #
# furnished to do so, subject to the following conditions:                       #
#                                                                                #
# The above copyright notice and this permission notice shall be included in all #
# copies or substantial portions of the Software.                                #
#                                                                                #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  #
# SOFTWARE.                                                                      #
##################################################################################

include_guard(GLOBAL)

include(${CMAKE_CURRENT_LIST_DIR}/./../utility/cmtools-args.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/./../utility/cmtools-env.cmake)

cmt_disable_logger()
include(${CMAKE_CURRENT_LIST_DIR}/./../third_party/dependency-graph.cmake)
cmt_enable_logger()

# Functions summary:
# - cmt_dependency_graph

# ! cmt_find_dot
# Try to find the dot executable.
# If the executable is not found, the function will throw an error.
#
# cmt_find_dot(
#   EXECUTABLE
#   EXECUTABLE_FOUND
# )
#
# \output EXECUTABLE The path to the dot executable.
# \output EXECUTABLE_FOUND - True if the executable is found, false otherwise.
# \param BIN_SUBDIR - The subdirectory where the executable is located.
# \group NAMES - The name of the executable.
#
function (cmt_find_dot EXECUTABLE EXECUTABLE_FOUND)
    cmake_parse_arguments(ARGS "" "BIN_SUBDIR" "NAMES" ${ARGN})
    cmt_default_argument(ARGS NAMES "dot;")
    cmt_default_argument(ARGS BIN_SUBDIR bin)

    foreach (DOT_EXECUTABLE_NAME ${ARGS_NAMES})
         cmt_find_tool_executable (${DOT_EXECUTABLE_NAME}
                                  DOT_EXECUTABLE
                                  PATHS ${DOT_SEARCH_PATHS}
                                  PATH_SUFFIXES "${ARGS_BIN_SUBDIR}")
        if (DOT_EXECUTABLE)
            break ()
        endif ()
    endforeach ()

    cmt_report_not_found_if_not_quiet (dot DOT_EXECUTABLE
        "The 'dot' executable was not found in any search or system paths.\n"
        "Please adjust DOT_SEARCH_PATHS to the installation prefix of the 'dot' executable or install dot")

    # if (DOT_EXECUTABLE)
    #     set (DOT_VERSION_HEADER "dot - graphviz version ")
    #     cmt_find_tool_extract_version("${DOT_EXECUTABLE}"
    #                                   DOT_VERSION
    #                                   VERSION_ARG -V
    #                                   VERSION_HEADER
    #                                   "${DOT_VERSION_HEADER}"
    #                                   VERSION_END_TOKEN ")")
    # endif()
    set(DOT_VERSION "Unknown")
    cmt_check_and_report_tool_version(dot
                                      "${DOT_VERSION}"
                                      REQUIRED_VARS
                                      DOT_EXECUTABLE
                                      DOT_VERSION)
    set (EXECUTABLE ${DOT_EXECUTABLE} PARENT_SCOPE)
endfunction ()

# ! cmt_dependency_graph
# Builds a dependency graph of the active code targets using the `dot` application
#
# cmt_dependency_graph(
#   [OUTPUT_DIR <output>] # Default: ${CMAKE_CURRENT_BINARY_DIR} 
# )
#
# \param OUTPUT_DIR The output directory where the generated files will be stored.
#
macro(cmt_dependency_graph)
    cmake_parse_arguments(_PDG_ARGS "" "OUTPUT_DIR" "" ${ARGN})
    cmt_default_argument(_PDG_ARGS OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    if (CMT_ENABLE_DEPENDENCY_GRAPH)
        set(BUILD_DEP_GRAPH ON)
        cmt_find_dot(EXECUTABLE _)
        gen_dep_graph("png" TARGET_NAME dependency-graph-${PROJECT_NAME}  OUTPUT_DIR ${_PDG_ARGS_OUTPUT_DIR} ADD_TO_DEP_GRAPH)
    endif()
endmacro()