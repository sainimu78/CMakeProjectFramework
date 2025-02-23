@echo off
@set BuildDirPath=%cd%\TestBuild
@set OldDirPath=%cd%

@if defined Toolset (
    set CMakeToolsetArgs=-T %Toolset%
)

@mkdir %BuildDirPath%
@cd %BuildDirPath%
@cmake %TestDirPath% %CMakeToolsetArgs%
@set BuildOk=0
@if %ERRORLEVEL% neq 0 (
    echo "### cmake generating failed ###"
    pause
) else (
    @cmake --build . --config Debug
    @if %errorlevel% neq 0 (
        echo "### ctest failed ###"
        pause
    ) else (
        @cmake --build . --config Release
        @if %errorlevel% neq 0 (
            echo "### ctest failed ###"
            pause
        ) else (
            @set BuildOk=1
        )
    )
)

@if %BuildOk% neq 0 (
    @ctest . --output-on-failure -j 1024 -C Debug
    @if %errorlevel% neq 0 (
        echo "### ctest failed ###"
        pause
    ) else (
        @ctest . --output-on-failure -j 1024 -C Release
        @if %errorlevel% neq 0 (
            echo "### ctest failed ###"
            pause
        )
    )
)
@cd %OldDirPath%