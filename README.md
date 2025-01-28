# CMakeProjectFramework

A cmake project framework based on HFS local storage

## Basic Workflow

- Place the dependency and related files in the directory path, such as `F:\sainimu78_Storage`
- Open the HFS application downloaded it from https://www.rejetto.com/hfs/
  - The old version .e.g. `Build 299` is easier to use
- Add this Git repository as a submodule to the `ThirdParty/CMakeProjectFramework` directory in the root directory of the main Git repository
  - Refer to `git@github.com:sainimu78/Wishing.git`, `Wishing\Doc\b备用资料\git_submodule_接入\README.md`
- Implement the cmake project
  - Refer to `git@github.com:sainimu78/Niflect.git`, `Niflect\Project\Niflect\CMakeLists.txt`
- Generate, Build, Install, Release by using the platform specific scripts in `PlatformSpecificScript`
  - Refer to `git@github.com:sainimu78/Niflect.git`, `Niflect\Build\Niflect\Windows\Build.bat`

