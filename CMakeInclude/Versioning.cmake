if(EXISTS "${c_VersioningIncludeDirPath}")
	target_include_directories(${ModuleName}
		PRIVATE ${c_VersioningIncludeDirPath}
	)
	if(NOT c_ProjectIsVersioned)
		set(c_ProjectIsVersioned TRUE)
	else()
		message(FATAL_ERROR "Don't use the Versioning.cmake in more than one CMakeLists.txt")
	endif()
endif()