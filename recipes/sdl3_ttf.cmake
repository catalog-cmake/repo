function(_recipe_SDL3_ttf_toolchain)
  if(EMSCRIPTEN)
    add_library(SDL3_ttf INTERFACE)
    target_compile_options(SDL3_ttf INTERFACE "-sUSE_SDL_TTF=3")
    target_link_options(SDL3_ttf INTERFACE "-sUSE_SDL_TTF=3")
  endif()
endfunction()

function(_recipe_SDL3_ttf_system)
  cl_format_pkgconfig_req("sdl3-ttf" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(SDL3_ttf IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(SDL3_ttf ${CL_REQ_VERSION} QUIET)
      else()
        find_package(SDL3_ttf QUIET)
      endif()
    endif()

    if(NOT TARGET SDL3_ttf AND NOT TARGET SDL3_ttf::SDL3_ttf)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(SDL3_ttf IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_SDL3_ttf_source)
  set(SDL3TTF_TAG "release-3.2.2")
  if(CL_REQ_VERSION)
    set(SDL3TTF_TAG "release-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME SDL3_ttf
    URL https://github.com/libsdl-org/SDL_ttf/archive/refs/tags/${SDL3TTF_TAG}.tar.gz
    OPTIONS "SDLTTF_VENDORED" "ON" "SDLTTF_SAMPLES" "OFF"
  )
endfunction()
