#!/bin/bash
BuildDirPathDebug=$(pwd)/DefaultBuild/Debug
BuildDirPathRelease=$(pwd)/DefaultBuild/Release
Toolset="Unix Makefiles"
OldDirPath=$(pwd)

mkdir -p $BuildDirPathDebug
cd $BuildDirPathDebug
ctest . --output-on-failure -j 1024
if [ $? -ne 0 ]; then
	echo "CMake test failed for Debug build."
else
	cd $BuildDirPathRelease
	ctest . --output-on-failure -j 1024
	if [ $? -ne 0 ]; then
		echo "CMake test failed for Release build."
	fi
fi
cd $OldDirPath
