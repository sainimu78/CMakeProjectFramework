include(${c_RootCMakeProjectFrameworkDirPath}/InlineDownloadAndUnzip.cmake)

if(v_FindPackageBasedIntegration)
	find_package(${v_LibNameFindPackgeBased} ${v_LibVersionFindPackageBased} REQUIRED COMPONENTS ${v_ListComponentFindPackgeBased})
	set(ListLinkingLib "")
	foreach(It ${v_ListComponentFindPackgeBased})
		set(ConcatedName ${v_LibNameFindPackgeBased}::${It})
		list(APPEND ListLinkingLib ${ConcatedName})
	endforeach()
	target_link_libraries(${ModuleName} PRIVATE ${ListLinkingLib})
	if(c_ProjectRequiredBinInstalling)
		if(WIN32)
			if(v_ListDeployingBinFilePathNoExtFindPackageBasedDebug)
				foreach(It IN LISTS v_ListDeployingBinFilePathNoExtFindPackageBasedDebug)
					set(SrcFilePath0 ${It}${c_SharedLibFileExt})
					get_filename_component(FileName "${SrcFilePath0}" NAME)
					set(DstFilePath0 ${c_ProjectBinDirPathDebug}/${FileName})
					if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath0}")
						message("Deploying: ${SrcFilePath0} ${c_ProjectBinDirPathDebug}")
						file(COPY "${SrcFilePath0}" DESTINATION "${c_ProjectBinDirPathDebug}")
					endif()
					set(SrcFilePath1 ${It}.pdb)
					get_filename_component(FileName "${SrcFilePath1}" NAME)
					set(DstFilePath1 ${c_ProjectBinDirPathDebug}/${FileName})
					if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath1}")
						message("Deploying: ${SrcFilePath1} ${c_ProjectBinDirPathDebug}")
						file(COPY "${SrcFilePath1}" DESTINATION "${c_ProjectBinDirPathDebug}")
					endif()
					install(FILES "${SrcFilePath0}" "${SrcFilePath1}"
						DESTINATION "${c_ProjectInstallingTargetDirPathDebug}/${c_BinDirName}/")
				endforeach()
			endif()
			if(v_ListDeployingBinFilePathNoExtFindPackageBasedRelease)
				foreach(It IN LISTS v_ListDeployingBinFilePathNoExtFindPackageBasedRelease)
					set(SrcFilePath ${It}${c_SharedLibFileExt})
					get_filename_component(FileName "${SrcFilePath}" NAME)
					set(DstFilePath ${c_ProjectBinDirPathRelease}/${FileName})
					if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath}")
						message("Deploying: ${SrcFilePath} ${c_ProjectBinDirPathRelease}")
						file(COPY "${SrcFilePath}" DESTINATION "${c_ProjectBinDirPathRelease}")
					endif()
					install(FILES "${SrcFilePath}"
						DESTINATION "${c_ProjectInstallingTargetDirPathRelease}/${c_BinDirName}/")
				endforeach()
			endif()

			#list(LENGTH v_ListDeployingSrcFilePathFindPackageBasedDebug Len0)
			#list(LENGTH v_ListDeployingDstRelativeDirPathFindPackageBasedDebug Len1)
			#if(Len0 EQUAL Len1)
			#	math(EXPR Len0MinusOne "${Len0} - 1")
			#	foreach(Idx RANGE 0 ${Len0MinusOne})
			#		list(GET v_ListDeployingSrcFilePathFindPackageBasedDebug ${Idx} SrcFilePath)
			#		list(GET v_ListDeployingDstRelativeDirPathFindPackageBasedDebug ${Idx} RelativeDstDirPath)
			#		get_filename_component(FileName "${SrcFilePath}" NAME)
			#		set(DstDirPath ${c_ProjectBinDirPathDebug}/${RelativeDstDirPath})
			#		set(DstFilePath ${DstDirPath}/${FileName})
			#		if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath}")
			#			message("Deploying: ${SrcFilePath} ${DstDirPath}")
			#			file(COPY "${SrcFilePath}" DESTINATION "${DstDirPath}")
			#		endif()
			#		set(DstInstallingDirPath ${c_ProjectInstallingTargetDirPathDebug}/${c_BinDirName})
			#		if(RelativeDstDirPath)
			#			set(DstInstallingDirPath ${DstInstallingDirPath}/${RelativeDstDirPath})
			#		endif()
			#		message("sssssssssssssssss ${DstInstallingDirPath}")
			#		install(FILES "${SrcFilePath}"
			#			DESTINATION "${DstInstallingDirPath}/")
			#	endforeach()
			#else()
			#	message(FATAL_ERROR "The two lists are not of the same length!")
			#endif()
			#list(LENGTH v_ListDeployingSrcFilePathFindPackageBasedRelease Len0)
			#list(LENGTH v_ListDeployingDstRelativeDirPathFindPackageBasedRelease Len1)
			#if(Len0 EQUAL Len1)
			#	math(EXPR Len0MinusOne "${Len0} - 1")
			#	foreach(Idx RANGE 0 ${Len0MinusOne})
			#		list(GET v_ListDeployingSrcFilePathFindPackageBasedRelease ${Idx} SrcFilePath)
			#		list(GET v_ListDeployingDstRelativeDirPathFindPackageBasedRelease ${Idx} RelativeDstDirPath)
			#		get_filename_component(FileName "${SrcFilePath}" NAME)
			#		set(DstDirPath ${c_ProjectBinDirPathRelease}/${RelativeDstDirPath})
			#		set(DstFilePath ${DstDirPath}/${FileName})
			#		if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath}")
			#			message("Deploying: ${SrcFilePath} ${DstDirPath}")
			#			file(COPY "${SrcFilePath}" DESTINATION "${DstDirPath}")
			#		endif()
			#		set(DstInstallingDirPath ${c_ProjectInstallingTargetDirPathRelease}/${c_BinDirName})
			#		if(RelativeDstDirPath)
			#			set(DstInstallingDirPath ${DstInstallingDirPath}/${RelativeDstDirPath})
			#		endif()
			#		install(FILES "${SrcFilePath}"
			#			DESTINATION "${DstInstallingDirPath}/")
			#	endforeach()
			#else()
			#	message(FATAL_ERROR "The two lists are not of the same length!")
			#endif()

			if(v_ListDeployingSrcFilePathFindPackageBasedDebug)
				deploy_files(
					v_ListDeployingSrcFilePathFindPackageBasedDebug
					v_ListDeployingDstRelativeDirPathFindPackageBasedDebug
					${c_ProjectBinDirPathDebug}
					${c_ProjectInstallingTargetDirPathDebug}/${c_BinDirName}
				)
			endif()
			if(v_ListDeployingSrcFilePathFindPackageBasedRelease)
				deploy_files(
					v_ListDeployingSrcFilePathFindPackageBasedRelease
					v_ListDeployingDstRelativeDirPathFindPackageBasedRelease
					${c_ProjectBinDirPathRelease}
					${c_ProjectInstallingTargetDirPathRelease}/${c_BinDirName}
				)
			endif()
		else()
			if(v_ListDeployingBinFilePathNoExtFindPackageBasedDebug)
				foreach(It IN LISTS v_ListDeployingBinFilePathNoExtFindPackageBasedDebug)
					set(SrcFilePath ${It}${c_SharedLibFileExt})
					install(FILES "${SrcFilePath}"
						DESTINATION "${c_ProjectInstallingTargetDirPathDebug}/${c_LibDirName}/")
				endforeach()
				foreach(It IN LISTS v_ListDeployingBinFilePathNoExtFindPackageBasedRelease)
					set(SrcFilePath ${It}${c_SharedLibFileExt})
					install(FILES "${SrcFilePath}"
						DESTINATION "${c_ProjectInstallingTargetDirPathDebug}/${c_LibDirName}/")
				endforeach()
			endif()

			#list(LENGTH v_ListDeployingSrcFilePathFindPackageBasedDebug Len0)
			#list(LENGTH v_ListDeployingDstRelativeDirPathFindPackageBasedDebug Len1)
			#if(Len0 EQUAL Len1)
			#	math(EXPR Len0MinusOne "${Len0} - 1")
			#	foreach(Idx RANGE 0 ${Len0MinusOne})
			#		list(GET v_ListDeployingSrcFilePathFindPackageBasedDebug ${Idx} SrcFilePath)
			#		list(GET v_ListDeployingDstRelativeDirPathFindPackageBasedDebug ${Idx} RelativeDstDirPath)
			#		get_filename_component(FileName "${SrcFilePath}" NAME)
			#		set(DstDirPath ${c_ProjectLibDirPathDebug}/${RelativeDstDirPath})
			#		set(DstFilePath ${DstDirPath}/${FileName})
			#		if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath}")
			#			message("Deploying: ${SrcFilePath} ${DstDirPath}")
			#			file(COPY "${SrcFilePath}" DESTINATION "${DstDirPath}")
			#		endif()
			#		set(DstInstallingDirPath ${c_ProjectInstallingTargetDirPathDebug}/${c_BinDirName})
			#		if(RelativeDstDirPath)
			#			set(DstInstallingDirPath ${DstInstallingDirPath}/${RelativeDstDirPath})
			#		endif()
			#		install(FILES "${SrcFilePath}"
			#			DESTINATION "${DstInstallingDirPath}/")
			#	endforeach()
			#else()
			#	message(FATAL_ERROR "The two lists are not of the same length!")
			#endif()
			#list(LENGTH v_ListDeployingSrcFilePathFindPackageBasedRelease Len0)
			#list(LENGTH v_ListDeployingDstRelativeDirPathFindPackageBasedRelease Len1)
			#if(Len0 EQUAL Len1)
			#	math(EXPR Len0MinusOne "${Len0} - 1")
			#	foreach(Idx RANGE 0 ${Len0MinusOne})
			#		list(GET v_ListDeployingSrcFilePathFindPackageBasedRelease ${Idx} SrcFilePath)
			#		list(GET v_ListDeployingDstRelativeDirPathFindPackageBasedRelease ${Idx} RelativeDstDirPath)
			#		get_filename_component(FileName "${SrcFilePath}" NAME)
			#		set(DstDirPath ${c_ProjectLibDirPathDebug}/${RelativeDstDirPath})
			#		set(DstFilePath ${DstDirPath}/${FileName})
			#		if(PROJECT_SETUP OR NOT EXISTS "${DstFilePath}")
			#			message("Deploying: ${SrcFilePath} ${DstDirPath}")
			#			file(COPY "${SrcFilePath}" DESTINATION "${DstDirPath}")
			#		endif()
			#		set(DstInstallingDirPath ${c_ProjectInstallingTargetDirPathRelease}/${c_BinDirName})
			#		if(RelativeDstDirPath)
			#			set(DstInstallingDirPath ${DstInstallingDirPath}/${RelativeDstDirPath})
			#		endif()
			#		install(FILES "${SrcFilePath}"
			#			DESTINATION "${DstInstallingDirPath}/")
			#	endforeach()
			#else()
			#	message(FATAL_ERROR "The two lists are not of the same length!")
			#endif()

			if(v_ListDeployingSrcFilePathFindPackageBasedDebug)
				deploy_files(
					v_ListDeployingSrcFilePathFindPackageBasedDebug
					v_ListDeployingDstRelativeDirPathFindPackageBasedDebug
					${c_ProjectLibDirPathDebug}
					${c_ProjectInstallingTargetDirPathDebug}/${c_LibDirName}
				)
			endif()
			if(v_ListDeployingSrcFilePathFindPackageBasedRelease)
				deploy_files(
					v_ListDeployingSrcFilePathFindPackageBasedRelease
					v_ListDeployingDstRelativeDirPathFindPackageBasedRelease
					${ProjectLibDirPathReleases}
					${c_ProjectInstallingTargetDirPathRelease}/${c_LibDirName}
				)
			endif()
		endif()
	endif()
