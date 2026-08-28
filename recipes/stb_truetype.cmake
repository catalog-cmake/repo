function(_recipe_stb_truetype_system)
  find_path(STB_TRUETYPE_INCLUDE_DIR NAMES stb_truetype.h)
  if(STB_TRUETYPE_INCLUDE_DIR)
    add_library(_stb_truetype_system INTERFACE)
    target_include_directories(_stb_truetype_system INTERFACE "${STB_TRUETYPE_INCLUDE_DIR}")
    add_library(deps::stb_truetype ALIAS _stb_truetype_system)
  endif()
endfunction()

function(_recipe_stb_truetype_source)
  cl_import_source(
    NAME stb_truetype
    DOWNLOAD_ONLY
    REPO https://github.com/nothings/stb.git
    REF master
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/stb_truetype.h")
    _catalog_log(FATAL_ERROR "stb_truetype: stb_truetype.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(stb_truetype INTERFACE)
  target_include_directories(stb_truetype INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
endfunction()
