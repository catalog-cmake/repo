function(_recipe_SDL_ttf_system)
  cl_format_pkgconfig_req("SDL_ttf" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(SDL_ttf IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_SDL_ttf_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsdl-ttf2.0-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SDL_ttf_source)
  find_program(SDL_TTF1_SDLCONFIG_EXE sdl-config)
  find_program(SDL_TTF1_SH_EXE sh)
  find_program(SDL_TTF1_MAKE_EXE make)
  if(WIN32 OR NOT SDL_TTF1_SDLCONFIG_EXE OR NOT SDL_TTF1_SH_EXE OR NOT SDL_TTF1_MAKE_EXE)
    return()
  endif()

  cl_import_source(
    NAME SDL_ttf
    DOWNLOAD_ONLY
    REPO https://github.com/libsdl-org/SDL_ttf.git
    REF SDL-1.2
  )

  set(SDL_TTF1_PREFIX "${CL_SOURCE_DIR}-install")

  execute_process(
    COMMAND ${SDL_TTF1_SH_EXE} ./configure --prefix=${SDL_TTF1_PREFIX}
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE SDL_TTF1_CONFIGURE_RESULT
  )
  if(NOT SDL_TTF1_CONFIGURE_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "SDL_ttf: configure failed")
  endif()

  execute_process(
    COMMAND ${SDL_TTF1_MAKE_EXE} install
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE SDL_TTF1_BUILD_RESULT
  )
  if(NOT SDL_TTF1_BUILD_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "SDL_ttf: build failed")
  endif()

  find_library(SDL_TTF1_LIBRARY NAMES SDL_ttf PATHS "${SDL_TTF1_PREFIX}/lib" NO_DEFAULT_PATH)
  if(NOT SDL_TTF1_LIBRARY)
    _catalog_log(FATAL_ERROR "SDL_ttf: built library not found under ${SDL_TTF1_PREFIX}/lib")
  endif()

  add_library(_sdl_ttf1_source UNKNOWN IMPORTED)
  set_target_properties(_sdl_ttf1_source PROPERTIES
    IMPORTED_LOCATION "${SDL_TTF1_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${SDL_TTF1_PREFIX}/include/SDL"
  )
  add_library(deps::SDL_ttf ALIAS _sdl_ttf1_source)
endfunction()