else()
	target_include_directories(${ModuleName} PRIVATE "${v_ListLibIncludeDirPathPrivate}")

	if(v_ListImportedLibFilePathDebugPrivate)
		target_link_libraries(${ModuleName} PRIVATE "$<$<CONFIG:Debug>:${v_ListImportedLibFilePathDebugPrivate}>")
		list(APPEND LibFilePathsDebugPrivate ${v_ListImportedLibFilePathDebugPrivate})
	endif()
	if(v_ListImportedLibFilePathReleasePrivate)
		target_link_libraries(${ModuleName} PRIVATE "$<$<CONFIG:Release>:${v_ListImportedLibFilePathReleasePrivate}>")
		list(APPEND LibFilePathsReleasePrivate ${v_ListImportedLibFilePathReleasePrivate})
	endif()

	if(v_ListImportedLibFileName)
		set(LibDirPathDebug ${v_LibPlatformArchDirPath}/Debug/${c_LibDirName})
		set(LibDirPathRelease ${v_LibPlatformArchDirPath}/Release/${c_LibDirName})
		foreach(It ${v_ListImportedLibFileName})
			set(LibFileNameDebug ${It})
			set(LibFileNameRelease ${It})
			if(v_DebugLibFileNamePostfix)
				set(LibFileNameDebug ${LibFileNameDebug}${v_DebugLibFileNamePostfix})
			endif()
			set(LibFileExt )
			if(WIN32)
				set(LibFileExt ${c_StaticLibFileExt})
			else()
				if(NOT LibFileNameDebug MATCHES "^${c_SharedLibFileNamePrefix}")
					set(LibFileNameDebug ${c_SharedLibFileNamePrefix}${LibFileNameDebug})
				endif()
				if(NOT LibFileNameRelease MATCHES "^${c_SharedLibFileNamePrefix}")
					set(LibFileNameRelease ${c_SharedLibFileNamePrefix}${LibFileNameRelease})
				endif()
				set(LibFileExt ${c_SharedLibFileExt})
			endif()
			list(APPEND LibFilePathsDebugPrivate "${LibDirPathDebug}/${LibFileNameDebug}${LibFileExt}")
			list(APPEND LibFilePathsReleasePrivate "${LibDirPathRelease}/${LibFileNameRelease}${LibFileExt}")
		endforeach()

		target_link_libraries(${ModuleName} PRIVATE
			"$<$<CONFIG:Debug>:${LibFilePathsDebugPrivate}>"
			"$<$<CONFIG:Release>:${LibFilePathsReleasePrivate}>"
		)
	endif()
	if(c_ProjectRequiredBinInstalling)
		if(WIN32)
			if(v_LibPlatformArchDirPath)
				set(BinDirPathDebug ${v_LibPlatformArchDirPath}/Debug/${c_BinDirName})
				set(BinDirPathRelease ${v_LibPlatformArchDirPath}/Release/${c_BinDirName})
				
				file(GLOB ListDeployingFilePathDebug "${BinDirPathDebug}/*")
				if(LibFilePathsDebugPrivate)
					list(GET ListDeployingFilePathDebug 0 Item0)
					get_filename_component(FileName "${Item0}" NAME)
					set(FilePathDebug ${c_ProjectBinDirPathDebug}/${FileName})
				endif()
				if(PROJECT_SETUP OR NOT EXISTS "${FilePathDebug}")
					message("Deploying: ${BinDirPathDebug} ${c_ProjectBinDirPathDebug}")
					file(COPY "${BinDirPathDebug}/" DESTINATION "${c_ProjectBinDirPathDebug}/")
				endif()
				
				file(GLOB ListDeployingFilePathRelease "${BinDirPathRelease}/*")
				if(LibFilePathsReleasePrivate)
					list(GET ListDeployingFilePathRelease 0 Item0)
					get_filename_component(FileName "${Item0}" NAME)
					set(FilePathRelease ${c_ProjectBinDirPathRelease}/${FileName})
				endif()
				if(PROJECT_SETUP OR NOT EXISTS "${FilePathRelease}")
					message("Deploying: ${BinDirPathRelease} ${c_ProjectBinDirPathRelease}")
					file(COPY "${BinDirPathRelease}/" DESTINATION "${c_ProjectBinDirPathRelease}/")
				endif()
				
				install(DIRECTORY "${BinDirPathDebug}/"
					DESTINATION "${c_ProjectInstallingTargetDirPathDebug}/${c_BinDirName}/"
					CONFIGURATIONS Debug
					#FILES_MATCHING PATTERN "*.so"
					USE_SOURCE_PERMISSIONS
				)
				install(DIRECTORY "${BinDirPathRelease}/"
					DESTINATION "${c_ProjectInstallingTargetDirPathRelease}/${c_BinDirName}/"
					CONFIGURATIONS Release
					#FILES_MATCHING PATTERN "*.so"
					USE_SOURCE_PERMISSIONS
				)
			endif()
		else()
			if(LibDirPathDebug)
				install(DIRECTORY "${LibDirPathDebug}/"
					DESTINATION "${c_ProjectInstallingTargetDirPathDebug}/${c_LibDirName}/"
					CONFIGURATIONS Debug
					#FILES_MATCHING PATTERN "*.so"
					USE_SOURCE_PERMISSIONS
				)
			endif()
			if(LibDirPathRelease)
				install(DIRECTORY "${LibDirPathRelease}/"
					DESTINATION "${c_ProjectInstallingTargetDirPathRelease}/${c_LibDirName}/"
					CONFIGURATIONS Release
					#FILES_MATCHING PATTERN "*.so"
					USE_SOURCE_PERMISSIONS
				)
			endif()
		endif()
	endif()
