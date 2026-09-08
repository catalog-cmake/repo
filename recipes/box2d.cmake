function(_recipe_box2d_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(box2d ${CL_REQ_VERSION} QUIET)
    else()
      find_package(box2d QUIET)
    endif()

    if(TARGET box2d::box2d)
      add_library(deps::box2d ALIAS box2d::box2d)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("box2d" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(box2d IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(box2d IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_box2d_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libbox2d-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "box2d" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "box2d" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "box2d-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_box2d_source)
  set(BOX2D_TAG "v3.1.1")
  if(CL_REQ_VERSION)
    set(BOX2D_TAG "v${CL_REQ_VERSION}")
  endif()

  set(BOX2D_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(BOX2D_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME box2d
    URL https://github.com/erincatto/box2d/archive/refs/tags/${BOX2D_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${BOX2D_BUILD_SHARED}"
  )

  if(TARGET box2d AND NOT TARGET box2d::box2d)
    add_library(box2d::box2d ALIAS box2d)
  endif()

  if(TARGET box2d AND UNIX AND NOT APPLE)
    target_link_libraries(box2d PRIVATE m)
  endif()
endfunction()
