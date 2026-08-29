_catalog_set_var("SDL3IMAGE_RECIPE_DIR" "${CMAKE_CURRENT_LIST_DIR}")

function(_recipe_SDL3_image_toolchain)
  if(EMSCRIPTEN)
    add_library(SDL3_image INTERFACE)
    target_compile_options(SDL3_image INTERFACE "-sUSE_SDL_IMAGE=3")
    target_link_options(SDL3_image INTERFACE "-sUSE_SDL_IMAGE=3")
  endif()
endfunction()

function(_recipe_SDL3_image_system)
  cl_format_pkgconfig_req("sdl3-image" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(SDL3_image IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(SDL3_image ${CL_REQ_VERSION} QUIET)
      else()
        find_package(SDL3_image QUIET)
      endif()
    endif()

    if(NOT TARGET SDL3_image AND NOT TARGET SDL3_image::SDL3_image)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(SDL3_image IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_SDL3_image_source)
  set(SDL3IMAGE_TAG "release-3.4.4")
  if(CL_REQ_VERSION)
    set(SDL3IMAGE_TAG "release-${CL_REQ_VERSION}")
  endif()

  cl_add_dep(libwebp)

  _catalog_get_var("SDL3IMAGE_RECIPE_DIR" SDL3IMAGE_RECIPE_DIR)

  cl_import_source(
    NAME SDL3_image
    URL https://github.com/libsdl-org/SDL_image/archive/refs/tags/${SDL3IMAGE_TAG}.tar.gz
    OPTIONS "SDLIMAGE_VENDORED" "OFF" "SDLIMAGE_SAMPLES" "OFF" "SDLIMAGE_TESTS" "OFF" "SDLIMAGE_DEPS_SHARED" "OFF"
    PATCHES "${SDL3IMAGE_RECIPE_DIR}/../patches/sdl3_image.patch"
  )
endfunction()
