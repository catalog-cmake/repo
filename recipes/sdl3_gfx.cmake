function(_recipe_SDL3_gfx_system)
  cl_format_pkgconfig_req("SDL3_gfx" "${CL_VERSION_REQ}" PKG_SPEC)

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(SDL3_gfx IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(SDL3_gfx IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_SDL3_gfx_source)
  cl_add_dep(SDL3)
  if(NOT TARGET deps::SDL3)
    _catalog_log(FATAL_ERROR "SDL3_gfx: could not resolve an SDL3 dependency")
  endif()

  set(SDL3GFX_TAG "v1.0.1")
  if(CL_REQ_VERSION)
    set(SDL3GFX_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME SDL3_gfx
    DOWNLOAD_ONLY
    URL https://github.com/sabdul-khabir/SDL3_gfx/archive/refs/tags/${SDL3GFX_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/SDL3_gfxPrimitives.c")
    _catalog_log(FATAL_ERROR "SDL3_gfx: expected sources not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(SDL3_gfx
    "${CL_SOURCE_DIR}/SDL3_framerate.c"
    "${CL_SOURCE_DIR}/SDL3_gfxPrimitives.c"
    "${CL_SOURCE_DIR}/SDL3_imageFilter.c"
    "${CL_SOURCE_DIR}/SDL3_rotozoom.c"
  )
  target_include_directories(SDL3_gfx PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
  target_link_libraries(SDL3_gfx PUBLIC deps::SDL3)
endfunction()
