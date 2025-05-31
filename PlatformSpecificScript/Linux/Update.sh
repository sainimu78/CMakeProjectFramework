#!/bin/bash
BuildDirPathDebug=$(pwd)/DefaultBuild/Debug
BuildDirPathRelease=$(pwd)/DefaultBuild/Release
InstallPrefix=../Installed
Toolset="Unix Makefiles"
OldDirPath=$(pwd)
ExitCode=0

mkdir -p $BuildDirPathDebug
cd $BuildDirPathDebug
cmake $ProjectDirPath -G "$Toolset" -DCMAKE_INSTALL_PREFIX="$InstallPrefix" -DPROJECT_PIPELINE=Default -DCMAKE_BUILD_TYPE=Debug
if [ $? -ne 0 ]; then
    echo "CMake configuration failed for Debug build."
	ExitCode=1
else
	mkdir -p $BuildDirPathRelease
	cd $BuildDirPathRelease
	cmake $ProjectDirPath -G "$Toolset" -DCMAKE_INSTALL_PREFIX="$InstallPrefix" -DPROJECT_PIPELINE=Default -DCMAKE_BUILD_TYPE=Release
	if [ $? -ne 0 ]; then
		echo "CMake configuration failed for Release build."
		ExitCode=1
	fi
fi
cd $OldDirPath
exit $ExitCode