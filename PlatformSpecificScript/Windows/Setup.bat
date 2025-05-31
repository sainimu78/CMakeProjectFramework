@echo off
@set BuildDirPath=%cd%\DefaultBuild
@set InstallPrefix=Installed
@set OldDirPath=%cd%
@set ExitCode=0

@if defined Toolset (
    set CMakeToolsetArgs=-T %Toolset%
)

@mkdir %BuildDirPath%
@cd %BuildDirPath%
@cmake %ProjectDirPath% -DCMAKE_INSTALL_PREFIX=%InstallPrefix% -DPROJECT_PIPELINE=Setup %CMakeToolsetArgs%
@if %ERRORLEVEL% neq 0 (
    @echo "### cmake generating failed ###"
	@set ExitCode=1
    pause
)
@cd %OldDirPath%
@exit /b %ExitCode%