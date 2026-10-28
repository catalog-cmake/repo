function(_recipe_xbyak_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(xbyak ${CL_REQ_VERSION} CONFIG QUIET)
    else()
      find_package(xbyak CONFIG QUIET)
    endif()
  endif()

  if(NOT TARGET xbyak::xbyak)
    cl_format_pkgconfig_req("xbyak" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(xbyak IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_xbyak_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libxbyak-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "xbyak" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_xbyak_source)
  set(XBYAK_TAG "v7.44")
  if(CL_REQ_VERSION)
    set(XBYAK_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME xbyak
    URL https://github.com/herumi/xbyak/archive/refs/tags/${XBYAK_TAG}.tar.gz
    OPTIONS "XBYAK_TEST" "OFF"
  )
endfunction()
