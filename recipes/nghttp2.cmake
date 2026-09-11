function(_recipe_nghttp2_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(nghttp2 ${CL_REQ_VERSION} QUIET)
    else()
      find_package(nghttp2 QUIET)
    endif()

    if(TARGET nghttp2::nghttp2)
      add_library(deps::nghttp2 ALIAS nghttp2::nghttp2)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libnghttp2" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(nghttp2 IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(nghttp2 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_nghttp2_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libnghttp2-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libnghttp2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "nghttp2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libnghttp2-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "nghttp2-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_nghttp2_source)
  set(NGHTTP2_TAG "v1.70.0")
  if(CL_REQ_VERSION)
    set(NGHTTP2_TAG "v${CL_REQ_VERSION}")
  endif()

  # Forced OFF regardless of the ambient BUILD_SHARED_LIBS value: with it ON,
  # nghttp2's own CMakeLists ends up doing add_library(nghttp2 ALIAS nghttp2)
  # (its shared target is itself already named "nghttp2"), which errors.
  set(_NGHTTP2_PREV_SHARED "${BUILD_SHARED_LIBS}")
  set(_NGHTTP2_PREV_STATIC "${BUILD_STATIC_LIBS}")
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
  set(BUILD_STATIC_LIBS ON CACHE BOOL "" FORCE)

  cl_import_source(
    NAME nghttp2
    URL https://github.com/nghttp2/nghttp2/archive/refs/tags/${NGHTTP2_TAG}.tar.gz
    OPTIONS
      "ENABLE_LIB_ONLY" "ON"
  )

  set(BUILD_SHARED_LIBS "${_NGHTTP2_PREV_SHARED}" CACHE BOOL "" FORCE)
  set(BUILD_STATIC_LIBS "${_NGHTTP2_PREV_STATIC}" CACHE BOOL "" FORCE)

  if(TARGET nghttp2)
    get_target_property(_NGHTTP2_ALIASED nghttp2 ALIASED_TARGET)
    if(_NGHTTP2_ALIASED)
      add_library(deps::nghttp2 ALIAS ${_NGHTTP2_ALIASED})
    else()
      add_library(deps::nghttp2 ALIAS nghttp2)
    endif()
  elseif(TARGET nghttp2_static)
    add_library(deps::nghttp2 ALIAS nghttp2_static)
  endif()
endfunction()
