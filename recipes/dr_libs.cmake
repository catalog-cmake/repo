function(_recipe_dr_libs_system)
  find_path(DR_LIBS_INCLUDE_DIR NAMES dr_wav.h)
  if(DR_LIBS_INCLUDE_DIR)
    add_library(_dr_libs_system INTERFACE)
    target_include_directories(_dr_libs_system INTERFACE "${DR_LIBS_INCLUDE_DIR}")
    add_library(deps::dr_libs ALIAS _dr_libs_system)
  endif()
endfunction()

function(_recipe_dr_libs_source)
  cl_import_source(
    NAME dr_libs
    DOWNLOAD_ONLY
    REPO https://github.com/mackron/dr_libs.git
    REF master
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/dr_wav.h")
    _catalog_log(FATAL_ERROR "dr_libs: dr_wav.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(dr_libs INTERFACE)
  target_include_directories(dr_libs INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
endfunction()
