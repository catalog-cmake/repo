function(_recipe_wslay_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(wslay ${CL_REQ_VERSION} QUIET)
    else()
      find_package(wslay QUIET)
    endif()

    if(TARGET wslay)
      add_library(deps::wslay ALIAS wslay)
      return()
    elseif(TARGET wslay_shared)
      add_library(deps::wslay ALIAS wslay_shared)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libwslay" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(wslay IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(wslay IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_wslay_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libwslay-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "wslay" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "wslay" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libwslay-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "wslay-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_wslay_source)
  set(WSLAY_TAG "release-1.1.1")
  if(CL_REQ_VERSION)
    set(WSLAY_TAG "release-${CL_REQ_VERSION}")
  endif()

  set(WSLAY_BUILD_SHARED ON)
  set(WSLAY_BUILD_STATIC ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(WSLAY_BUILD_SHARED OFF)
  elseif(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(WSLAY_BUILD_STATIC OFF)
  endif()

  cl_repo_file(patches/wslay.patch WSLAY_PATCH)

  cl_import_source(
    NAME wslay
    URL https://github.com/tatsuhiro-t/wslay/archive/refs/tags/${WSLAY_TAG}.tar.gz
    PATCHES "${WSLAY_PATCH}"
    OPTIONS
      "WSLAY_STATIC" "${WSLAY_BUILD_STATIC}"
      "WSLAY_SHARED" "${WSLAY_BUILD_SHARED}"
      "WSLAY_EXAMPLES" "OFF"
      "WSLAY_TESTS" "OFF"
  )

  if(TARGET wslay)
    add_library(deps::wslay ALIAS wslay)
  elseif(TARGET wslay_shared)
    add_library(deps::wslay ALIAS wslay_shared)
  endif()
endfunction()
