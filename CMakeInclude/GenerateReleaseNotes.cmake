set(ToGenFile FALSE)
if(c_ProjectVersionChanged OR (NOT EXISTS "${c_ReleaseNotesFilePath}"))
	set(ToGenFile TRUE)
endif()
if(ToGenFile)
    set(FileContent
"# Version

${c_ProjectName} ${c_ProjectVersionMajor}.${c_ProjectVersionMinor}.${c_ProjectVersionPatch}
")
	set(DetailFilePath ${c_ProjectDirPath}/ReleaseNotesDetail.md)
	if(EXISTS "${DetailFilePath}")
		file(READ "${DetailFilePath}" DetailContent)
		set(FileContent
"${FileContent}
${DetailContent}")
	endif()
    file(WRITE "${c_ReleaseNotesFilePath}" "${FileContent}")
	message(STATUS "Generated ${c_ReleaseNotesFilePath}")
    install(FILES "${c_ReleaseNotesFilePath}" DESTINATION ${c_ProjectName})
endif()

if(EXISTS "${c_VersionConfigFilePath}")
else()
	#file(REMOVE "${VersionHeaderFilePath}")
	file(REMOVE_RECURSE "${c_ReleaseNotesFilePath}")
endif()