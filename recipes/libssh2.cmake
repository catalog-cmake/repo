function(_recipe_libssh2_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(Libssh2 ${CL_REQ_VERSION} QUIET)
    else()
      find_package(Libssh2 QUIET)
    endif()

    if(TARGET libssh2::libssh2)
      add_library(deps::libssh2 ALIAS libssh2::libssh2)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libssh2" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libssh2 IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libssh2 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libssh2_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libssh2-1-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libssh2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "libssh2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libssh2-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "libssh2-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libssh2_source)
  set(LIBSSH2_TAG "libssh2-1.11.1")
  if(CL_REQ_VERSION)
    set(LIBSSH2_TAG "libssh2-${CL_REQ_VERSION}")
  endif()

  set(LIBSSH2_BUILD_SHARED ON)
  set(LIBSSH2_BUILD_STATIC ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(LIBSSH2_BUILD_SHARED OFF)
  elseif(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(LIBSSH2_BUILD_STATIC OFF)
  endif()

  cl_repo_file(patches/libssh2.patch LIBSSH2_PATCH)

  cl_import_source(
    NAME libssh2
    URL https://github.com/libssh2/libssh2/archive/refs/tags/${LIBSSH2_TAG}.tar.gz
    PATCHES "${LIBSSH2_PATCH}"
    OPTIONS
      "CRYPTO_BACKEND" "OpenSSL"
      "BUILD_SHARED_LIBS" "${LIBSSH2_BUILD_SHARED}"
      "BUILD_STATIC_LIBS" "${LIBSSH2_BUILD_STATIC}"
      "BUILD_EXAMPLES" "OFF"
      "BUILD_TESTING" "OFF"
  )

  if(TARGET libssh2::libssh2)
    add_library(deps::libssh2 ALIAS libssh2::libssh2)
  elseif(TARGET libssh2)
    add_library(deps::libssh2 ALIAS libssh2)
  endif()
endfunction()
