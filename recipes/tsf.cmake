function(_recipe_tsf_system)
  find_path(TSF_INCLUDE_DIR NAMES tsf.h)
  if(TSF_INCLUDE_DIR)
    add_library(_tsf_system INTERFACE)
    target_include_directories(_tsf_system INTERFACE "${TSF_INCLUDE_DIR}")
    add_library(deps::tsf ALIAS _tsf_system)
  endif()
endfunction()

function(_recipe_tsf_source)
  cl_import_source(
    NAME tsf
    DOWNLOAD_ONLY
    REPO https://github.com/schellingb/TinySoundFont.git
    REF main
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/tsf.h")
    _catalog_log(FATAL_ERROR "tsf: tsf.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(tsf INTERFACE)
  target_include_directories(tsf INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
endfunction()
