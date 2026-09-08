function(_recipe_libogg_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(Ogg ${CL_REQ_VERSION} QUIET)
    else()
      find_package(Ogg QUIET)
    endif()

    if(TARGET Ogg::ogg)
      add_library(deps::libogg ALIAS Ogg::ogg)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("ogg" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libogg IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libogg IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libogg_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libogg-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libogg" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "libogg" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libogg-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "libogg-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libogg-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libogg_source)
  set(LIBOGG_TAG "v1.3.6")
  if(CL_REQ_VERSION)
    set(LIBOGG_TAG "v${CL_REQ_VERSION}")
  endif()

  set(LIBOGG_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(LIBOGG_BUILD_SHARED OFF)
  endif()

  cl_import_source(
    NAME libogg
    URL https://github.com/xiph/ogg/archive/refs/tags/${LIBOGG_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${LIBOGG_BUILD_SHARED}"
      "BUILD_TESTING" "OFF"
      "INSTALL_DOCS" "OFF"
  )

  if(TARGET Ogg::ogg)
    add_library(deps::libogg ALIAS Ogg::ogg)
  elseif(TARGET ogg)
    add_library(deps::libogg ALIAS ogg)
  endif()
endfunction()
