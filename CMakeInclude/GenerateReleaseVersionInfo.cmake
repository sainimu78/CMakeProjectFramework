set(ToGenFile FALSE)
if(c_ProjectVersionChanged OR (NOT EXISTS "${c_ReleaseVersionInfoFilePath}"))
	set(ToGenFile TRUE)
endif()
if(ToGenFile)
    set(FileContent
"${c_ProjectName} Version ${c_ProjectVersionMajor}.${c_ProjectVersionMinor}.${c_ProjectVersionPatch}
")
    file(WRITE "${c_ReleaseVersionInfoFilePath}" "${FileContent}")
	message(STATUS "Generated ${c_ReleaseVersionInfoFilePath}")
    install(FILES "${c_ReleaseVersionInfoFilePath}" DESTINATION ${c_ProjectName})
endif()

if(EXISTS "${c_VersionConfigFilePath}")
else()
	#file(REMOVE "${VersionHeaderFilePath}")
	file(REMOVE_RECURSE "${c_ReleaseVersionInfoFilePath}")
endif()