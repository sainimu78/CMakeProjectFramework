install(TARGETS ${ModuleName}
	RUNTIME DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_BinDirName}"
	LIBRARY DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_LibDirName}"
	ARCHIVE DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_LibDirName}"
)

foreach(It IN LISTS v_ListModuleInstallingHeaderDirPath)
	install(DIRECTORY "${It}" DESTINATION "${c_ProjectInstallingDirPath}")
endforeach()

foreach(It IN LISTS v_ListModuleInstallingPlatformArchDirPath)
	install(DIRECTORY "${It}" DESTINATION "${c_ProjectInstalledPlatformArchDirPath}")
endforeach()

#install(DIRECTORY "${ModuleHeaderDirPath}" DESTINATION "${c_ProjectInstallingDirPath}")

if(MSVC)
	install(FILES "$<TARGET_FILE_DIR:${ModuleName}>/${ModuleName}.pdb"
		DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_BinDirName}"
		CONFIGURATIONS Debug
	)
endif()

unset(v_ListModuleInstallingHeaderDirPath)
unset(v_ListModuleInstallingPlatformArchDirPath)