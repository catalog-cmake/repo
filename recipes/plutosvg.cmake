function(_recipe_plutosvg_system)
  find_package(plutosvg CONFIG QUIET)
endfunction()

function(_recipe_plutosvg_source)
  cl_add_dep(plutovg)
  if(NOT TARGET plutovg::plutovg)
    _catalog_log(FATAL_ERROR "plutosvg: could not resolve a plutovg::plutovg target")
  endif()

  set(PLUTOSVG_TAG "v0.0.8")
  if(CL_REQ_VERSION)
    set(PLUTOSVG_TAG "v${CL_REQ_VERSION}")
  endif()
  string(REGEX REPLACE "^v" "" RECIPE_VERSION "${PLUTOSVG_TAG}")
  cl_set_version("${RECIPE_VERSION}")

  cl_repo_file(patches/plutosvg.patch PLUTOSVG_PATCH)
  set(PLUTOSVG_PATCHES "${PLUTOSVG_PATCH}")
  if(CL_INSTALL_PREFIX)
    set(PLUTOSVG_PATCHES "")
  endif()

  cl_import_source(
    NAME plutosvg
    URL https://github.com/sammycage/plutosvg/archive/refs/tags/${PLUTOSVG_TAG}.tar.gz
    OPTIONS "PLUTOSVG_BUILD_EXAMPLES" "OFF" "PLUTOSVG_ENABLE_FREETYPE" "OFF"
    PATCHES ${PLUTOSVG_PATCHES}
  )
endfunction()

function(_recipe_plutosvg_latest)
  set(PLUTOSVG_TAG "v0.0.8")
  if(CL_REQ_VERSION)
    set(PLUTOSVG_TAG "v${CL_REQ_VERSION}")
  endif()
  string(REGEX REPLACE "^v" "" RECIPE_VERSION "${PLUTOSVG_TAG}")
  cl_set_version("${RECIPE_VERSION}")
endfunction()
