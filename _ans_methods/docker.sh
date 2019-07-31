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
        OVERRIDE_COMPOSE_FILE=$(printf "%s" "$1" | sed "s/.yml$/.override.yml/")
        if [ -f "$OVERRIDE_COMPOSE_FILE" ]; then
            if [ -n "$3" ]; then
                # shellcheck disable=SC2086
                if ! docker-compose -f "$1" -f "$OVERRIDE_COMPOSE_FILE" --project-name "$3" build $2; then
                    return 13
                fi
            else
                # shellcheck disable=SC2086
                if ! docker-compose -f "$1" -f "$OVERRIDE_COMPOSE_FILE" build $2; then
                    return 13
                fi
            fi
        else
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
    fi
}

# $1 path to compose file
# $2 --force-recreate
# $3 project name
start_service() {
    if [ -f "$1" ]; then
        OVERRIDE_COMPOSE_FILE="$(printf "%s" "$1" | sed "s/.yml$/.override.yml/")"
        
        if [ ! -f "$OVERRIDE_COMPOSE_FILE" ]; then
            mdwcf=""
        fi

        if [ -z "$3" ]; then
            ltmbm=""
        fi

        if [ -z "$2" ]; then
            eksxq=""
        fi

        if ! docker-compose -f "$1" ${mdwcf-"-f"} ${mdwcf-"$OVERRIDE_COMPOSE_FILE"} ${ltmbm-"--project-name"} ${ltmbm-"$3"} up -d --remove-orphans ${eksxq-"$2"}; then
            # fall back in case of failing recreate
            if [ "$2" = "--force-recreate" ]; then
                if docker-compose -f "$1" ${mdwcf-"-f"} ${mdwcf-"$OVERRIDE_COMPOSE_FILE"} ${ltmbm-"--project-name"} ${ltmbm-"$3"} build && docker-compose -f "$1" ${mdwcf-"-f"} ${mdwcf-"$OVERRIDE_COMPOSE_FILE"} ${ltmbm-"--project-name"} ${ltmbm-"$3"} down; then
                    docker-compose -f "$1" ${mdwcf-"-f"} ${mdwcf-"$OVERRIDE_COMPOSE_FILE"} ${ltmbm-"--project-name"} ${ltmbm-"$3"} up -d
                fi
            fi
        fi
    fi
}

stop_service() {
    if [ -f "$1" ]; then
        OVERRIDE_COMPOSE_FILE=$(printf "%s" "$1" | sed "s/.yml$/.override.yml/")
        if [ -f "$OVERRIDE_COMPOSE_FILE" ]; then
            if [ -n "$2" ]; then
                docker-compose -f "$1" -f "$OVERRIDE_COMPOSE_FILE" --project-name "$2" down
            else
                docker-compose -f "$1" -f "$OVERRIDE_COMPOSE_FILE" down
            fi
        else
            if [ -n "$2" ]; then
                docker-compose -f "$1" --project-name "$2" down
            else
                docker-compose -f "$1" down
            fi
        fi
    fi
}
