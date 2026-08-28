function(_recipe_stb_image_system)
  find_path(STB_IMAGE_INCLUDE_DIR NAMES stb_image.h)
  if(STB_IMAGE_INCLUDE_DIR)
    add_library(_stb_image_system INTERFACE)
    target_include_directories(_stb_image_system INTERFACE "${STB_IMAGE_INCLUDE_DIR}")
    add_library(deps::stb_image ALIAS _stb_image_system)
  endif()
endfunction()

function(_recipe_stb_image_source)
  cl_import_source(
    NAME stb_image
    DOWNLOAD_ONLY
    REPO https://github.com/nothings/stb.git
    REF master
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/stb_image.h")
    _catalog_log(FATAL_ERROR "stb_image: stb_image.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(stb_image INTERFACE)
  target_include_directories(stb_image INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
endfunction()
