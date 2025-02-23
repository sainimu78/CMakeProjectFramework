#!/bin/bash
BuildDirPathDebug=$(pwd)/TestBuild/Debug
BuildDirPathRelease=$(pwd)/TestBuild/Release
Toolset="Unix Makefiles"
OldDirPath=$(pwd)

mkdir -p $BuildDirPathDebug
cd $BuildDirPathDebug
GenerateOk=0
cmake $TestDirPath -G "$Toolset" -DCMAKE_BUILD_TYPE=Debug
if [ $? -ne 0 ]; then
    echo "CMake configuration failed for Debug build."
else
	mkdir -p $BuildDirPathRelease
	cd $BuildDirPathRelease
	cmake $TestDirPath -G "$Toolset" -DCMAKE_BUILD_TYPE=Release
	if [ $? -ne 0 ]; then
		echo "CMake configuration failed for Release build."
	else
		GenerateOk=1
	fi
fi

BuildOk=0
if [ $GenerateOk -ne 0 ]; then
	cd $BuildDirPathDebug
	cmake --build .
	if [ $? -ne 0 ]; then
		echo "CMake build failed for Debug build."
	else
		cd $BuildDirPathRelease
		cmake --build .
		if [ $? -ne 0 ]; then
			echo "CMake build failed for Release build."
		else
			BuildOk=1
		fi
	fi
fi

if [ $BuildOk -ne 0 ]; then
	cd $BuildDirPathDebug
	ctest . --output-on-failure -j 1024
	if [ $? -ne 0 ]; then
		echo "CMake test failed for Debug build."
	else
		cd $BuildDirPathRelease
		cmake --build .
		ctest . --output-on-failure -j 1024
		if [ $? -ne 0 ]; then
			echo "CMake test failed for Release build."
		else
		fi
	fi
fi
cd $OldDirPath