function(_recipe_libflac_system)
  if(NOT CMAKE_CROSSCOMPILING)
    # FLAC's own CMake config links Threads::Threads unconditionally.
    find_package(Threads QUIET)

    if(CL_REQ_VERSION)
      find_package(FLAC ${CL_REQ_VERSION} QUIET)
    else()
      find_package(FLAC QUIET)
    endif()

    if(TARGET FLAC::FLAC)
      add_library(deps::libflac ALIAS FLAC::FLAC)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("flac" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libflac IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libflac IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libflac_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libflac-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "flac" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "flac" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "flac-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "flac-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "flac-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libflac_source)
  cl_add_dep(libogg)

  set(LIBFLAC_TAG "1.5.0")
  if(CL_REQ_VERSION)
    set(LIBFLAC_TAG "${CL_REQ_VERSION}")
  endif()

  set(LIBFLAC_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(LIBFLAC_BUILD_SHARED OFF)
  endif()

  cl_import_source(
    NAME libflac
    URL https://github.com/xiph/flac/archive/refs/tags/${LIBFLAC_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${LIBFLAC_BUILD_SHARED}"
      "BUILD_CXXLIBS" "OFF"
      "BUILD_PROGRAMS" "OFF"
      "BUILD_EXAMPLES" "OFF"
      "BUILD_TESTING" "OFF"
      "BUILD_DOCS" "OFF"
      "INSTALL_MANPAGES" "OFF"
      "WITH_OGG" "ON"
  )

  if(TARGET FLAC::FLAC)
    add_library(deps::libflac ALIAS FLAC::FLAC)
  elseif(TARGET FLAC)
    add_library(deps::libflac ALIAS FLAC)
  endif()
endfunction()
