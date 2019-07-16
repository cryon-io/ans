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
    if [ -f "$1" ]; then
        if [ -n "$3" ]; then
            # shellcheck disable=SC2086
            if ! docker-compose -f "$1" --project-name "$3" build $2; then
                return 13
            fi
        else
            # shellcheck disable=SC2086
            if ! docker-compose -f "$1" build $2; then
                return 13
            fi
        fi
    fi
}

start_service() {
    if [ -f "$1" ]; then
        if [ -n "$3" ]; then
            # shellcheck disable=SC2086
            docker-compose -f "$1" --project-name "$3" up -d --remove-orphans -t "${DOCKER_TIMEOUT:-120}" $2
        else
            # shellcheck disable=SC2086
            docker-compose -f "$1" up -d --remove-orphans -t "${DOCKER_TIMEOUT:-120}" $2
        fi
    fi
}

stop_service() {
    if [ -f "$1" ]; then
        if [ -n "$2" ]; then
            docker-compose -f "$1" --project-name "$2" down -t "${DOCKER_TIMEOUT:-120}"
        else
            docker-compose -f "$1" down -t "${DOCKER_TIMEOUT:-120}"
        fi
    fi
}
