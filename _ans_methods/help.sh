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

script_usage() {
    cat <<EOF
                    == AUTONOMOUS NODE SYSTEM ==

Usage:
    -h|--help                                   Displays this help message.

    -dau|--disable-auto-update                  Removes auto update from cron job
    
    --user=[user]                               Creates user if not exists and starts docker from this user. (docker rights are assigned automatically)
    --node=[node type]                          Defines type of node to manage
    --stop                                      Stops node
    -se=[env_var]|--set-env=[env_var]           Sets node env variable (Refer to per coin docs)
    -sp=[param]|--set-parameter=[param]         Sets node parameter (Refer to per coin docs)
    --bind=[binding]                            Sets binding for specified port. 
                                                E.g.: --bind=127.0.0.1:3000:30305 # binds port 30305 from node to ip 127.0.0.1 port 3000
    --ans-branch=[branch]                       Selects branch from ANS repository
    --node-branch=[branch]                      Selects branch from node repository

    --project-name                              Sets project name for node instance 
    --prune                                     Deletes node service and data (chain, wallet, etc.)
    --prune-data                                Deletes node data (chain, wallet, etc.)
    --docker-prune                              Runs docker system cleanup. Requires confirmations. (Removes old containers and images)
    -es|--external-source                       Sets source repository for EXTERNAL node type
    --dev                                       Puts ANS into dev mode (limits node repository resets)

    -f|--full                                   Runs all of the commands below.

    -sd|--setup-dependencies                    Installs node dependencies
    -gd|--grant-docker                          Adds CURRENT user into docker group, so you can control docker without sudo and auto update node
                                                # In case of --full arg, can be disabled by -dau
    -gd=[user]|--grant-docker=[user]            Adds SPECIFIC user into docker group, so you can control docker without sudo and auto update
                                                # In case of --full arg, can be disabled by -dau
    
    -b|--build                                  Builds node based on node service definition 

    -nc|--no-cache                              Affects MN build
    -s|--start                                  Starts node
    -r|--restart                                Restarts node (same as start + --force-recreate)
    
    -un|--update-node                           Updates core binary for node (through docker rebuild)
    -us|--update-service                        Updates service definitions for node
    -uc|--update-ans                            Updates this ans

    -rfp|--restore-file-permissions             Restores required chmod +x and directory permissions
    -i|--node-info                              Prints node version
    -au|--auto-update                           Adds cron job for auto update
                                                * uses lowest auto update level - only node binary update
    -aul=[level]|--auto-update-level=[level]    Adds cron job for auto update with specific level
                                                0 - node binary updates
                                                1 - node binary and service updates
                                                2 - all above + ANS updates

    EXAMPLES:
    # setup as root
    1. setup as root with auto update
    ./ans -f
    2. setup as root, running on [user] with auto update
    ./ans -f --user=[user]

    # setup as non root (requires sudo)
    1. setup as non root for current user with auto update
    sudo ./ans -f
    2. setup as non root, running on [user] with full auto update auto update
    sudo ./ans -f --user=[user] --aul=2

EOF
}
