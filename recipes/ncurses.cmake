function(_recipe_ncurses_system)
  cl_format_pkgconfig_req("ncursesw" "${CL_VERSION_REQ}" PKG_SPEC_W)
  cl_format_pkgconfig_req("ncurses" "${CL_VERSION_REQ}" PKG_SPEC)

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    foreach(PKG_SPEC_CANDIDATE IN ITEMS ${PKG_SPEC_W} ${PKG_SPEC})
      if(CL_STATIC)
        pkg_check_modules(ncurses IMPORTED_TARGET GLOBAL "--static" QUIET ${PKG_SPEC_CANDIDATE})
      else()
        pkg_check_modules(ncurses IMPORTED_TARGET GLOBAL QUIET ${PKG_SPEC_CANDIDATE})
      endif()
      if(TARGET PkgConfig::ncurses)
        return()
      endif()
    endforeach()
  endif()

  set(CURSES_NEED_NCURSES TRUE)
  find_package(Curses QUIET)
  if(CURSES_FOUND)
    add_library(_ncurses_system INTERFACE)
    target_include_directories(_ncurses_system INTERFACE "${CURSES_INCLUDE_DIRS}")
    target_link_libraries(_ncurses_system INTERFACE "${CURSES_LIBRARIES}")
    add_library(deps::ncurses ALIAS _ncurses_system)
  endif()
endfunction()

function(_recipe_ncurses_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libncurses-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "ncurses" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "ncurses" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "ncurses-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "ncurses-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "ncurses-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_ncurses_source)
  if(WIN32)
    return()
  endif()

  find_program(NCURSES_MAKE_EXE make)
  find_program(NCURSES_SH_EXE sh)
  if(NOT NCURSES_MAKE_EXE OR NOT NCURSES_SH_EXE)
    return()
  endif()

  set(NCURSES_VER "6.6")
  if(CL_REQ_VERSION)
    set(NCURSES_VER "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME ncurses
    DOWNLOAD_ONLY
    URL https://invisible-mirror.net/archives/ncurses/ncurses-${NCURSES_VER}.tar.gz
  )

  set(NCURSES_PREFIX "${CL_SOURCE_DIR}-install")
  set(NCURSES_CONFIGURE_ARGS --prefix=${NCURSES_PREFIX} --with-termlib --enable-widec)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    list(APPEND NCURSES_CONFIGURE_ARGS --without-shared --with-normal)
  elseif(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    list(APPEND NCURSES_CONFIGURE_ARGS --with-shared --without-normal)
  else()
    list(APPEND NCURSES_CONFIGURE_ARGS --with-shared --with-normal)
  endif()

  execute_process(
    COMMAND ${NCURSES_SH_EXE} ./configure ${NCURSES_CONFIGURE_ARGS}
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE NCURSES_CONFIGURE_RESULT
  )
  if(NOT NCURSES_CONFIGURE_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "ncurses: configure failed")
  endif()

  include(ProcessorCount)
  ProcessorCount(NCURSES_NPROC)
  if(NCURSES_NPROC EQUAL 0)
    set(NCURSES_NPROC 1)
  endif()

  execute_process(
    COMMAND ${NCURSES_MAKE_EXE} -j${NCURSES_NPROC} install
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE NCURSES_BUILD_RESULT
  )
  if(NOT NCURSES_BUILD_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "ncurses: build failed")
  endif()

  find_library(NCURSES_LIBRARY NAMES ncursesw ncurses PATHS "${NCURSES_PREFIX}/lib" NO_DEFAULT_PATH)
  if(NOT NCURSES_LIBRARY)
    _catalog_log(FATAL_ERROR "ncurses: built library not found under ${NCURSES_PREFIX}/lib")
  endif()

  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    add_library(_ncurses_source STATIC IMPORTED)
  else()
    add_library(_ncurses_source SHARED IMPORTED)
  endif()
  set_target_properties(_ncurses_source PROPERTIES
    IMPORTED_LOCATION "${NCURSES_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${NCURSES_PREFIX}/include/ncursesw"
  )
  add_library(deps::ncurses ALIAS _ncurses_source)
endfunction()
