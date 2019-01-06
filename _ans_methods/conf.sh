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

PATH_TO_SCRIPT=$(readlink -f "$0")
METHODS_DIR=$(dirname "$PATH_TO_SCRIPT")

if [ -f "$METHODS_DIR/util.sh" ]; then 
    # shellcheck disable=SC1090
    . "$METHODS_DIR/util.sh" 
fi

if [ -f "$METHODS_DIR/_ans_methods/util.sh"  ]; then 
    # shellcheck disable=SC1090
    . "$METHODS_DIR/_ans_methods/util.sh" 
fi

get_node_type() {
    if [ -f "$BASEDIR/state/conf.json" ]; then
        TEMP_NODE=$(jq '.node' "$BASEDIR/state/conf.json" -r 2>/dev/null)
    else 
        NO_CONF=true
    fi

    if [ -n "$NODE" ]; then 
        if [ -n "$TEMP_NODE" ] && [ ! "$TEMP_NODE" = "null" ] && [ ! "$TEMP_NODE" = "$NODE" ]; then    
            # shellcheck disable=SC2034
            OLD_NODE=$TEMP_NODE
            # changing setup node
            return 1
        fi
        # working new or existing node
        return 0
    else 
        if [ -z "$TEMP_NODE" ] || [ "$NO_CONF" = "true" ]; then 
            # missing node type
            return 2
        else 
            NODE="$TEMP_NODE"
            # working new or existing node
            return 0
        fi
    fi
}

save_node_type() {
    set_json_file_value "$BASEDIR/state/conf.json" "node" "$NODE"
}