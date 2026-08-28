function(_recipe_libretro_system)
  find_path(LIBRETRO_INCLUDE_DIR NAMES libretro.h)
  if(LIBRETRO_INCLUDE_DIR)
    add_library(_libretro_system INTERFACE)
    target_include_directories(_libretro_system INTERFACE "${LIBRETRO_INCLUDE_DIR}")
    add_library(deps::libretro ALIAS _libretro_system)
  endif()
endfunction()

function(_recipe_libretro_source)
  cl_import_source(
    NAME libretro
    DOWNLOAD_ONLY
    REPO https://github.com/libretro/libretro-common.git
    REF master
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/include/libretro.h")
    _catalog_log(FATAL_ERROR "libretro: include/libretro.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(libretro INTERFACE)
  target_include_directories(libretro INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}/include>)
endfunction()
