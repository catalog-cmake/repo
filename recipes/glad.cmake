function(_recipe_glad_source)
  set(GLAD_TAG "v2.0.8")
  if(CL_REQ_VERSION)
    set(GLAD_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME glad
    DOWNLOAD_ONLY
    URL https://github.com/Dav1dde/glad/archive/refs/tags/${GLAD_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/cmake/CMakeLists.txt")
    _catalog_log(FATAL_ERROR "glad: expected cmake/CMakeLists.txt not found under ${CL_SOURCE_DIR}")
  endif()

  add_subdirectory("${CL_SOURCE_DIR}/cmake" "${CL_SOURCE_DIR}-build")

  set(GLAD_API "gl:core=4.1")
  _catalog_get_var("API" CL_GLAD_API)
  if(CL_GLAD_API)
    set(GLAD_API "${CL_GLAD_API}")
  endif()

  glad_add_library(glad REPRODUCIBLE LOADER LANGUAGE C API ${GLAD_API})

  if(TARGET glad)
    add_library(deps::GLAD ALIAS glad)
  endif()
endfunction()
