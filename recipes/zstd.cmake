function(_recipe_zstd_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(zstd ${CL_REQ_VERSION} QUIET)
    else()
      find_package(zstd QUIET)
    endif()
  endif()

  cl_format_pkgconfig_req("libzstd" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(zstd IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(zstd IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_zstd_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libzstd-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "zstd" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "zstd" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libzstd-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "zstd-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_zstd_source)
  set(ZSTD_TAG "v1.5.7")
  if(CL_REQ_VERSION)
    set(ZSTD_TAG "v${CL_REQ_VERSION}")
  endif()

  set(ZSTD_BUILD_SHARED ON)
  set(ZSTD_BUILD_STATIC ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(ZSTD_BUILD_SHARED OFF)
  elseif(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(ZSTD_BUILD_STATIC OFF)
  endif()

  cl_import_source(
    NAME zstd
    URL https://github.com/facebook/zstd/archive/refs/tags/${ZSTD_TAG}.tar.gz
    OPTIONS
      "ZSTD_BUILD_SHARED" "${ZSTD_BUILD_SHARED}"
      "ZSTD_BUILD_STATIC" "${ZSTD_BUILD_STATIC}"
      "ZSTD_BUILD_PROGRAMS" "OFF"
      "ZSTD_BUILD_TESTS" "OFF"
      "ZSTD_BUILD_CONTRIB" "OFF"
  )

  if(CL_STATIC AND TARGET libzstd_static)
    add_library(deps::zstd ALIAS libzstd_static)
  elseif(TARGET libzstd_shared)
    add_library(deps::zstd ALIAS libzstd_shared)
  elseif(TARGET libzstd_static)
    add_library(deps::zstd ALIAS libzstd_static)
  elseif(TARGET libzstd)
    add_library(deps::zstd ALIAS libzstd)
  endif()
endfunction()
