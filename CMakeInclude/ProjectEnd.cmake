set(c_ProjectDirPath ${CMAKE_CURRENT_SOURCE_DIR})
set(c_ProjectRequiredLibInstallation TRUE)

#message(STATUS "AAAAAAAAAAAAAAAAA  ${CMAKE_CXX_COMPILER}")

# CMAKE_CXX_COMPILER 略特殊, 默认无设置时, 需要在 project 命令后执行才具有检测到的默认路径 Compiler 
if(MSVC)
    add_compile_options(/MP)
	message(STATUS "Compiler Is Using MSVC")
	#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
elseif(CMAKE_CXX_COMPILER MATCHES "c\\+\\+$")
	set(GCC ON)
	message(STATUS "Compiler Is Using GCC")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-format-zero-length")
elseif(CMAKE_CXX_COMPILER MATCHES "clang\\+\\+$")
	set(CLANG ON)
	message(STATUS "Compiler Is Using Clang")
	#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-format-zero-length")
endif()

set(c_BinDirName bin)
set(c_LibDirName lib)
set(c_ProjectBinDirPath ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME})

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${c_ProjectBinDirPath})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${c_ProjectBinDirPath})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${c_ProjectBinDirPath})

if(WIN32)
	set(c_ProjectPlatformArchDirPath ${CMAKE_BINARY_DIR})
else()
	set(c_ProjectPlatformArchDirPath ${CMAKE_BINARY_DIR}/..)
endif()
set(ProjectBinDirPathDebug ${c_ProjectPlatformArchDirPath}/Debug/${c_BinDirName})
set(ProjectBinDirPathRelease ${c_ProjectPlatformArchDirPath}/Release/${c_BinDirName})
set(ProjectLibDirPathDebug ${c_ProjectPlatformArchDirPath}/Debug/${c_LibDirName})
set(ProjectLibDirPathRelease ${c_ProjectPlatformArchDirPath}/Release/${c_LibDirName})
	
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${ProjectBinDirPathDebug})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${ProjectBinDirPathRelease})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${ProjectLibDirPathDebug})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${ProjectLibDirPathRelease})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${ProjectLibDirPathDebug})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${ProjectLibDirPathRelease})

set(c_ProjectPlatform )
set(c_ExecutableFileExt )
set(c_SharedLibFileNamePrefix )
set(c_SharedLibFileExt )
set(c_StaticLibFileNamePrefix )
set(c_StaticLibFileExt )
if(WIN32)
	set(c_ProjectPlatform Windows)
	set(c_ExecutableFileExt .exe)
	set(c_SharedLibFileExt .dll)
	set(c_StaticLibFileExt .lib)
	message(STATUS "Target Is on WIN32")
elseif(UNIX)
	set(c_ProjectPlatform Linux)
	set(c_SharedLibFileNamePrefix lib)
	set(c_StaticLibFileNamePrefix lib)
	set(c_SharedLibFileExt .so)
	set(c_StaticLibFileExt .a)
	message(STATUS "Target Is on UNIX")
elseif(APPLE)
	set(c_ProjectPlatform Apple)
	message(STATUS "Target Is on APPLE")
endif()

if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
	set(x64 ON)
	set(c_ProjectArch x64)
else()
	set(x86 ON)
	set(c_ProjectArch x86)
endif()

set(InstalledPlatformArchDirPath build/${c_ProjectPlatform}/${c_ProjectArch})
set(InstalledPlatformArchDirPathDebug ${InstalledPlatformArchDirPath}/Debug)
set(InstalledPlatformArchDirPathRelease ${InstalledPlatformArchDirPath}/Release)
set(c_ProjectInstallingDirPath ${c_ProjectName})
set(c_ProjectInstallingTargetDirPathDebug ${c_ProjectInstallingDirPath}/${InstalledPlatformArchDirPathDebug})
set(c_ProjectInstallingTargetDirPathRelease ${c_ProjectInstallingDirPath}/${InstalledPlatformArchDirPathRelease})
set(c_ProjectInstallingTargetDirPath "$<$<CONFIG:Debug>:${c_ProjectInstallingDirPath}/build/${c_ProjectPlatform}/${c_ProjectArch}/Debug>$<$<CONFIG:Release>:${c_ProjectInstallingDirPath}/build/${c_ProjectPlatform}/${c_ProjectArch}/Release>")

install(FILES "${c_RootDirPath}/LICENSE.md" DESTINATION ${c_ProjectName})

include(${c_RootCMakeProjectFrameworkDirPath}/Option.cmake)

file(RELATIVE_PATH ProjectRelativeDirPath "${c_RootProjectDirPath}" "${c_ProjectDirPath}")
set(c_RootTempDirPath ${c_RootDirPath}/TempForSetupOrRelease)
set(c_ProjectTempDirPath ${c_RootTempDirPath}/${ProjectRelativeDirPath}/${c_ProjectPlatform})

set(c_PlatformReleaseDirPath ${c_StorageDirPath}/Release/${c_ProjectPlatform})
set(c_ProjectInstalledDirPath ${CMAKE_INSTALL_PREFIX}/${c_ProjectName})
set(IsSetupOrReleaseMode OFF)
if(PROJECT_SETUP OR PROJECT_RELEASE)
	set(IsSetupOrReleaseMode ON)
endif()
#if(IsSetupOrReleaseMode OR NOT EXISTS "${CMAKE_CACHEFILE_DIR}")
#	include(${c_RootCMakeProjectFrameworkDirPath}/GetZip.cmake)
#endif()
if(NOT IsSetupOrReleaseMode AND EXISTS "${c_ProjectInstalledDirPath}")
    message(STATUS "Clearing install directory: ${c_ProjectInstalledDirPath}")
    file(REMOVE_RECURSE "${c_ProjectInstalledDirPath}")
endif()