set -x
BUILD_HOST="macos-10.12"
BUILD_BRANCH=`git rev-parse --abbrev-ref HEAD`
BUILD_COMMIT=`git rev-parse --short HEAD`
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

echo "CI: Building static release..."
make -j2 release-static
if [ $? -ne 0 ]; then
	echo "CI: Build failed with error code: $?"
	exit 1
fi

echo "CI: Creating release archive..."
RELEASE_NAME="intensecoin-cli-$BUILD_HOST-$BUILD_BRANCH-$BUILD_COMMIT"
cd build/release/bin/
mkdir $RELEASE_NAME
cp intense-blockchain-export $RELEASE_NAME/
cp intense-blockchain-import $RELEASE_NAME/
cp intense-wallet-cli $RELEASE_NAME/
cp intense-wallet-rpc $RELEASE_NAME/
cp intensecoind $RELEASE_NAME/
tar -cvjf $RELEASE_NAME.tar.bz2 $RELEASE_NAME
shasum -a 256 $RELEASE_NAME.tar.bz2 > $RELEASE_NAME.tar.bz2.sha256.txt
