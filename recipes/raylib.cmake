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
  cl_add_dep(miniaudio)

  set(RAYLIB_TAG "6.0")
  if(CL_REQ_VERSION)
    set(RAYLIB_TAG "${CL_REQ_VERSION}")
  endif()

  set(RAYLIB_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(RAYLIB_BUILD_SHARED ON)
  endif()

  cl_repo_file(patches/raylib.patch RAYLIB_PATCH)

  cl_import_source(
    NAME raylib
    URL https://github.com/raysan5/raylib/archive/refs/tags/${RAYLIB_TAG}.tar.gz
    PATCHES "${RAYLIB_PATCH}"
    OPTIONS
      "BUILD_SHARED_LIBS" "${RAYLIB_BUILD_SHARED}"
      "WITH_PIC" "ON"
      "BUILD_EXAMPLES" "OFF"
  )

  if(TARGET raylib AND TARGET deps::miniaudio)
    # Not target_link_libraries(raylib PRIVATE deps::miniaudio) - raylib's
    # own install(EXPORT raylib-targets ...) requires every linked target to
    # be in that export set, and miniaudio isn't. It's header-only anyway,
    # so just copy over the include path and the plain system link libs.
    get_target_property(_MINIAUDIO_INCLUDES deps::miniaudio INTERFACE_INCLUDE_DIRECTORIES)
    if(_MINIAUDIO_INCLUDES)
      target_include_directories(raylib PRIVATE ${_MINIAUDIO_INCLUDES})
    endif()
    get_target_property(_MINIAUDIO_LIBS deps::miniaudio INTERFACE_LINK_LIBRARIES)
    if(_MINIAUDIO_LIBS)
      target_link_libraries(raylib PRIVATE ${_MINIAUDIO_LIBS})
    endif()
  endif()
endfunction()
