function(_recipe_c-ares_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(c-ares ${CL_REQ_VERSION} QUIET)
    else()
      find_package(c-ares QUIET)
    endif()

    if(TARGET c-ares::cares)
      add_library(deps::c-ares ALIAS c-ares::cares)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libcares" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(c-ares IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(c-ares IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_c-ares_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libc-ares-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "c-ares" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "c-ares" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "c-ares-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "c-ares-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_c-ares_source)
  set(CARES_TAG "v1.34.8")
  if(CL_REQ_VERSION)
    set(CARES_TAG "v${CL_REQ_VERSION}")
  endif()

  set(CARES_BUILD_SHARED ON)
  set(CARES_BUILD_STATIC OFF)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(CARES_BUILD_SHARED OFF)
    set(CARES_BUILD_STATIC ON)
  endif()

  cl_import_source(
    NAME c-ares
    URL https://github.com/c-ares/c-ares/archive/refs/tags/${CARES_TAG}.tar.gz
    OPTIONS
      "CARES_SHARED" "${CARES_BUILD_SHARED}"
      "CARES_STATIC" "${CARES_BUILD_STATIC}"
      "CARES_BUILD_TOOLS" "OFF"
      "CARES_BUILD_TESTS" "OFF"
  )

  if(TARGET c-ares::cares)
    add_library(deps::c-ares ALIAS c-ares::cares)
  endif()
endfunction()
