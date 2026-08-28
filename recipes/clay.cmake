function(_recipe_clay_system)
  find_path(CLAY_INCLUDE_DIR NAMES clay.h)
  if(CLAY_INCLUDE_DIR)
    add_library(_clay_system INTERFACE)
    target_include_directories(_clay_system INTERFACE "${CLAY_INCLUDE_DIR}")
    add_library(deps::clay ALIAS _clay_system)
  endif()
endfunction()

function(_recipe_clay_source)
  set(CLAY_TAG "v0.14")
  if(CL_REQ_VERSION)
    set(CLAY_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME clay
    DOWNLOAD_ONLY
    URL https://github.com/nicbarker/clay/archive/refs/tags/${CLAY_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/clay.h")
    _catalog_log(FATAL_ERROR "clay: clay.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(clay INTERFACE)
  target_include_directories(clay INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
endfunction()
