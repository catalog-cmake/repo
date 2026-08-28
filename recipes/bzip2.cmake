function(_recipe_bzip2_system)
  cl_format_pkgconfig_req("bzip2" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(bzip2 IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(bzip2 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
    if(TARGET PkgConfig::bzip2)
      return()
    endif()
  endif()

  if(NOT CMAKE_CROSSCOMPILING)
    find_library(BZIP2_LIBRARY NAMES bz2)
    find_path(BZIP2_INCLUDE_DIR NAMES bzlib.h)
    if(BZIP2_LIBRARY AND BZIP2_INCLUDE_DIR)
      add_library(_bzip2_system UNKNOWN IMPORTED)
      set_target_properties(_bzip2_system PROPERTIES
        IMPORTED_LOCATION "${BZIP2_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${BZIP2_INCLUDE_DIR}"
      )
      add_library(deps::bzip2 ALIAS _bzip2_system)
    endif()
  endif()
endfunction()

function(_recipe_bzip2_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libbz2-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "bzip2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "bzip2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "bzip2-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "bzip2-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_bzip2_source)
  set(BZIP2_TAG "bzip2-1.0.8")
  if(CL_REQ_VERSION)
    set(BZIP2_TAG "bzip2-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME bzip2
    DOWNLOAD_ONLY
    URL https://github.com/libarchive/bzip2/archive/refs/tags/${BZIP2_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/bzlib.c")
    _catalog_log(FATAL_ERROR "bzip2: expected sources not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(bzip2
    "${CL_SOURCE_DIR}/blocksort.c"
    "${CL_SOURCE_DIR}/bzlib.c"
    "${CL_SOURCE_DIR}/compress.c"
    "${CL_SOURCE_DIR}/crctable.c"
    "${CL_SOURCE_DIR}/decompress.c"
    "${CL_SOURCE_DIR}/huffman.c"
    "${CL_SOURCE_DIR}/randtable.c"
  )
  target_include_directories(bzip2 PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
  target_compile_definitions(bzip2 PRIVATE _FILE_OFFSET_BITS=64)
endfunction()
