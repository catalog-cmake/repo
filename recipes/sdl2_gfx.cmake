function(_recipe_SDL2_gfx_system)
  cl_format_pkgconfig_req("SDL2_gfx" "${CL_VERSION_REQ}" PKG_SPEC)

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(SDL2_gfx IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(SDL2_gfx IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_SDL2_gfx_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsdl2-gfx-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "sdl2_gfx" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SDL2_gfx_source)
  cl_add_dep(SDL2)
  if(NOT TARGET deps::SDL2)
    _catalog_log(FATAL_ERROR "SDL2_gfx: could not resolve an SDL2 dependency")
  endif()

  set(SDL2GFX_VER "1.0.4")
  if(CL_REQ_VERSION)
    set(SDL2GFX_VER "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME SDL2_gfx
    DOWNLOAD_ONLY
    URL https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-${SDL2GFX_VER}.zip
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/SDL2_gfxPrimitives.c")
    _catalog_log(FATAL_ERROR "SDL2_gfx: expected sources not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(SDL2_gfx
    "${CL_SOURCE_DIR}/SDL2_framerate.c"
    "${CL_SOURCE_DIR}/SDL2_gfxPrimitives.c"
    "${CL_SOURCE_DIR}/SDL2_imageFilter.c"
    "${CL_SOURCE_DIR}/SDL2_rotozoom.c"
  )
  target_include_directories(SDL2_gfx PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
  target_link_libraries(SDL2_gfx PUBLIC deps::SDL2)
endfunction()
