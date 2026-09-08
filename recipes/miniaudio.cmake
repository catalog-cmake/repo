function(_recipe_miniaudio_system)
  find_path(MINIAUDIO_INCLUDE_DIR NAMES miniaudio.h)
  if(MINIAUDIO_INCLUDE_DIR)
    add_library(_miniaudio_system INTERFACE)
    target_include_directories(_miniaudio_system INTERFACE "${MINIAUDIO_INCLUDE_DIR}")
    if(UNIX AND NOT APPLE)
      target_link_libraries(_miniaudio_system INTERFACE m pthread dl)
    endif()
    add_library(deps::miniaudio ALIAS _miniaudio_system)
  endif()
endfunction()

function(_recipe_miniaudio_package)
  if(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "miniaudio" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "miniaudio" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_miniaudio_source)
  set(MINIAUDIO_REF "master")
  if(CL_REQ_VERSION)
    set(MINIAUDIO_REF "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME miniaudio
    DOWNLOAD_ONLY
    REPO https://github.com/mackron/miniaudio.git
    REF ${MINIAUDIO_REF}
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/miniaudio.h")
    _catalog_log(FATAL_ERROR "miniaudio: miniaudio.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(miniaudio INTERFACE)
  target_include_directories(miniaudio INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
  if(UNIX AND NOT APPLE)
    target_link_libraries(miniaudio INTERFACE m pthread dl)
  endif()
endfunction()
