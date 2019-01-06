#!/bin/sh

# based on https://get.docker.com/

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

get_dist_version() {
    dist=""
	if [ -r /etc/os-release ]; then
		# shellcheck disable=SC1091
		dist="$(. /etc/os-release && echo "$ID")"
	fi
    case "$dist" in
    	ubuntu)
			if command_exists lsb_release; then
				dist_version="$(lsb_release --codename | cut -f2)"
			fi
			if [ -z "$dist_version" ] && [ -r /etc/lsb-release ]; then
				# shellcheck disable=SC1091
				dist_version="$(. /etc/lsb-release && printf "%s" "$DISTRIB_CODENAME")"
			fi
		;;

		debian|raspbian)
			dist_version="$(sed 's/\/.*//' /etc/debian_version | sed 's/\..*//')"
			case "$dist_version" in
				9)
					dist_version="stretch"
				;;
				8)
					dist_version="jessie"
				;;
			esac
		;;

		centos)
			if [ -z "$dist_version" ] && [ -r /etc/os-release ]; then
				# shellcheck disable=SC1091
				dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
			fi
		;;

		rhel|ol|sles)
			ee_notice "$dist"
			exit 1
			;;

		*)
			if command_exists lsb_release; then
				dist_version="$(lsb_release --release | cut -f2)"
			fi
			if [ -z "$dist_version" ] && [ -r /etc/os-release ]; then
				# shellcheck disable=SC1091
				dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
			fi
		;;
    esac
    # Check for lsb_release command existence, it usually exists in forked distros
	if command_exists lsb_release; then
		# Check if the `-u` option is supported
		set +e
		lsb_release -a -u > /dev/null 2>&1
		lsb_release_exit_code=$?
		set -e

		# Check if the command has exited successfully, it means we're in a forked distro
		if [ "$lsb_release_exit_code" = "0" ]; then
			# Print info about current distro
			cat <<-EOF
			You're using '$dist' version '$dist_version'.
			EOF

			# Get the upstream release info
			dist=$(lsb_release -a -u 2>&1 | tr '[:upper:]' '[:lower:]' | grep -E 'id' | cut -d ':' -f 2 | tr -d '[:space:]')
			dist_version=$(lsb_release -a -u 2>&1 | tr '[:upper:]' '[:lower:]' | grep -E 'codename' | cut -d ':' -f 2 | tr -d '[:space:]')

			# Print info about upstream distro
			cat <<-EOF
			Upstream release is '$dist' version '$dist_version'.
			EOF
		else
			if [ -r /etc/debian_version ] && [ "$dist" != "ubuntu" ] && [ "$dist" != "raspbian" ]; then
				if [ "$dist" = "osmc" ]; then
					# OSMC runs Raspbian
					dist=raspbian
				else
					# We're Debian and don't even know it!
					dist=debian
				fi
				dist_version="$(sed 's/\/.*//' /etc/debian_version | sed 's/\..*//')"
				case "$dist_version" in
					9)
						dist_version="stretch"
					;;
					8|'Kali Linux 2')
						dist_version="jessie"
					;;
				esac
			fi
		fi
	fi
    echo $dist
}