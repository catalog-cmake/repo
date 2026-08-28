function(_recipe_fmt_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(fmt ${CL_REQ_VERSION} QUIET)
    else()
      find_package(fmt QUIET)
    endif()
  endif()

  if(NOT TARGET fmt AND NOT TARGET fmt::fmt)
    cl_format_pkgconfig_req("fmt" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      if(CL_STATIC)
        pkg_check_modules(fmt IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
      else()
        pkg_check_modules(fmt IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_fmt_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libfmt-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "fmt" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "fmt" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "fmt-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_fmt_source)
  set(FMT_TAG "12.2.0")
  if(CL_REQ_VERSION)
    set(FMT_TAG "${CL_REQ_VERSION}")
  endif()

  set(FMT_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(FMT_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME fmt
    URL https://github.com/fmtlib/fmt/archive/refs/tags/${FMT_TAG}.tar.gz
    OPTIONS "BUILD_SHARED_LIBS" "${FMT_BUILD_SHARED}" "FMT_TEST" "OFF" "FMT_DOC" "OFF"
  )
endfunction()
