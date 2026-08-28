function(_recipe_brotli_system)
  cl_format_pkgconfig_req("libbrotlidec" "${CL_VERSION_REQ}" PKG_SPEC_DEC)
  cl_format_pkgconfig_req("libbrotlienc" "${CL_VERSION_REQ}" PKG_SPEC_ENC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(brotlidec IMPORTED_TARGET GLOBAL ${PKG_SPEC_DEC})
    pkg_check_modules(brotlienc IMPORTED_TARGET GLOBAL ${PKG_SPEC_ENC})
    if(TARGET PkgConfig::brotlidec AND TARGET PkgConfig::brotlienc)
      add_library(_brotli_system INTERFACE)
      target_link_libraries(_brotli_system INTERFACE PkgConfig::brotlidec PkgConfig::brotlienc)
      add_library(deps::brotli ALIAS _brotli_system)
    endif()
  endif()
endfunction()

function(_recipe_brotli_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libbrotli-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "brotli" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "brotli" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "brotli-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "brotli-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_brotli_source)
  set(BROTLI_TAG "v1.1.0")
  if(CL_REQ_VERSION)
    set(BROTLI_TAG "v${CL_REQ_VERSION}")
  endif()

  set(BROTLI_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(BROTLI_BUILD_SHARED OFF)
  endif()

  set(_BROTLI_PREV_SHARED "${BUILD_SHARED_LIBS}")
  set(BUILD_SHARED_LIBS ${BROTLI_BUILD_SHARED} CACHE BOOL "" FORCE)

  cl_import_source(
    NAME brotli
    URL https://github.com/google/brotli/archive/refs/tags/${BROTLI_TAG}.tar.gz
  )

  set(BUILD_SHARED_LIBS "${_BROTLI_PREV_SHARED}" CACHE BOOL "" FORCE)

  if(TARGET brotlicommon AND TARGET brotlidec AND TARGET brotlienc)
    add_library(_brotli_source INTERFACE)
    target_link_libraries(_brotli_source INTERFACE brotlicommon brotlidec brotlienc)
    add_library(deps::brotli ALIAS _brotli_source)
  endif()
endfunction()
