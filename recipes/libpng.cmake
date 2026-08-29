function(_recipe_libpng_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(PNG ${CL_REQ_VERSION} QUIET)
    else()
      find_package(PNG QUIET)
    endif()
    if(TARGET PNG::PNG)
      add_library(deps::libpng ALIAS PNG::PNG)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libpng" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libpng IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libpng IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libpng_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libpng-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libpng" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "libpng" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libpng-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "libpng-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libpng16-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libpng_source)
  cl_add_dep(zlib)

  set(LIBPNG_TAG "v1.6.50")
  if(CL_REQ_VERSION)
    set(LIBPNG_TAG "v${CL_REQ_VERSION}")
  endif()

  set(PNG_BUILD_SHARED ON)
  set(PNG_BUILD_STATIC ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(PNG_BUILD_SHARED OFF)
  elseif(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(PNG_BUILD_STATIC OFF)
  endif()

  cl_repo_file(patches/libpng.patch LIBPNG_PATCH)

  cl_import_source(
    NAME libpng
    URL https://github.com/pnggroup/libpng/archive/refs/tags/${LIBPNG_TAG}.tar.gz
    OPTIONS
      "PNG_SHARED" "${PNG_BUILD_SHARED}"
      "PNG_STATIC" "${PNG_BUILD_STATIC}"
      "PNG_TESTS" "OFF"
      "PNG_TOOLS" "OFF"
    PATCHES "${LIBPNG_PATCH}"
  )

  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    if(TARGET png_static)
      add_library(deps::libpng ALIAS png_static)
    endif()
  elseif(TARGET png_shared)
    add_library(deps::libpng ALIAS png_shared)
  elseif(TARGET png_static)
    add_library(deps::libpng ALIAS png_static)
  endif()
endfunction()
