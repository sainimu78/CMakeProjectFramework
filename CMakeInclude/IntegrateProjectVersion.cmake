set(VersionHeaderFilePath ${c_VersioningIncludeDirPath}/CMakeProjectFramework/ProjectVersion.h)

set(ToGenFile FALSE)
if(c_ProjectVersionChanged OR (NOT EXISTS "${VersionHeaderFilePath}"))
	set(ToGenFile TRUE)
endif()
if(ToGenFile)
	set(FileContent
"#pragma once

constexpr int g_versionMajor = ${c_ProjectVersionMajor};
constexpr int g_versionMinor = ${c_ProjectVersionMinor};
constexpr int g_versionPatch = ${c_ProjectVersionPatch};
")
	file(WRITE "${VersionHeaderFilePath}" "${FileContent}")
	message(STATUS "Generated ${VersionHeaderFilePath}")
endif()

if(EXISTS "${c_VersionConfigFilePath}")
else()
	#file(REMOVE "${VersionHeaderFilePath}")
	file(REMOVE_RECURSE "${c_VersioningIncludeDirPath}")
endif()

if(EXISTS "${c_VersioningIncludeDirPath}")
	target_include_directories(${ModuleName}
		PRIVATE ${c_VersioningIncludeDirPath}
	)
	if(NOT c_WasIncludedIntegrateProjectVersion)
		set(c_WasIncludedIntegrateProjectVersion TRUE)
	else()
		message(FATAL_ERROR "Don't use this .cmake in more than one CMakeLists.txt")
	endif()
endif()