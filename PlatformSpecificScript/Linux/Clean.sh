#!/bin/bash
BuildDirPath=$(pwd)/DefaultBuild
OldDirPath=$(pwd)
ExitCode=0

cd $BuildDirPath
cmake --build ./Debug --target clean --config Debug
if [ $? -ne 0 ]; then
    echo "CMake configuration failed for Debug build."
	ExitCode=1
else
	cmake --build ./Release --target clean --config Release
	if [ $? -ne 0 ]; then
		echo "CMake configuration failed for Release build."
		ExitCode=1
	fi
fi
cd $OldDirPath
exit $ExitCode