endif()

#begin, Required
unset(v_ImportedLibRootDirPath)
unset(v_UnzippedDirPath)
unset(v_ZipFileName)
unset(v_SrcAddrZipFilePath)
unset(v_LibPlatformArchDirPath)
unset(v_ListLibIncludeDirPathPrivate)
unset(v_LibPlatformArchIncludeDirPath)

unset(v_LibVersionFindPackageBased)
unset(v_PackageRootDirPathFindPackageBased)
unset(v_FindPackageBasedIntegration)
unset(v_LibNameFindPackgeBased)
unset(v_ListComponentFindPackgeBased)
unset(v_ListDeployingBinFilePathNoExtFindPackageBasedDebug)
unset(v_ListDeployingBinFilePathNoExtFindPackageBasedRelease)
unset(v_ListDeployingSrcFilePathFindPackageBasedDebug)
unset(v_ListDeployingDstRelativeDirPathFindPackageBasedDebug)
unset(v_ListDeployingSrcFilePathFindPackageBasedRelease)
unset(v_ListDeployingDstRelativeDirPathFindPackageBasedRelease)
#end

#begin, Optional
unset(v_DebugLibFileNamePostfix)
unset(v_ListImportedLibFilePathDebugPrivate)
unset(v_ListImportedLibFilePathReleasePrivate)
unset(v_ListImportedLibFileName)
#end