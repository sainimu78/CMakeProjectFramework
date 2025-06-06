set(c_StorageConfigFilePath ${c_RootProjectDirPath}/StorageConfig.cmake)
#file(RELATIVE_PATH StorageConfigRelativeToRootFilePath ${c_RootDirPath} ${c_StorageConfigFilePath})
set(c_StorageConfigDownloadingFailedTips "Failed to download the file, possibly due to incorrect storage config, see: ${c_StorageConfigFilePath}")
set(DefaultStorageHost 192.168.31.233)
if(NOT EXISTS "${c_StorageConfigFilePath}")
	# VPN: http://172.31.222.172/
	# WLAN: http://192.168.31.233/
	#set(VarStorageIPAddress http://WishingContributor:1@192.168.31.233/sainimu78_Storage)
	set(VarStorageHfsAddr "http://WishingContributor:1@\$\{c_StorageHost\}/sainimu78_Storage")
	set(FileContent
"set(c_StorageHost \"${DefaultStorageHost}\")

set(c_StorageAddrPath \"${VarStorageHfsAddr}\")
if(WIN32)
	set(c_StorageDirPath \"F:/sainimu78_Storage\")
else()
	set(c_StorageDirPath \"/mnt/Ubuntu_Storage\")
endif()

#set(c_VpnPort 1080)
")
	
	file(WRITE "${c_StorageConfigFilePath}" "${FileContent}")
	message(STATUS "Generated ${c_StorageConfigFilePath}")
endif()

include(${c_StorageConfigFilePath})

function(check_host_reachable host result_var)
    # 默认设置为不可达
    set(reachable FALSE)
    
    if(WIN32)
        # Windows 方案：使用 PowerShell 的 Test-Connection
        execute_process(
            COMMAND powershell -Command 
                "if (Test-Connection -ComputerName '${host}' -Count 1 -Quiet -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"
            RESULT_VARIABLE result
            OUTPUT_QUIET
            ERROR_QUIET
        )
        
        if(result EQUAL 0)
            set(reachable TRUE)
        endif()
        
    else()
        # Linux/macOS 方案：使用 ping + 输出分析
        execute_process(
            COMMAND ping -c 1 -W 1 ${host}
            RESULT_VARIABLE result
            OUTPUT_VARIABLE output
            ERROR_VARIABLE error
        )
        
        # 分析输出结果
        if(result EQUAL 0)
            # 检查是否实际收到回复
            if(output MATCHES ".*[1-9][0-9]* bytes from.*")
                set(reachable TRUE)
            endif()
        endif()
    endif()
    
    # 设置返回结果
    set(${result_var} ${reachable} PARENT_SCOPE)
endfunction()

set(c_IsLocalStorageReachable TRUE)#新增定义 c_StorageHost 前的版本仅使用本地存储流程
if(c_StorageHost)
	message("Checking local storage ...")
	#begin, 基于网络的检查执行太慢, 且 Windows 下依赖 PowerShell, 应考虑换方法, 因此不启用
	#check_host_reachable(${c_StorageHost} IsHostReachable)
	#暂通过直接检查发布用的本地目录存在作依据
	set(IsHostReachable FALSE)
	if(EXISTS ${c_StorageDirPath})
		set(IsHostReachable TRUE)
	endif()
	#end
	if(IsHostReachable)
		message("Local storage is reachable")
	else()
		message("Local storage is not reachable")
		set(c_IsLocalStorageReachable FALSE)
	endif()
endif()

if(NOT c_IsLocalStorageReachable)
	if(c_VpnPort)
		if (c_VpnPort EQUAL 0)
			message(FATAL_ERROR "Invalid port number of c_VpnPort")
		endif()
		set(ENV{http_proxy} "http://${c_StorageHost}:${c_VpnPort}")
		set(ENV{https_proxy} "http://${c_StorageHost}:${c_VpnPort}")
	endif()
endif()

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

function(download_files ListSrcToDownload ListDstDownloaded)
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

function(download_file SrcToDownload DstDownloaded)
	download_files("${SrcToDownload}" "${DstDownloaded}")
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

function(unzip_and_delete DstDownloadedFilePath DstUnzippedDirPath)
	file(REMOVE_RECURSE "${DstUnzippedDirPath}")
	get_filename_component(ParentDir "${DstUnzippedDirPath}" DIRECTORY)
	unzip_file(${DstDownloadedFilePath} ${ParentDir})
	file(REMOVE "${DstDownloadedFilePath}")
endfunction()

function(download_zip_replace_dir SrcAddrZipFilePath DstDownloadedFilePath DstUnzippedDirPath)
	message(STATUS "Downloading ${DstDownloadedFilePath} from ${SrcAddrZipFilePath}")
	file(DOWNLOAD ${SrcAddrZipFilePath} ${DstDownloadedFilePath}
		STATUS status
		#SHOW_PROGRESS
	)
	if(status EQUAL 0)
		message(STATUS "File downloaded successfully.")
		unzip_and_delete("${DstDownloadedFilePath}" "${DstUnzippedDirPath}")
	else()
		file(SIZE "${DstDownloadedFilePath}" FileSize)
		if(FileSize EQUAL 0)
			file(REMOVE "${DstDownloadedFilePath}")
		endif()
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

function(cpf_include cmakeFilePath)
	# 与 builtin include 不同之处在于使 include 中定义的变量只在在 function 作用域内有有效
	include("${cmakeFilePath}")
endfunction()

function(cpf_include_install cmakeFilePath)
	# 作用同 cpf_include, 带默认 Install, 用于接入 add_library( SHARED ) 的 target
	include("${cmakeFilePath}")
	include(${c_ProjectDirPath}/Install.cmake)
endfunction()

function(is_target_shared TARGET RESULT_VAR)
    # 获取目标的类型
    get_target_property(target_type ${TARGET} TYPE)
    # 判断是否为 SHARED_LIBRARY
    if(target_type STREQUAL "SHARED_LIBRARY")
        set(${RESULT_VAR} TRUE PARENT_SCOPE)
    else()
        set(${RESULT_VAR} FALSE PARENT_SCOPE)
    endif()
endfunction()

if (WIN32)
	#避免如 freopen 的 Warning C4996
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)# 可将工程添加到目录中, 如 set_target_properties(NiflectGenTool_${ModuleName} PROPERTIES FOLDER "AutoGen")