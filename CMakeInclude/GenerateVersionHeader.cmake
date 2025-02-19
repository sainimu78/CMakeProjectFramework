set(c_VersionConfigFilePath ${c_ProjectDirPath}/VersionConfig.cmake)
set(c_ProjectVersionMajor 0)
set(c_ProjectVersionMinor 0)
set(c_ProjectVersionPatch 0)
set(c_ProjectVersionMajorCache 0 CACHE STRING "Major version number")
set(c_ProjectVersionMinorCache 0 CACHE STRING "Minor version number")
set(c_ProjectVersionPatchCache 0 CACHE STRING "Patch version number")
set(c_VersioningIncludeDirPath ${c_ProjectPlatformArchDirPath}/Versioning)
set(c_VersionHeaderFilePath ${c_VersioningIncludeDirPath}/CMakeProjectFramework/ProjectVersion.h)
set(c_ProjectIsVersioned FALSE)
if(EXISTS "${c_VersionConfigFilePath}")
	include(${c_VersionConfigFilePath})

	if((	(NOT (c_ProjectVersionMajorCache EQUAL c_ProjectVersionMajor))
		OR	(NOT (c_ProjectVersionMinorCache EQUAL c_ProjectVersionMinor))
		OR	(NOT (c_ProjectVersionPatchCache EQUAL c_ProjectVersionPatch)))
		)
			set(FileContent
"#pragma once
		
constexpr int g_versionMajor = ${c_ProjectVersionMajor};
constexpr int g_versionMinor = ${c_ProjectVersionMinor};
constexpr int g_versionPatch = ${c_ProjectVersionPatch};
")
			file(WRITE "${c_VersionHeaderFilePath}" "${FileContent}")
			message(STATUS "Generated ${c_VersionHeaderFilePath}")
	endif()
else()
	#file(REMOVE "${c_VersionHeaderFilePath}")
	file(REMOVE_RECURSE "${c_VersioningIncludeDirPath}")
endif()
message("ddddddd ${c_ProjectVersionPatchCache}, ${c_ProjectVersionPatch}")

set(c_ProjectVersionMajorCache ${c_ProjectVersionMajor} CACHE STRING "Major version number" FORCE)
set(c_ProjectVersionMinorCache ${c_ProjectVersionMinor} CACHE STRING "Minor version number" FORCE)
set(c_ProjectVersionPatchCache ${c_ProjectVersionPatch} CACHE STRING "Patch version number" FORCE)
