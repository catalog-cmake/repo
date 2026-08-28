function(_recipe_cxxopts_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(cxxopts ${CL_REQ_VERSION} QUIET)
    else()
      find_package(cxxopts QUIET)
    endif()
  endif()
endfunction()

function(_recipe_cxxopts_package)
  if(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "cxxopts" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "cxxopts" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_cxxopts_source)
  set(CXXOPTS_TAG "v3.3.1")
  if(CL_REQ_VERSION)
    set(CXXOPTS_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME cxxopts
    URL https://github.com/jarro2783/cxxopts/archive/refs/tags/${CXXOPTS_TAG}.tar.gz
    OPTIONS "CXXOPTS_BUILD_EXAMPLES" "OFF" "CXXOPTS_BUILD_TESTS" "OFF"
  )
endfunction()
