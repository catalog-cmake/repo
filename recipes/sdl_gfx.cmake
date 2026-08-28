function(_recipe_SDL_gfx_system)
  cl_format_pkgconfig_req("SDL_gfx" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(SDL_gfx IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_SDL_gfx_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsdl-gfx1.2-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SDL_gfx_source)
  cl_add_dep(SDL)
  if(NOT TARGET deps::SDL)
    _catalog_log(FATAL_ERROR "SDL_gfx: could not resolve an SDL dependency")
  endif()

  set(SDL_GFX1_VER "2.0.26")
  if(CL_REQ_VERSION)
    set(SDL_GFX1_VER "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME SDL_gfx
    DOWNLOAD_ONLY
    URL https://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-${SDL_GFX1_VER}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/SDL_gfxPrimitives.c")
    _catalog_log(FATAL_ERROR "SDL_gfx: expected sources not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(SDL_gfx
    "${CL_SOURCE_DIR}/SDL_framerate.c"
    "${CL_SOURCE_DIR}/SDL_gfxBlitFunc.c"
    "${CL_SOURCE_DIR}/SDL_gfxPrimitives.c"
    "${CL_SOURCE_DIR}/SDL_imageFilter.c"
    "${CL_SOURCE_DIR}/SDL_rotozoom.c"
  )
  target_include_directories(SDL_gfx PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
  target_link_libraries(SDL_gfx PUBLIC deps::SDL)
endfunction()
