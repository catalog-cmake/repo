function(_recipe_raylib_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(raylib ${CL_REQ_VERSION} QUIET)
    else()
      find_package(raylib QUIET)
    endif()

    if(TARGET raylib)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("raylib" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(raylib IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(raylib IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_raylib_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "raylib-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "raylib" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "raylib" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "raylib-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_raylib_source)
  set(RAYLIB_TAG "6.0")
  if(CL_REQ_VERSION)
    set(RAYLIB_TAG "${CL_REQ_VERSION}")
  endif()

  set(RAYLIB_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(RAYLIB_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME raylib
    URL https://github.com/raysan5/raylib/archive/refs/tags/${RAYLIB_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${RAYLIB_BUILD_SHARED}"
      "WITH_PIC" "ON"
      "BUILD_EXAMPLES" "OFF"
  )
endfunction()
