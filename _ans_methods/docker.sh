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

build_service() {
    if [ -n "$3" ]; then 
        project="--project-name \"$3\""
    fi  
    docker-compose -f "$1" $project build $2
}

start_service() {
    if [ -n "$3" ]; then 
        project="--project-name \"$3\""
    fi 
    docker-compose -f "$1" $project up -d --remove-orphans -t "${DOCKER_TIMEOUT:-120}" $2
}

stop_service() {
    if [ -n "$2" ]; then 
        project="--project-name \"$2\""
    fi 
    if [ -f "$1" ]; then
        docker-compose -f "$1" $project down -t "${DOCKER_TIMEOUT:-120}"
    fi 
}