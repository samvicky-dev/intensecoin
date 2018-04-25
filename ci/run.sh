if [ -x "$(command -v sw_vers)" ]; then
	macOSVersion=`sw_vers -productVersion`
	macOSVersion="${macOSVersion%.*}"
	macOSScript="./ci/macos.$macOSVersion.sh"
	if [ -f $macOSScript ]; then
		$macOSScript $1
	else
		echo "CI: builds not yet implemented for macOS version $macOSVersion"
	fi
elif [ -x "$(command -v lsb_release)" ]; then
	ubuntuVersion=`lsb_release --release --short`
	ubuntuArchitecture=`uname -i`
	ubuntuScript="./ci/ubuntu.$ubuntuVersion.$ubuntuArchitecture.sh"
	if [ -f $ubuntuScript ]; then
		$ubuntuScript $1
	else
		echo "CI: builds not yet implemented for Ubuntu version $ubuntuVersion $ubuntuArchitecture"
	fi
else
	echo "CI: unable to determine build system"
fi
