# CMakeProjectFramework

A cmake project framework based on HFS local storage

## Workflow

1. Add this Git repository as a submodule to the `ThirdParty/CMakeProjectFramework` directory in the root directory of the main Git repository
   - Refer to `git@github.com:sainimu78/Wishing.git`, `Wishing\Doc\b备用资料\git_submodule_接入\README.md`
2. Implement the cmake scripts of the project
   - Refer to `git@github.com:sainimu78/Niflect.git`, `Niflect\Project\Niflect\CMakeLists.txt`
3. Generate, Build, Install, Release by using the platform specific scripts in `PlatformSpecificScript`
   - Refer to `git@github.com:sainimu78/Niflect.git`, `Niflect\Build\Niflect\Windows\Build.bat`

### Local Storage Setup

1. Place dependencies in a local directory path, such as `F:\sainimu78_Storage`
2. Open the HFS application downloaded it from https://www.rejetto.com/hfs/
   - The old version .e.g. `Build 299` is easier to use
### Cloud Storage Setup

The storage must has the ability of permanently direct downloading via http link

1. Upload dependencies to a cloud storage
2. Copy the download http links and paste to cmake scripts of the dependencies

## Development Usage

Once having implemented the the cmake scripts of the project, the simplest development usage is going to be running these platform specific scripts

- Generate
  - To generate the cmake project when the first time setup, or made some changes need to delete CMakeCache.txt like the changes of cmake options
  - About the first time setup, it is almost the same workflow as running Setup script
  - If an documenting option enabled, this process will also regenerate the ReleaseNotes.md including the version info and the release description
- Build
  - To build the cmake project
- Install
  - To install the built targets into the installation directory
- Release
  - To release the installation to the local storage
- Update
  - To update the cmake project when added or deleted files or made any other changes no need to delete CMakeCache.txt
- Setup
  - To re-deploy all the dependencies of the project
    - The deployment including the shared libraries (.so/.dll) installation
  - To re-deploy for only one dependency by mannully deleting the corresponding deployed directory
- Test
  - To test the built targets
- Clean
  - To clean up the built targets

### Example

Go to the target platform directory

```
cd Build\HelloWorld\Windows
```

Generate a cmake project for the first time

```
Generate.bat
```

Update a project when added / deleted / renamed files

```
Update.bat
```

Release the built targets

```
Install.bat
Release.bat
```

## Naming Convention

A CMake Variable that

- Starts with `c_`: Global constant

  - e.g., `set(c_ProjectDirPath ${CMAKE_CURRENT_SOURCE_DIR})`

- Starts with `v_`: Local variable specified by user before an invocation of `include`-inlining-style function

  - e.g., 

    ```cmake
    set(v_ImportedLibName libclang)
    ...
    include(${c_RootCMakeProjectFrameworkDirPath}/ImportLibDownloaded.cmake)
    ```

    