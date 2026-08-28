function(_recipe_stb_vorbis_system)
  find_path(STB_VORBIS_INCLUDE_DIR NAMES stb_vorbis.c)
  if(STB_VORBIS_INCLUDE_DIR)
    add_library(_stb_vorbis_system STATIC "${STB_VORBIS_INCLUDE_DIR}/stb_vorbis.c")
    target_include_directories(_stb_vorbis_system PUBLIC "${STB_VORBIS_INCLUDE_DIR}")
    add_library(deps::stb_vorbis ALIAS _stb_vorbis_system)
  endif()
endfunction()

function(_recipe_stb_vorbis_source)
  cl_import_source(
    NAME stb_vorbis
    DOWNLOAD_ONLY
    REPO https://github.com/nothings/stb.git
    REF master
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/stb_vorbis.c")
    _catalog_log(FATAL_ERROR "stb_vorbis: stb_vorbis.c not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(stb_vorbis STATIC "${CL_SOURCE_DIR}/stb_vorbis.c")
  target_include_directories(stb_vorbis PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
endfunction()
