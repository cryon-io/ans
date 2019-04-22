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

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/privileges.sh" ] && . "$METHODS_DIR/privileges.sh" 
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/privileges.sh"  ] && . "$METHODS_DIR/_ans_methods/privileges.sh" 

# updates USER to real user in case we are in login shell and used sudo
update_current_user() {
    REAL_USER=$(who am i | awk '{print $1}')
    USER=${REAL_USER:-$USER}
}

create_user() {
    require_root_privileges
    id -u "$1" > /dev/null || useradd "$1" -m -s /bin/sh
    id -u "$1" > /dev/null && return 0 || return 1
}

create_group() {
    require_root_privileges
    grep "^$1:" /etc/group > /dev/null || groupadd "$1"
}

add_user_to_group() {
    require_root_privileges
    groups "$1" | grep "$2" > /dev/null || usermod -a -G "$2" "$1"
}