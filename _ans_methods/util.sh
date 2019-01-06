#!/bin/sh

#  AUTONOMOUS NODE SYSTEM
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com


# Sets value in json file (if file does not exist or invalid, it is recreated)
# Params:
# $1 - file
# $2 - key
# $3 - value
set_json_file_value() {
    if [ -s "$1" ]; then 
        JSON_VALUE=$(jq ". = if has(\"$2\") then .[\"$2\"] = \"$3\" else . + { \"$2\" : \"$3\" } end " "$1" )
        altValue="{ \"$2\":\"$3\" }"
        printf "%s\n" "${JSON_VALUE:-$altValue}" > "$1" # in case json file is invalid, we will overwrite it
    else 
        printf "%s\n" "{ \"$2\":\"$3\" }" > "$1"
    fi
} 

# returns JSON value stored in $JSON_VALUE variable
# $1 file
# $2 key
get_json_file_value() {
    JSON_VALUE=$(jq ".[\"$2\"]" "$1" -r 2>/dev/null)
    JSON_VALUE=$(if [ ! "$JSON_VALUE" = "null" ]; then printf "%s" "$JSON_VALUE"; fi)
}


# returns JSON value stored in $JSON_VALUE variable
# $1 string
# $2 key
get_json_value() {
    JSON_VALUE=$(printf "%s\n" "$1" | jq ".[\"$2\"]" -r 2>/dev/null)
    JSON_VALUE=$(if [ ! "$JSON_VALUE" = "null" ]; then printf "%s" "$JSON_VALUE"; fi)
}

# clones git repository to specified folder
# $1 - url to repository
# $2 - output directory
clone_repository() {
    if [ -n "$2" ]; then
        git clone "$1" "$2"
        return 0
    else 
        return 1
    fi
}

repository_branch_switch() {
    if [ -d "$1" ]; then
        BRANCH=${2:-master}
        git --git-dir="$1/.git" --work-tree="$1" checkout -f "$BRANCH"
        return 0
    else 
        return 1
    fi
}

# fetches latest changes into git repository
# $1 - path
update_repository() {
    if [ -d "$1" ]; then
        BRANCH=${2:-master}

        git --git-dir="$1/.git" --work-tree="$1" fetch --all && git --git-dir="$1/.git" --work-tree="$1" reset --hard "origin/$BRANCH"
        return 0
    else 
        return 1
    fi
}

# converts repository link to specific file raw link
# $1 - url to repository
# $2 - file path relative to repository
# $3 - branch (default master)
# returns $RESULT
repository_link_to_raw_link() {
    BRANCH=${3:-master}
    TEMP=$(echo "$1" | sed 's/https\:\/\/github\.com/https\:\/\/raw\.githubusercontent.com/g' | sed 's/.git$/\//g')
    RESULT="$TEMP$BRANCH/$2"
}

get_latest_github_release() {
    # shellcheck disable=SC2034
    RESULT=$(curl -sL "https://api.github.com/repos/$1/releases/latest" | jq ".[\"tag_name\"]" -r 2>/dev/null)                            
}