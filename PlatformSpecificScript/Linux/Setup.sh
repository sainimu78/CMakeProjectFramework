#!/bin/bash
BuildDirPathDebug=$(pwd)/DefaultBuild/Debug
BuildDirPathRelease=$(pwd)/DefaultBuild/Release
InstallPrefix=../Installed
Toolset="Unix Makefiles"
OldDirPath=$(pwd)

mkdir -p $BuildDirPathRelease
cd $BuildDirPathRelease
cmake $ProjectDirPath -G "$Toolset" -DCMAKE_INSTALL_PREFIX="$InstallPrefix" -DPROJECT_PIPELINE=Setup -DCMAKE_BUILD_TYPE=Release
cd $OldDirPath