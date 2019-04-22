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
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/docker.sh" ] && . "$METHODS_DIR/docker.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/docker.sh"  ] && . "$METHODS_DIR/_ans_methods/docker.sh" 

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/prints.sh" ] && . "$METHODS_DIR/prints.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/prints.sh"  ] && . "$METHODS_DIR/_ans_methods/prints.sh" 

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/privileges.sh" ] && . "$METHODS_DIR/privileges.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/privileges.sh"  ] && . "$METHODS_DIR/_ans_methods/privileges.sh" 

# $1 PATH TO COMPOSE
# $2 PATH TO IS UP
# $3 $PROJECT_NAME
# $4 $NODE

stop_node() {
    require_docker_privileges
    if [ -n "$4" ]; then  
        info "Stopping node: \"$4\""
    else
        info "Stopping node..."
    fi
    i=0
    while sh "$2" >/dev/null; do
        stop_service "$1" "$3"
        i="$((i+1))"
        if [ "$i" -gt "4" ]; then
            error "Node stop retry limit reached. Failed to stop node."
            info "Please stop node manually and retry..."
            exit 15
        fi
    done
}