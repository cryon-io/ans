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
if [ -f "$METHODS_DIR/privileges.sh" ]; then
    . "$METHODS_DIR/privileges.sh"
fi
# shellcheck disable=SC1090
if [ -f "$METHODS_DIR/_ans_methods/privileges.sh" ]; then
    . "$METHODS_DIR/_ans_methods/privileges.sh"
fi

# shellcheck disable=SC1090
if [ -f "$METHODS_DIR/dist_info.sh" ]; then
    . "$METHODS_DIR/dist_info.sh"
fi
# shellcheck disable=SC1090
if [ -f "$METHODS_DIR/_ans_methods/dist_info.sh" ]; then
    . "$METHODS_DIR/_ans_methods/dist_info.sh"
fi

# shellcheck disable=SC1090
if [ -f "$METHODS_DIR/prints.sh" ]; then
    . "$METHODS_DIR/prints.sh"
fi
# shellcheck disable=SC1090
if [ -f "$METHODS_DIR/_ans_methods/prints.sh" ]; then
    . "$METHODS_DIR/_ans_methods/prints.sh"
fi

install_dependencies() {
    require_root_privileges

    dist=$(get_dist_version)

    case "$dist" in
    ubuntu)
        # shellcheck disable=SC2015
        apt-get update
        if DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y && DEBIAN_FRONTEND=noninteractive apt-get install -y -q apt-transport-https ca-certificates curl software-properties-common git unzip jq bc; then
            success "ANS dependencies succesfully installed."
        else
            error "Failed to install dependencies. Please retry..."
            exit 10
        fi
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
        apt-key fingerprint 0EBFCD88
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        apt-get update
        if ! DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce; then
            error "Failed to install dependencies. Please retry..."
            exit 10
        fi
        ;;
    fedora)
        dnf -y upgrade
        dnf -y install dnf-plugins-core
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        # shellcheck disable=SC2015
        if dnf -y install curl git unzip jq bc && dnf -y install docker-ce; then
            success "ANS dependencies succesfully installed."
        else
            error "Failed to install dependencies. Please retry..."
            exit 10
        fi
        systemctl enable docker
        systemctl start docker
        sleep 15
        ;;
    debian)
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y
        dist_version="$(sed 's/\/.*//' /etc/debian_version | sed 's/\..*//')"
        if [ "$dist_version" -ge 8 ]; then
            if DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common git unzip jq bc; then
                success "ANS dependencies succesfully installed."
            else
                error "Failed to install dependencies. Please retry..."
                exit 10
            fi

            curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
            apt-key fingerprint 0EBFCD88
            add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        else
            if DEBIAN_FRONTEND=noninteractive apt-get install apt-transport-https ca-certificates curl python-software-properties git unzip jq bc; then
                success "ANS dependencies succesfully installed."
            else
                error "Failed to install dependencies. Please retry..."
                exit 10
            fi

            curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
            apt-key fingerprint 0EBFCD88
            add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
            cp /etc/apt/sources.list /etc/apt/sources.list.backup
            fixed_list=$(grep -v "deb-src [arch=amd64] https://download.docker.com/linux/debian wheezy stable" /etc/apt/sources.list)
            echo "$fixed_list" >/etc/apt/sources.list
        fi
        apt-get update
        if ! DEBIAN_FRONTEND=noninteractive apt-get install docker-ce -y; then 
            error "Failed to install dependencies. Please retry..." 
            exit 10
        fi
        ;;
    centos)
        yum upgrade -y
        yum install -y yum-utils device-mapper-persistent-data epel-release
        yum install -y lvm2 git unzip jq bc
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install -y docker-ce
        systemctl enable docker
        systemctl start docker
        sleep 15
        ;;
    *)
        error "Unsupported operating system '$dist'"
        exit 10
        ;;
    esac

    if ! docker run hello-world; then
        error "Failed to install or run docker. Please retry..."
        exit 10
    fi

    get_latest_github_release "docker/compose"
    curl -L "https://github.com/docker/compose/releases/download/$RESULT/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    if ! docker-compose --version; then
        error "Failed to install or run docker-compose. Please retry..."
        exit 10
    fi
}
