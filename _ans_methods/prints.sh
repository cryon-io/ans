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

success() {
    time=$(date +%H:%M:%S)
    printf "\033[0;32m%s SUCCESS: %s \033[0m\n" "$time" "$1"
}

info() {
    time=$(date +%H:%M:%S)
    printf "\033[0;36m%s INFO: %s \033[0m\n" "$time" "$1"
}

warn() {
    time=$(date +%H:%M:%S)
    printf "\033[0;33m%s WARN: %s \033[0m\n" "$time" "$1"
}

error() {
    time=$(date +%H:%M:%S)
    printf "\033[0;31m%s ERROR: %s \033[0m\n" "$time" "$1"
}