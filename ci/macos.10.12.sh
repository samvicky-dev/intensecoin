BUILD_HOST="macOS-10.12"
echo "CI: $BUILD_HOST"

if [ "$1" = "prep" ]; then

	installDependencyIfNeeded () {
		brew ls --versions $@ 2>/dev/null
		if [ $? -eq 0 ]; then
			echo "CI: Found $@"
		else
			echo "CI: Missing dependency, installing $@..."
			brew install $@
			if [ $? -eq 0 ]; then
				echo "CI: Installed $@ successfully."
			else
				echo "CI: Failed to install $@."
				exit 1
			fi
		fi
	}

	# tools
	which brew
	if [ $? -eq 0 ]; then
		echo "CI: Brew is available."
	else
		echo "CI: Brew is missing, installing now..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# dependencies
	installDependencyIfNeeded cmake
	installDependencyIfNeeded boost
	installDependencyIfNeeded openssl
	installDependencyIfNeeded pkgconfig

	exit 0

fi

. ci/unix.common
