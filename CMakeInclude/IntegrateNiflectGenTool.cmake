include(${c_RootCMakeProjectFrameworkDirPath}/InlineIntegrateTool.cmake)

#begin, 区分 Debug 与 Release 两种版本的 GenTool, add_custom_command 中变量不用引号
#set(GenToolRootPath ${c_RootThirdPartyDirPath}/${v_IntegratedToolName}/${v_IntegratedToolName})
#set(ToolExeName ${v_IntegratedToolName}${c_ExecutableFileExt})
#set(GenToolBinDirPathDebug ${GenToolRootPath}/build/${c_ProjectPlatform}/${c_ProjectArch}/Debug/bin)
#set(GenToolBinDirPathRelease ${GenToolRootPath}/build/${c_ProjectPlatform}/${c_ProjectArch}/Release/bin)
#set(GenToolFilePathDebug ${GenToolBinDirPathDebug}/${ToolExeName})
#set(GenToolFilePathRelease ${GenToolBinDirPathRelease}/${ToolExeName})
#set(GenToolExeFilePath "$<$<CONFIG:Debug>:${GenToolFilePathDebug}>$<$<CONFIG:Release>:${GenToolFilePathRelease}>")
#end

set(ToolExeName ${v_IntegratedToolName}${c_ExecutableFileExt})
set(GenToolExeFilePath ${v_NiflectGenToolBinDirPath}/${ToolExeName})

if(NOT EXISTS "${GenToolExeFilePath}")
	message(FATAL_ERROR "${GenToolExeFilePath} doesn't exist")
endif()

set(NiflectRootPath ${c_RootThirdPartyDirPath}/Niflect/Niflect)
if(v_NiflectRootPath)
	set(NiflectRootPath ${v_NiflectRootPath})
endif()
set(NiflectIncludeDirPath ${NiflectRootPath}/include)

set(GenOutputDirPath ${c_RootGeneratedDirPath}/${c_ProjectRelativeDirPath}/${ModuleName})
set(GenSourcePrivate ${GenOutputDirPath}/_GenSource)
set(GenSourcePublic ${GenSourcePrivate}/include)
#beign, 用于模式 EGeneratingHeaderAndSourceFileMode::ESourceAndHeader, 将生成文件加到模块
#file(GLOB_RECURSE GeneratedSrc ${GenSourcePrivate}/*.cpp ${GenSourcePrivate}/*.h)
#create_source_group(${NiflectGeneratedRootPath} ${GeneratedSrc})
#list(APPEND SrcAll ${GeneratedSrc})
#end

set(ListOptMacroTagHeaderFilePath "")
if (v_MacroTagHeaderFilePath)
	list(APPEND ListOptMacroTagHeaderFilePath "-m" "${v_MacroTagHeaderFilePath}")
endif()

set(ListOptModuleHeaders "")
foreach(It IN LISTS v_ListModuleHeaderFilePath)
    list(APPEND ListOptModuleHeaders "-h" "${It}")
endforeach()

set(ListPrecompileHeaderFilePathPublicPrivate "")
list(APPEND ListPrecompileHeaderFilePathPublicPrivate ${v_ListModulePrecompileHeaderFilePath})
set(ListPublicPrivate "")
get_target_property(ListPublicPrivate ${ModuleName} PRECOMPILE_HEADERS)
if(ListPublicPrivate)
	list(APPEND ListPrecompileHeaderFilePathPublicPrivate ${ListPublicPrivate})
endif()
set(ListOptModulePrecompileHeaders "")
foreach(It IN LISTS ListPrecompileHeaderFilePathPublicPrivate)
    list(APPEND ListOptModulePrecompileHeaders "-ph" "${It}")
endforeach()

set(ListCustomTargetDependsFilePath "")
list(APPEND ListCustomTargetDependsFilePath ${v_ListModuleHeaderFilePath})
list(APPEND ListCustomTargetDependsFilePath ${ListPrecompileHeaderFilePathPublicPrivate})

set(ListIncludeDirPathPublicPrivate "")
list(APPEND ListIncludeDirPathPublicPrivate ${v_ListModuleIncludeDirPath})
set(ListPublicPrivate "")
get_target_property(ListPublicPrivate ${ModuleName} INCLUDE_DIRECTORIES)
if(ListPublicPrivate)
	list(APPEND ListIncludeDirPathPublicPrivate ${ListPublicPrivate})
endif()
set(ListOptModuleIncludeDirPath "")
foreach(It IN LISTS ListIncludeDirPathPublicPrivate)
	list(APPEND ListOptModuleIncludeDirPath "-I" "${It}")
endforeach()

if(v_ListAccessorSettingHeaderFilePath)
	set(ListAccessorSettingHeaderFilePath ${v_ListAccessorSettingHeaderFilePath})
else()
	list(APPEND ListAccessorSettingHeaderFilePath ${NiflectIncludeDirPath}/Niflect/Default/StandardAccessorSetting.h)
endif()
set(ListOptAccessorSettingHeaders "")
foreach(It IN LISTS ListAccessorSettingHeaderFilePath)
	list(APPEND ListOptAccessorSettingHeaders "-a" "${It}")
endforeach()

set(ListOptModuleAPIMacro "")
set(ListOptModuleAPIMacroHeader "")
set(OptToGenApiModuleHeader "")
set(ToGenApiModuleHeader ${v_ToGenApiModuleHeader})
if((NOT ToGenApiModuleHeader) AND (NOT DEFINED v_ModuleAPIMacro))
	is_target_shared(${ModuleName} ToGenApiModuleHeader)
