
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

if(CMTOOLS_CONFIG_INCLUDED)
	return()
endif()
set(CMTOOLS_CONFIG_INCLUDED ON)

include(${CMAKE_CURRENT_LIST_DIR}/cmtools-args.cmake)

# Functions summary:
# - cmtools_disable_in_sources_build
# - cmtools_set_classic_output_folders


# ! cmtools_disable_in_sources_build() 
# Don't allow to build in sources otherwise a makefile not generated by CMake can be overridden.
#
macro(cmtools_disable_in_sources_build)
	if(ARGC GREATER 0)
		message(FATAL_ERROR "Too many arguments")
	endif()

	set(CMAKE_DISABLE_SOURCE_CHANGES ON)
	set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
	message(STATUS "[cmtools] Disabled in-sources build")
endmacro()

# ! cmtools_set_classic_output_folders
#
# cmtools_set_output_folders(
#   [FOLDER <folder>] (default: ${CMAKE_BINARY_DIR}/targets)
# )
#
# \param:PREFIX PREFIX Prefix to use for the output folders
#
macro(cmtools_set_output_folders)
    cmake_parse_arguments(ARGS "" "FOLDER" "" ${ARGN})
    cmtools_default_argument(FUNCTION cmtools_set_output_folders PREFIX ARGS FIELDS FOLDER VALUE "${CMAKE_BINARY_DIR}/targets")

	# Runtime output directory: build/bin
	file(MAKE_DIRECTORY ${ARGS_FOLDER})
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${ARGS_FOLDER}/bin)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${ARGS_FOLDER}/bin)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${ARGS_FOLDER}/bin)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${ARGS_FOLDER}/bin)

	# Library output directory: build/bin
	file(MAKE_DIRECTORY ${ARGS_FOLDER}/lib)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${ARGS_FOLDER}/lib)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${ARGS_FOLDER}/lib)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO ${ARGS_FOLDER}/lib)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${ARGS_FOLDER}/lib)

	# Archive output directory: build/lib
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${ARGS_FOLDER}/lib)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${ARGS_FOLDER}/lib)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO ${ARGS_FOLDER}/lib)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${ARGS_FOLDER}/lib)

	message(STATUS "[cmtools] Set output folders to ${ARGS_FOLDER}")
endmacro()