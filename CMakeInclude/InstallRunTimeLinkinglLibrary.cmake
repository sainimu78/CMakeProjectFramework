if(WIN32)
	install(TARGETS ${ModuleName}
		RUNTIME DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_BinDirName}"
	)
else()
	install(TARGETS ${ModuleName}
		LIBRARY DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_LibDirName}"
	)
endif()

if(WIN32)
	install(FILES "$<TARGET_FILE_DIR:${ModuleName}>/${ModuleName}.pdb"
		DESTINATION "${c_ProjectInstallingTargetDirPath}/${c_BinDirName}"
		CONFIGURATIONS Debug
	)
endif()