endif()
if(ToGenApiModuleHeader)
	if(v_ModuleAPIMacro OR v_ModuleAPIMacroHeaderFilePath)
		message(FATAL_ERROR "v_ModuleAPIMacro and v_ModuleAPIMacroHeaderFilePath can be provided only when ToGenApiModuleHeader is FALSE")
	endif()
	set(OptToGenApiModuleHeader "-gam")
	string(TOUPPER "${ModuleName}" ApiMacroPrefix)
	target_compile_definitions(${ModuleName} PRIVATE -D_${ApiMacroPrefix}_EXPORTS)
else()
	if(v_ModuleAPIMacro)
		if(ToGenApiModuleHeader)
			message(FATAL_ERROR "ToGenApiModuleHeader can be TRUE only when v_ModuleAPIMacro is not provied")
		endif()
		list(APPEND ListOptModuleAPIMacro "-am" "${v_ModuleAPIMacro}")
	endif()

	if(v_ModuleAPIMacroHeaderFilePath)
		list(APPEND ListOptModuleAPIMacroHeader "-amh" "${v_ModuleAPIMacroHeaderFilePath}")
	endif()
endif()

target_include_directories(${ModuleName}
	PRIVATE ${GenSourcePrivate}
	PUBLIC ${GenSourcePublic}
)

set(GeneratedModulePrivateH ${GenOutputDirPath}/FinishedFlag.txt)

set(DebugIntegration OFF)
if(DebugIntegration)
	message(${ModuleName})
	foreach(It IN LISTS ListOptModuleHeaders)
		message(${It})
	endforeach()
	foreach(It IN LISTS ListOptModulePrecompileHeaders)
		message(${It})
	endforeach()
	foreach(It IN LISTS ListOptModuleAPIMacro)
		message(${It})
	endforeach()
	foreach(It IN LISTS ListOptModuleAPIMacroHeader)
		message(${It})
	endforeach()
	foreach(It IN LISTS ListOptAccessorSettingHeaders)
		message(${It})
	endforeach()
	message("${NiflectIncludeDirPath}")
	foreach(It IN LISTS ListOptModuleIncludeDirPath)
		message(${It})
	endforeach()
endif()

#在模块 cmake 中, 如 Wishing\Project\TestEditorCLI\TestEngine\CMakeLists.txt
#定义变量 set(v_EnabledDebuggerAttaching ON) 启用可附加进程的调试模式
#定义变量 set(v_EnabledDebugParsingDiagnostics ON) 启用解析诊断信息, 遇错误则生成失败
set(ListOptToolOption ${v_ListToolOption})
set(ListOptCmdCallingGenTool "")
if(v_EnabledDebuggerAttaching)
	list(APPEND ListOptCmdCallingGenTool cmd.exe /C start)
	list(APPEND ListOptToolOption "-debuggerattaching")
endif()
if(v_EnabledDebugParsingDiagnostics)
	list(APPEND ListOptToolOption "-debugparsingdiagnostics")
endif()
if(WIN32)
else()
	set(GenToolLibDirPath "${v_NiflectGenToolBinDirPath}/../${c_LibDirName}")
	list(APPEND ListOptCmdCallingGenTool ${CMAKE_COMMAND} -E env LD_LIBRARY_PATH=${GenToolLibDirPath}:${CMAKE_LIBRARY_PATH})
endif()

add_custom_command(
    OUTPUT "${GeneratedModulePrivateH}"
    COMMAND ${ListOptCmdCallingGenTool} "${GenToolExeFilePath}" 
		-n ${ModuleName} 
		${ListOptModuleHeaders}
		${ListOptModulePrecompileHeaders}
		${ListOptModuleAPIMacro} 
		${ListOptModuleAPIMacroHeader}
		${OptToGenApiModuleHeader}
		${ListOptAccessorSettingHeaders} 
		${ListOptMacroTagHeaderFilePath}
		-t "${NiflectIncludeDirPath}" 
		${ListOptModuleIncludeDirPath} 
		-g "${GenOutputDirPath}"
		-gat 
		${ListOptToolOption} 
    DEPENDS ${ListCustomTargetDependsFilePath}
    COMMENT "${v_IntegratedToolName} of ${ModuleName}: Starting"
)

set(IntegratedTargetName ${v_IntegratedToolName}_${ModuleName})
add_custom_target(${IntegratedTargetName} DEPENDS "${GeneratedModulePrivateH}")
set_target_properties(${IntegratedTargetName} PROPERTIES FOLDER "AutoGen")
add_dependencies(${ModuleName} ${IntegratedTargetName})
if(v_ListIntegratedToolDependency)
	add_dependencies(${IntegratedTargetName} ${v_ListIntegratedToolDependency})
endif()

#begin, Required
unset(v_IntegratedToolName)
unset(v_NiflectGenToolBinDirPath)
unset(v_ListModuleIncludeDirPath)
#end

#begin, Optional
unset(v_ModuleAPIMacro)
unset(v_ModuleAPIMacroHeaderFilePath)
unset(v_ToGenApiModuleHeader)
unset(v_MacroTagHeaderFilePath)
unset(v_ListModuleHeaderFilePath)
unset(v_ListModulePrecompileHeaderFilePath)
unset(v_ListAccessorSettingHeaderFilePath)
unset(v_NiflectRootPath)
unset(v_ListIntegratedToolDependency)
unset(v_EnabledDebuggerAttaching)
unset(v_EnabledDebugParsingDiagnostics)
unset(v_ListToolOption)
#endif