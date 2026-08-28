function(_recipe_CLI11_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(CLI11 ${CL_REQ_VERSION} QUIET)
    else()
      find_package(CLI11 QUIET)
    endif()
  endif()
endfunction()

function(_recipe_CLI11_package)
  if(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "cli11" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "cli11" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_CLI11_source)
  set(CLI11_TAG "v2.7.2")
  if(CL_REQ_VERSION)
    set(CLI11_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME CLI11
    URL https://github.com/CLIUtils/CLI11/archive/refs/tags/${CLI11_TAG}.tar.gz
    OPTIONS "CLI11_BUILD_TESTS" "OFF" "CLI11_BUILD_EXAMPLES" "OFF" "CLI11_BUILD_DOCS" "OFF"
  )
endfunction()
