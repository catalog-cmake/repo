function(_recipe_maxmod_system)
  if(NOT DEFINED DEVKITPRO)
    return()
  endif()

  include(CheckIncludeFile)
  check_include_file(maxmod9.h HAVE_MAXMOD9_H)
  if(HAVE_MAXMOD9_H)
    add_library(_maxmod_system INTERFACE)
    target_link_libraries(_maxmod_system INTERFACE mm9)
    add_library(deps::maxmod ALIAS _maxmod_system)
  endif()
endfunction()

function(_recipe_maxmod_source)
  if(NOT DEFINED DEVKITPRO)
    return()
  endif()

  set(MAXMOD_TAG "v1.23.0-blocks")
  if(CL_REQ_VERSION)
    set(MAXMOD_TAG "v${CL_REQ_VERSION}-blocks")
  endif()

  cl_import_source(
    NAME maxmod
    DOWNLOAD_ONLY
    URL https://codeberg.org/blocksds/maxmod/archive/${MAXMOD_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/source/core/mas.c")
    _catalog_log(FATAL_ERROR "maxmod: expected sources not found under ${CL_SOURCE_DIR}/source/core")
  endif()

  file(GLOB MAXMOD_SOURCES
    "${CL_SOURCE_DIR}/source/core/*.c"
    "${CL_SOURCE_DIR}/source/ds/common/*.c"
    "${CL_SOURCE_DIR}/source/ds/arm9/*.c"
  )

  add_library(maxmod STATIC ${MAXMOD_SOURCES})
  target_include_directories(maxmod PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}/include>)
endfunction()
