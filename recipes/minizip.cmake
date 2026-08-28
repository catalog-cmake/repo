function(_recipe_minizip_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(minizip-ng ${CL_REQ_VERSION} QUIET)
    else()
      find_package(minizip-ng QUIET)
    endif()

    if(TARGET MINIZIP::minizip)
      get_target_property(_MINIZIP_ALIASED MINIZIP::minizip ALIASED_TARGET)
      if(_MINIZIP_ALIASED)
        add_library(deps::minizip ALIAS ${_MINIZIP_ALIASED})
      else()
        add_library(deps::minizip ALIAS MINIZIP::minizip)
      endif()
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("minizip" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(minizip IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_minizip_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libminizip-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "minizip" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "minizip" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_minizip_source)
  set(MINIZIP_TAG "4.2.2")
  if(CL_REQ_VERSION)
    set(MINIZIP_TAG "${CL_REQ_VERSION}")
  endif()

  set(MINIZIP_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(MINIZIP_BUILD_SHARED OFF)
  endif()

  cl_import_source(
    NAME minizip
    URL https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${MINIZIP_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${MINIZIP_BUILD_SHARED}"
      "MZ_BZIP2" "OFF"
      "MZ_LZMA" "OFF"
      "MZ_ZSTD" "OFF"
      "MZ_PPMD" "OFF"
      "MZ_PKCRYPT" "OFF"
      "MZ_WZAES" "OFF"
      "MZ_OPENSSL" "OFF"
      "MZ_ICU" "OFF"
      "MZ_FETCH_LIBS" "OFF"
      "MZ_BUILD_TESTS" "OFF"
  )

  if(TARGET MINIZIP::minizip)
    get_target_property(_MINIZIP_ALIASED MINIZIP::minizip ALIASED_TARGET)
    if(_MINIZIP_ALIASED)
      add_library(deps::minizip ALIAS ${_MINIZIP_ALIASED})
    else()
      add_library(deps::minizip ALIAS MINIZIP::minizip)
    endif()
  endif()
endfunction()
