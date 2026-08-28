function(_recipe_SDL3_mixer_toolchain)
  if(EMSCRIPTEN)
    add_library(SDL3_mixer INTERFACE)
    target_compile_options(SDL3_mixer INTERFACE "-sUSE_SDL_MIXER=3")
    target_link_options(SDL3_mixer INTERFACE "-sUSE_SDL_MIXER=3")
  endif()
endfunction()

function(_recipe_SDL3_mixer_system)
  cl_format_pkgconfig_req("sdl3-mixer" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(SDL3_mixer IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(SDL3_mixer ${CL_REQ_VERSION} QUIET)
      else()
        find_package(SDL3_mixer QUIET)
      endif()
    endif()

    if(NOT TARGET SDL3_mixer AND NOT TARGET SDL3_mixer::SDL3_mixer)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(SDL3_mixer IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_SDL3_mixer_source)
  set(SDL3MIXER_TAG "release-3.2.2")
  if(CL_REQ_VERSION)
    set(SDL3MIXER_TAG "release-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME SDL3_mixer
    URL https://github.com/libsdl-org/SDL_mixer/archive/refs/tags/${SDL3MIXER_TAG}.tar.gz
    OPTIONS "SDLMIXER_VENDORED" "ON" "SDLMIXER_SAMPLES" "OFF"
  )
endfunction()
