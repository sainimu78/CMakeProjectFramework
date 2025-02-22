set(c_StorageConfigFilePath ${c_RootProjectDirPath}/StorageConfig.cmake)
#file(RELATIVE_PATH StorageConfigRelativeToRootFilePath ${c_RootDirPath} ${c_StorageConfigFilePath})
set(c_StorageConfigDownloadingFailedTips "Failed to download the file, possibly due to incorrect storage config, see: ${c_StorageConfigFilePath}")
if(NOT EXISTS "${c_StorageConfigFilePath}")
	# VPN: http://172.31.222.172/
	# WLAN: http://192.168.31.233/
	set(VarStorageIPAddress http://WishingContributor:1@192.168.31.233/sainimu78_Storage)
	set(FileContent
"set(c_StorageAddrPath \"${VarStorageIPAddress}\")
if(WIN32)
	set(c_StorageDirPath \"F:/sainimu78_Storage\")
else()
	set(c_StorageDirPath \"/mnt/Ubuntu_Storage\")
endif()
")
	
	file(WRITE "${c_StorageConfigFilePath}" "${FileContent}")
	message(STATUS "Generated ${c_StorageConfigFilePath}")
endif()

include(${c_StorageConfigFilePath})

FUNCTION(create_source_group relativeSourcePath)
  FOREACH(currentSourceFile ${ARGN})
    FILE(RELATIVE_PATH folder ${relativeSourcePath} ${currentSourceFile})
    GET_FILENAME_COMPONENT(filename ${folder} NAME)
    STRING(REPLACE ${filename} "" folder ${folder})
    IF(NOT folder STREQUAL "")
      STRING(REGEX REPLACE "/+$" "" folderlast ${folder})
      STRING(REPLACE "/" "\\" folderlast ${folderlast})
      SOURCE_GROUP("${folderlast}" FILES ${currentSourceFile})
    ENDIF(NOT folder STREQUAL "")
  ENDFOREACH(currentSourceFile ${ARGN})
ENDFUNCTION()

function(download_files_reserved ListSrcToDownload ListDstDownloaded)
	list(LENGTH ListSrcToDownload ListCount0)
	list(LENGTH ListDstDownloaded ListCount1)
	#math(EXPR MinCount "ListCount0 < ListCount1 ? ListCount0 : ListCount1")
	if(NOT ListCount0 EQUAL ListCount1)
		message(FATAL_ERROR "The counts for both ListSrcToDownload and ListDstDownloaded must be identical")
	endif()
	foreach(Idx RANGE 0 ${MinCount})
		list(GET ListSrcToDownload ${Idx} SrcItem)
		list(GET ListDstDownloaded ${Idx} Dstitem)
		message(STATUS "Downloading ${Dstitem} from ${SrcItem}")
		file(DOWNLOAD ${SrcItem} ${Dstitem}
			 STATUS status
			 #SHOW_PROGRESS
		)
		if(status EQUAL 0)
			message(STATUS "File downloaded successfully.")
		else()
			message(FATAL_ERROR "${c_StorageConfigDownloadingFailedTips}")
		endif()
	endforeach()
endfunction()

function(zip_directory DirPathToZip ZipFilePath)
	if(WIN32)
		include(${c_RootCMakeProjectFrameworkDirPath}/GetZip.cmake)
		execute_process(
			#COMMAND ${CMAKE_COMMAND} -E echo "Packaging ${c_ProjectName} ..."
			COMMAND ${ExeFilePath7z} a "${ZipFilePath}" "${DirPathToZip}"
			RESULT_VARIABLE ZIP_RESULT
		)
	else()
		get_filename_component(DirName "${DirPathToZip}" NAME)
		get_filename_component(ParentDir "${DirPathToZip}" DIRECTORY)
		execute_process(
			COMMAND zip -r -v "${ZipFilePath}" "${DirName}"
			WORKING_DIRECTORY "${ParentDir}"
			RESULT_VARIABLE ZIP_RESULT
		)
	endif()
endfunction()

function(unzip_file ZipFilePath DirPathUnzipTo)
	if(WIN32)
		include(${c_RootCMakeProjectFrameworkDirPath}/GetZip.cmake)
		string(REPLACE "/" "\\" DirPathToCreate "${DirPathUnzipTo}")
		execute_process(
			COMMAND ${ExeFilePath7z} x "${ZipFilePath}" -o${DirPathToCreate}
			RESULT_VARIABLE ZIP_RESULT
		)
	else()
		execute_process(
			COMMAND unzip -o "${ZipFilePath}" -d "${DirPathUnzipTo}"
			RESULT_VARIABLE ZIP_RESULT
		)
	endif()
endfunction()

function(download_zip_replace_dir SrcAddrZipFilePath DstDownloadedFilePath DstUnzippedDirPath)
	message(STATUS "Downloading ${DstDownloadedFilePath} from ${SrcAddrZipFilePath}")
	file(DOWNLOAD ${SrcAddrZipFilePath} ${DstDownloadedFilePath}
		STATUS status
		#SHOW_PROGRESS
	)
	if(status EQUAL 0)
		message(STATUS "File downloaded successfully.")
		file(REMOVE_RECURSE "${DstUnzippedDirPath}")
		get_filename_component(ParentDir "${DstUnzippedDirPath}" DIRECTORY)
		unzip_file(${DstDownloadedFilePath} ${ParentDir})		
		file(REMOVE "${DstDownloadedFilePath}")
	else()
		message(FATAL_ERROR "${c_StorageConfigDownloadingFailedTips}")
	endif()
endfunction()

function(deploy_files src_list dst_list project_lib_dir_path install_target_dir_path)
    list(LENGTH ${src_list} Len0)
    list(LENGTH ${dst_list} Len1)
    if(Len0 EQUAL Len1)
        math(EXPR Len0MinusOne "${Len0} - 1")
        foreach(Idx RANGE 0 ${Len0MinusOne})
            list(GET ${src_list} ${Idx} SrcFilePath)
            list(GET ${dst_list} ${Idx} RelativeDstDirPath)
            get_filename_component(FileName "${SrcFilePath}" NAME)
            set(DstDirPath ${project_lib_dir_path}/${RelativeDstDirPath})
            set(DstFilePath ${DstDirPath}/${FileName})
            if(c_ProjectPipelineSetup OR NOT EXISTS "${DstFilePath}")
                message("Deploying: ${SrcFilePath} ${DstDirPath}")
                file(COPY "${SrcFilePath}" DESTINATION "${DstDirPath}")
            endif()
            set(DstInstallingDirPath ${install_target_dir_path})
            if(RelativeDstDirPath)
                set(DstInstallingDirPath ${DstInstallingDirPath}/${RelativeDstDirPath})
            endif()
            install(FILES "${SrcFilePath}"
                DESTINATION "${DstInstallingDirPath}/")
        endforeach()
    else()
        message(FATAL_ERROR "The two lists are not of the same length!")
    endif()
endfunction()

# 声明一个用于跟踪已下载文件的变量，使用 CACHE 将其持久化
set(downloaded_files "" CACHE STRING "List of downloaded files")

# 函数：检查文件是否已下载，若未下载则进行下载
function(download_zip_replace_dir_if_not_exists SrcAddrZipFilePath DstDownloadedFilePath UnzippedDirPath result_var)
    # 检查文件是否已在列表中
    list(FIND downloaded_files "${DstDownloadedFilePath}" is_downloaded)

    if(NOT is_downloaded EQUAL -1)
        message(STATUS "Skip downloading ${DstDownloadedFilePath}")
        set(${result_var} FALSE PARENT_SCOPE)  # 设置结果为 FALSE
    else()
        download_zip_replace_dir(${SrcAddrZipFilePath} ${DstDownloadedFilePath} ${UnzippedDirPath})
    
        # 将文件添加到已下载的列表
        list(APPEND downloaded_files ${DstDownloadedFilePath})
        set(downloaded_files "${downloaded_files}" CACHE STRING "List of downloaded files" FORCE)
        set(${result_var} TRUE PARENT_SCOPE)  # 设置结果为 TRUE
    endif()
endfunction()

macro(define_enum var default_value description)
    set(${var} "${default_value}" CACHE STRING "${description}")
    set_property(CACHE ${var} PROPERTY STRINGS ${ARGN})  # 设置允许的值

    # 将 ARGN 转换为显式命名的列表变量
    set(allowed_values ${ARGN})

    # 使用 allowed_values 进行验证
    if(NOT ${var} IN_LIST allowed_values)
        message(FATAL_ERROR "Invalid value for ${var}: ${${var}}. Allowed values: ${allowed_values}")
    endif()
endmacro()

macro(ngt_target_link_libraries TargetName Scope)
	foreach(Arg ${ARGN})
		target_link_libraries(${TargetName} ${Scope} ${Arg})
		get_target_property(ListIncludeDirPathPublic ${Arg} INTERFACE_INCLUDE_DIRECTORIES)
		if(ListIncludeDirPathPublic)
			list(APPEND v_ListModuleIncludeDirPath ${ListIncludeDirPathPublic})
		endif()
		get_target_property(ListPrecompileHeaderFilePathPublic ${Arg} INTERFACE_PRECOMPILE_HEADERS)
		if(ListPrecompileHeaderFilePathPublic)
			list(APPEND v_ListModulePrecompileHeaderFilePath ${ListPrecompileHeaderFilePathPublic})
		endif()
	endforeach()
endmacro()

if (WIN32)
	#避免如 freopen 的 Warning C4996
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)# 可将工程添加到目录中, 如 set_target_properties(NiflectGenTool_${ModuleName} PROPERTIES FOLDER "AutoGen")