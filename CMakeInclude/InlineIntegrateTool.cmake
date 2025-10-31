if(v_ZipFileName)
	set(NonPipelineSetupDependencyCheckingDirPath )
	#指定 v_LibPlatformArchDirPath 可支持 Windows 宿主机中使用 VS + Ubuntu 容器中构建共用挂载目录
	#但须注意, 否则 Windows 中文件系统修改挂载目录会导致 Ubuntu 的文件系统出错, 出现如头文件中定义重复的编译错误
	#1. Linux 与 Windows 都可获取到有效包, 应先 Generate.bat 再 Generate.sh 或先 Setup.bat 再 Update.sh
	#2. 只有 Linux 可获取到有效包, 应先 Generate.sh 再 Generate.bat 或先 Setup.sh 再 Update.bat
	#上述方式, 由于在挂载目录中操作, 构建等过程执行缓慢, 并不建议使用, 更建议使用 VS Code + Remote SSH
	if(v_LibPlatformArchDirPath)
		set(NonPipelineSetupDependencyCheckingDirPath ${v_LibPlatformArchDirPath})
	elseif(v_UnzippedDirPath)
		set(NonPipelineSetupDependencyCheckingDirPath ${v_UnzippedDirPath})
	else()
		message(FATAL_ERROR "Must specify v_LibPlatformArchDirPath or v_UnzippedDirPath")
	endif()
	set(DstDownloadedFilePath ${v_IntegratedToolRootDirPath}/${v_ZipFileName})
	if(c_ProjectPipelineSetup OR NOT EXISTS "${NonPipelineSetupDependencyCheckingDirPath}")
		set(SrcAddrZipFilePath ${v_SrcZipAddrFilePath})
		if((NOT c_IsLocalStorageReachable) AND v_SrcZipCloudFilePath)
			set(SrcAddrZipFilePath ${v_SrcZipCloudFilePath})
		endif()
		if (c_ProjectPipelineSetup)
			message("Deleting the unzipped directory ${v_UnzippedDirPath}")
			file(REMOVE_RECURSE "${v_UnzippedDirPath}")
			message("Deleted ${v_UnzippedDirPath}")
		endif()
		download_zip_replace_dir_if_not_exists(${SrcAddrZipFilePath} ${DstDownloadedFilePath} ${v_UnzippedDirPath} IsDownloaded)
	endif()
endif()