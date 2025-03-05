@echo off
@set BuildDirPath=%cd%\DefaultBuild
@set OldDirPath=%cd%

@if defined Toolset (
    set CMakeToolsetArgs=-T %Toolset%
)

@mkdir %BuildDirPath%
@cd %BuildDirPath%
@ctest . --output-on-failure -j 1024 -C Debug
@if %errorlevel% neq 0 (
    echo "### test failed ###"
    pause
) else (
    @ctest . --output-on-failure -j 1024 -C Release
    @if %errorlevel% neq 0 (
        echo "### test failed ###"
        pause
    )
)
@cd %OldDirPath%