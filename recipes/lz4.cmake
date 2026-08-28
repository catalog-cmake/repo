function(_recipe_lz4_system)
  cl_format_pkgconfig_req("liblz4" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(lz4 IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(lz4 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_lz4_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "liblz4-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "lz4" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "lz4" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "lz4-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "lz4-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_lz4_source)
  set(LZ4_TAG "v1.10.0")
  if(CL_REQ_VERSION)
    set(LZ4_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME lz4
    DOWNLOAD_ONLY
    URL https://github.com/lz4/lz4/archive/refs/tags/${LZ4_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/build/cmake/CMakeLists.txt")
    _catalog_log(FATAL_ERROR "lz4: expected build/cmake/CMakeLists.txt not found under ${CL_SOURCE_DIR}")
  endif()

  set(LZ4_BUILD_SHARED ON)
  set(LZ4_BUILD_STATIC OFF)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(LZ4_BUILD_SHARED OFF)
    set(LZ4_BUILD_STATIC ON)
  elseif(NOT CL_REQ_TYPE STREQUAL "SHARED" AND NOT CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(LZ4_BUILD_STATIC ON)
  endif()

  set(LZ4_BUILD_CLI OFF CACHE BOOL "" FORCE)
  set(_LZ4_PREV_SHARED "${BUILD_SHARED_LIBS}")
  set(_LZ4_PREV_STATIC "${BUILD_STATIC_LIBS}")
  set(BUILD_SHARED_LIBS ${LZ4_BUILD_SHARED} CACHE BOOL "" FORCE)
  set(BUILD_STATIC_LIBS ${LZ4_BUILD_STATIC} CACHE BOOL "" FORCE)
  add_subdirectory("${CL_SOURCE_DIR}/build/cmake" "${CL_SOURCE_DIR}-build")
  set(BUILD_SHARED_LIBS "${_LZ4_PREV_SHARED}" CACHE BOOL "" FORCE)
  set(BUILD_STATIC_LIBS "${_LZ4_PREV_STATIC}" CACHE BOOL "" FORCE)
endfunction()
