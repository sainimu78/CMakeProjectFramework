@echo off
@set BuildDirPath=%cd%\DefaultBuild
@set OldDirPath=%cd%
@set ExitCode=0

@cd %BuildDirPath%
::@cmake --build . -j 1024 --config Debug
::@if %ERRORLEVEL% neq 0 (
::	@echo "### cmake generating failed ###"
::	@set ExitCode=1
::	pause
::) else (
	@cmake --build . -j 1024 --config Release
	@if %ERRORLEVEL% neq 0 (
		@echo "### cmake generating failed ###"
		@set ExitCode=1
		pause
	)
::)
@cd %OldDirPath%
@exit /b %ExitCode%