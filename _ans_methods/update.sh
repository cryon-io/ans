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

ANS_VERSION_URL="https://raw.githubusercontent.com/cryon-io/ans/master/version.json"

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/privileges.sh" ] && . "$METHODS_DIR/privileges.sh"
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/privileges.sh" ] && . "$METHODS_DIR/_ans_methods/privileges.sh"

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/json.sh" ] && . "$METHODS_DIR/json.sh"
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/json.sh" ] && . "$METHODS_DIR/_ans_methods/json.sh"

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/util.sh" ] && . "$METHODS_DIR/util.sh"
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/util.sh" ] && . "$METHODS_DIR/_ans_methods/util.sh"

# shellcheck disable=SC1090
[ -f "$METHODS_DIR/git.sh" ] && . "$METHODS_DIR/git.sh"
# shellcheck disable=SC1090
[ -f "$METHODS_DIR/_ans_methods/git.sh" ] && . "$METHODS_DIR/_ans_methods/git.sh"

update_ans() {
    require_root_privileges
    LATEST_VER=$(get_json_value "$(curl -fsL "$ANS_VERSION_URL")" "ans")
    ANS_VERSION=$(get_json_file_value "$BASEDIR/version.json" "ans")

    if [ "$(echo "$LATEST_VER"' > '"$ANS_VERSION" | bc -l)" = 1 ]; then
        info "Updating ans"
        update_repository "$BASEDIR" "$ANS_BRANCH"
        chmod +x "$PATH_TO_ANS" "$BASEDIR/cli" "$BASEDIR/is-up"
        restoreFilePermissions=true
    fi
}

update_service() {
    LINK_TO_DEF=$(repository_link_to_raw_link "$NODE_SOURCE" "def.json")
    NODE_DEF=$(curl -fsL "$LINK_TO_DEF")

    [ -z "$NODE_DEF" ] &&
        { error "Failed to obtain node service definition. Please retry..." && exit 11; }

    REQUIRED_ANS_VERSION=$(get_json_value "$NODE_DEF" "required-ans-version")

    info "Checking updates for service definition for node $NODE"
    require_ans_version "$REQUIRED_ANS_VERSION"

    LATEST_VER=$(get_json_value "$NODE_DEF" "version")

    SERVICE_VER=$(get_json_file_value "$BASEDIR/containers/$NODE/def.json" "version")
    if [ "$(echo "$LATEST_VER"' > '"$SERVICE_VER" | bc -l)" = "1" ]; then
        info "Updating service definition"
        update_repository "$BASEDIR/containers/$NODE"
        repository_branch_switch "$BASEDIR/containers/$NODE" "$NODE_BRANCH"
        restoreFilePermissions=true
        build=true
        start=true
        noCache="--no-cache"
    fi
}

update_node() {
    info "Updating node..."
    require_docker_privileges
    DEF_FILE="$BASEDIR/containers/$NODE/def.json"
    script_sub_path=$(get_json_file_value "$DEF_FILE" "update-node")
    update_file="$BASEDIR/containers/$NODE/$script_sub_path"
    if [ ! -f "$update_file" ]; then
        error "Cannot find $NODE update-node file: $update_file"
        warn "Update node core skipped"
    else
        sh "$update_file"
        case "$?" in
        "0")
            info "Node was updated or running on latest version."
            ;;
        "1")
            error "Node is not running, cannot update."
            ;;
        "2")
            error "Failed to update node"
            ;;
        "3")
            error "Failed to get node.info"
            ;;
        esac
    fi
}
