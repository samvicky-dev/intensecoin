BUILD_HOST="ubuntu-16.04-x86_64"
echo "CI: $BUILD_HOST"

if [ "$1" = "prep" ]; then

	installDependencyIfNeeded () {
		if [ $(dpkg-query -W -f='${Status}' $@ 2>/dev/null | grep -c "ok installed") -ne 0 ]; then
			echo "CI: Found $@"
		else
			echo "CI: Missing dependency, installing $@..."
			sudo apt-get install $@ -y
			if [ $? -eq 0 ]; then
				echo "CI: Installed $@ successfully."
			else
				echo "CI: Failed to install $@."
				exit 1
			fi
		fi
	}

	# dependencies
	installDependencyIfNeeded build-essential
	installDependencyIfNeeded libssl-dev
	installDependencyIfNeeded libboost-all-dev
	installDependencyIfNeeded pkg-config
	installDependencyIfNeeded cmake

	exit 0

fi

. ci/unix.common
