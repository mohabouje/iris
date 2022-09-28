#!/bin/bash
#
# This script is used to upgrade the dependencies of this project.
# It is intended to be run by the CI system, but can be run manually.
# It is not intended to be run by the end user.
#

# the directory of the script
CURRENT_DIRECTORY="$(git rev-parse --show-toplevel)"
WORKING_DIRECTORY="${CURRENT_DIRECTORY}/.$(date '+%Y-%m-%d')"
mkdir -p "${WORKING_DIRECTORY}"
if [ ! -d "${WORKING_DIRECTORY}" ]; then
  echo "ERROR: Could not create temporal directory: ${WORKING_DIRECTORY}"
  exit 1
fi

function cleanup {      
  rm -rf "$WORKING_DIRECTORY"
  echo "Clean up of all temporal files"
}

trap cleanup EXIT

# Function to download a file to a specific location
# It does create the directory if it does not exist
# $1 - the url to download
# $2 - the location to download to
function download {
    mkdir -p `dirname $2`
    curl -s --create-dirs -L $1 -o $2
}


# Function to download a file to an specific location
# It will download the file only if it does not exist
# or if the file has a different checksum
# $1: URL to download
# $2: Destination file
function upgrade_file {
    if [ ! -f "${2}" ]
    then
        echo "File not found. Downloading ${1} to ${2}"
        download "${1}" "${2}"
        return
    fi

    local current_checksum=$(sha256sum "${2}" | cut -d' ' -f1)
    local temporal_file="${WORKING_DIRECTORY}/${1}"
    download  "${1}" "${temporal_file}"
    local new_checksum=$(sha256sum "${temporal_file}" | cut -d' ' -f1)

    if [ "${current_checksum}" != "${new_checksum}" ]
    then
        echo "Upgrade required. Downloading ${1} to ${2}"
        mv "${temporal_file}" "${2}"
    else
        echo "No upgrade required. ${2} is already up to date"
        rm "${temporal_file}"
    fi
}

# Function to download a file from github into an specific path
# $1: github user
# $2: github project
# $3: github branch
# $4: file to download
# $5: path to download the file
function upgrade_github {
    local user=$1
    local project=$2
    local branch=$3
    local file=$4
    local path=$5
    local url="https://github.com/${user}/${project}/raw/${branch}/${file}"
    echo "Downloading version from the ${branch} branch of ${user}/${project}/${file} to ${path}"
    upgrade_file "${url}" "${path}"
}

# Function to download a file from github [master branch] into an specific path
# $1: github user
# $2: github project
# $3: file to download
# $4: path to download the file
function upgrade_github_master {
    local user=$1
    local project=$2
    local file=$3
    local path=$4
    upgrade_github "${user}" "${project}" "master" "${file}" "${path}"
}

upgrade_github_master onqtam ucm  cmake/ucm.cmake "${CURRENT_DIRECTORY}/cmake/third_party/ucm.cmake"
upgrade_github_master sakra cotire  CMake/cotire.cmake "${CURRENT_DIRECTORY}/cmake/third_party/cotire.cmake"
upgrade_github_master sbellus json-cmake  JSONParser.cmake "${CURRENT_DIRECTORY}/cmake/third_party/json-parse.cmake"