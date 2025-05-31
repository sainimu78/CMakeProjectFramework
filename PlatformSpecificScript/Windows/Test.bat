@echo off
@set BuildDirPath=%cd%\DefaultBuild
@set OldDirPath=%cd%
@set ExitCode=0

@if defined Toolset (
    set CMakeToolsetArgs=-T %Toolset%
)

@mkdir %BuildDirPath%
@cd %BuildDirPath%
@ctest . --output-on-failure -j 1024 -C Debug
@if %errorlevel% neq 0 (
    @echo "### test failed ###"
	@set ExitCode=1
    pause
) else (
    @ctest . --output-on-failure -j 1024 -C Release
    @if %errorlevel% neq 0 (
        @echo "### test failed ###"
	    @set ExitCode=1
        pause
    )
)
@cd %OldDirPath%
@exit /b %ExitCode%