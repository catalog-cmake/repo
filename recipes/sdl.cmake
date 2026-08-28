function(_recipe_SDL_system)
  find_package(SDL QUIET)
  if(SDL_FOUND)
    add_library(_sdl_system INTERFACE)
    target_include_directories(_sdl_system INTERFACE "${SDL_INCLUDE_DIR}")
    target_link_libraries(_sdl_system INTERFACE "${SDL_LIBRARY}")
    add_library(deps::SDL ALIAS _sdl_system)
    return()
  endif()

  cl_format_pkgconfig_req("sdl" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(SDL IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_SDL_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsdl1.2-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SDL_source)
  if(WIN32)
    return()
  endif()

  find_program(SDL1_SH_EXE sh)
  find_program(SDL1_MAKE_EXE make)
  find_program(SDL1_AUTOCONF_EXE autoconf)
  find_program(SDL1_AUTOMAKE_EXE automake)
  find_program(SDL1_LIBTOOLIZE_EXE libtoolize)
  if(NOT SDL1_SH_EXE OR NOT SDL1_MAKE_EXE OR NOT SDL1_AUTOCONF_EXE OR NOT SDL1_AUTOMAKE_EXE OR NOT SDL1_LIBTOOLIZE_EXE)
    return()
  endif()

  set(SDL1_TAG "release-1.2.15")
  if(CL_REQ_VERSION)
    set(SDL1_TAG "release-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME SDL
    DOWNLOAD_ONLY
    URL https://github.com/libsdl-org/SDL-1.2/archive/refs/tags/${SDL1_TAG}.tar.gz
  )

  execute_process(
    COMMAND ${SDL1_SH_EXE} autogen.sh
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE SDL1_AUTOGEN_RESULT
  )
  if(NOT SDL1_AUTOGEN_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "SDL: autogen.sh failed")
  endif()

  set(SDL1_PREFIX "${CL_SOURCE_DIR}-install")
  set(SDL1_CONFIGURE_ARGS --prefix=${SDL1_PREFIX})
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    list(APPEND SDL1_CONFIGURE_ARGS --disable-shared --enable-static)
  else()
    list(APPEND SDL1_CONFIGURE_ARGS --enable-shared --disable-static)
  endif()

  execute_process(
    COMMAND ${SDL1_SH_EXE} ./configure ${SDL1_CONFIGURE_ARGS}
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE SDL1_CONFIGURE_RESULT
  )
  if(NOT SDL1_CONFIGURE_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "SDL: configure failed")
  endif()

  execute_process(
    COMMAND ${SDL1_MAKE_EXE} install
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE SDL1_BUILD_RESULT
  )
  if(NOT SDL1_BUILD_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "SDL: build failed")
  endif()

  find_library(SDL1_LIBRARY NAMES SDL PATHS "${SDL1_PREFIX}/lib" NO_DEFAULT_PATH)
  if(NOT SDL1_LIBRARY)
    _catalog_log(FATAL_ERROR "SDL: built library not found under ${SDL1_PREFIX}/lib")
  endif()

  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    add_library(_sdl_source STATIC IMPORTED)
  else()
    add_library(_sdl_source SHARED IMPORTED)
  endif()
  set_target_properties(_sdl_source PROPERTIES
    IMPORTED_LOCATION "${SDL1_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${SDL1_PREFIX}/include/SDL"
  )
  add_library(deps::SDL ALIAS _sdl_source)
endfunction()
