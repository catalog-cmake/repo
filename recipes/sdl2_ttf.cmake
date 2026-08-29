_catalog_set_var("SDL2TTF_RECIPE_DIR" "${CMAKE_CURRENT_LIST_DIR}")

function(_recipe_SDL2_ttf_toolchain)
  if(EMSCRIPTEN)
    add_library(SDL2_ttf INTERFACE)
    target_compile_options(SDL2_ttf INTERFACE "-sUSE_SDL_TTF=2")
    target_link_options(SDL2_ttf INTERFACE "-sUSE_SDL_TTF=2")
  endif()
endfunction()

function(_recipe_SDL2_ttf_system)
  cl_format_pkgconfig_req("SDL2_ttf" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(SDL2_ttf IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(SDL2_ttf ${CL_REQ_VERSION} QUIET)
      else()
        find_package(SDL2_ttf QUIET)
      endif()
    endif()

    if(NOT TARGET SDL2_ttf AND NOT TARGET SDL2_ttf::SDL2_ttf)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(SDL2_ttf IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_SDL2_ttf_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsdl2-ttf-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "sdl2_ttf" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "sdl2_ttf" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "SDL2_ttf-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "sdl2_ttf-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libSDL2_ttf-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SDL2_ttf_source)
  set(SDL2TTF_TAG "release-2.24.0")
  if(CL_REQ_VERSION)
    set(SDL2TTF_TAG "release-${CL_REQ_VERSION}")
  endif()

  cl_add_dep(freetype)
  cl_add_dep(harfbuzz)

  _catalog_get_var("SDL2TTF_RECIPE_DIR" SDL2TTF_RECIPE_DIR)

  cl_import_source(
    NAME SDL2_ttf
    URL https://github.com/libsdl-org/SDL_ttf/archive/refs/tags/${SDL2TTF_TAG}.tar.gz
    OPTIONS "SDL2TTF_VENDORED" "OFF" "SDL2TTF_SAMPLES" "OFF"
    PATCHES "${SDL2TTF_RECIPE_DIR}/../patches/sdl2_ttf.patch"
  )
endfunction()
