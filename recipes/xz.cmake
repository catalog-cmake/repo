function(_recipe_xz_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(LibLZMA ${CL_REQ_VERSION} QUIET)
    else()
      find_package(LibLZMA QUIET)
    endif()
    if(TARGET LibLZMA::LibLZMA)
      add_library(deps::xz ALIAS LibLZMA::LibLZMA)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("liblzma" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(xz IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(xz IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_xz_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "liblzma-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "xz" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "xz" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "xz-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "xz-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_xz_source)
  set(XZ_TAG "v5.8.3")
  if(CL_REQ_VERSION)
    set(XZ_TAG "v${CL_REQ_VERSION}")
  endif()

  set(XZ_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(XZ_BUILD_SHARED OFF)
  endif()

  cl_import_source(
    NAME xz
    URL https://github.com/tukaani-project/xz/archive/refs/tags/${XZ_TAG}.tar.gz
    OPTIONS "BUILD_SHARED_LIBS" "${XZ_BUILD_SHARED}" "BUILD_TESTING" "OFF"
  )

  if(TARGET liblzma)
    add_library(deps::xz ALIAS liblzma)
  endif()
endfunction()
