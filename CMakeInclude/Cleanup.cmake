#if(c_ProjectPipelineSetup OR c_ProjectPipelineRelease)
#	
#endif()
#if(EXISTS "${c_RootTempDirPath}")
	file(REMOVE_RECURSE "${c_RootTempDirPath}")
#endif()

if((NOT EXISTS "${c_VersioningIncludeDirPath}") AND (NOT EXISTS "${c_ReleaseNotesFilePath}"))
	file(REMOVE_RECURSE "${c_ProjectVersioningDirPath}")
endif()

unset(downloaded_files CACHE)