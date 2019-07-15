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

#######################################################################################
############                THIS MODULE IS NOT STANDALONE                  ############  
#######################################################################################

PATH_TO_SCRIPT=$(readlink -f "$0")
METHODS_DIR=$(dirname "$PATH_TO_SCRIPT")

SUPPORTED_NODES_URL="https://raw.githubusercontent.com/cryon-io/ans/master/supported_nodes.json"

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/util.sh" ] && . "$METHODS_DIR/util.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/util.sh"  ] && . "$METHODS_DIR/_ans_methods/util.sh" 

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/prints.sh" ] && . "$METHODS_DIR/prints.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/prints.sh"  ] && . "$METHODS_DIR/_ans_methods/prints.sh" 

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/json.sh" ] && . "$METHODS_DIR/json.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/json.sh"  ] && . "$METHODS_DIR/_ans_methods/json.sh" 

print_node_not_defined() {
    error "NODE type not defined."
    info "HINT: ./ans --node=[node]"
    info "HINT2: Check supported_nodes.json for list of supported nodes."
}

get_node_type() {
    OLD_NODE=$(get_json_file_value "$BASEDIR/state/conf.json" "node")
    if [ -z "$OLD_NODE" ] && [ -z "$NODE" ]; then
        print_node_not_defined
        exit 6
    fi

    if [ -n "$OLD_NODE" ] && [ -n "$NODE" ] && [ ! "$NODE" = "$OLD_NODE" ]; then
        return 1
    fi

    if [ -z "$NODE" ]; then
        NODE=$OLD_NODE
    fi
    return 0
}

save_node_type() {
    set_json_file_value "$BASEDIR/state/conf.json" "node" "$NODE"
}

# $1 $NDOE
get_node_type_source() {
    if [ "$1" = "EXTERNAL" ]; then 
        printf "%s" "$(get_json_file_value "$BASEDIR/state/conf.json" "node_source")"
        return
    fi 
    NODE_SOURCE=$(get_json_file_value "$BASEDIR/supported_nodes.json" "$1")
    
    if [ -z "$NODE_SOURCE" ]; then 
        NODE_SOURCE=$(get_json_value "$(curl -fsL "$SUPPORTED_NODES_URL" --header 'Cache-Control: no-cache')" "$1")
    fi
    printf "%s" "$NODE_SOURCE"
}