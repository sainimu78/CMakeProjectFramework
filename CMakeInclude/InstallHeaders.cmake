
foreach(It IN LISTS v_ListModuleInstallingHeaderDirPath)
	install(DIRECTORY "${It}" DESTINATION "${c_ProjectInstallingDirPath}")
endforeach()

unset(v_ListModuleInstallingHeaderDirPath)