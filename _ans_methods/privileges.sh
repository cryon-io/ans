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
if [ -f "$METHODS_DIR/prints.sh" ]; then
    . "$METHODS_DIR/prints.sh"
fi
# shellcheck disable=SC1090
if [ -f "$METHODS_DIR/_ans_methods/prints.sh" ]; then
    . "$METHODS_DIR/_ans_methods/prints.sh"
fi

require_root_privileges() {
    if [ ! "$(id -u)" = 0 ]; then
        error "This option requires root (or sudo) privileges"
        exit 1
    fi
}

require_docker_privileges() {
    if [ "$(groups | grep "docker" || echo "true")" = "true" ] && [ "$(groups | grep "root" || echo "true")" = "true" ]; then
        error "This option requires docker privileges. Either run ans as root or grant user docker privileges."
        info "HINT: sudo ./ans --grant-docker"
        exit 2
    fi
}
