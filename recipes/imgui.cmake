function(_recipe_imgui_system)
  find_path(IMGUI_INCLUDE_DIR NAMES imgui.h)
  if(IMGUI_INCLUDE_DIR)
    find_library(IMGUI_LIBRARY NAMES imgui)
    if(IMGUI_LIBRARY)
      add_library(_imgui_system INTERFACE)
      target_include_directories(_imgui_system INTERFACE "${IMGUI_INCLUDE_DIR}")
      target_link_libraries(_imgui_system INTERFACE "${IMGUI_LIBRARY}")
      add_library(deps::imgui ALIAS _imgui_system)
    endif()
  endif()
endfunction()

function(_recipe_imgui_source)
  set(IMGUI_TAG "v1.92.9")
  if(CL_REQ_VERSION)
    set(IMGUI_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME imgui
    DOWNLOAD_ONLY
    URL https://github.com/ocornut/imgui/archive/refs/tags/${IMGUI_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/imgui.h")
    _catalog_log(FATAL_ERROR "imgui: imgui.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(imgui STATIC
    "${CL_SOURCE_DIR}/imgui.cpp"
    "${CL_SOURCE_DIR}/imgui_draw.cpp"
    "${CL_SOURCE_DIR}/imgui_tables.cpp"
    "${CL_SOURCE_DIR}/imgui_widgets.cpp"
  )
  target_include_directories(imgui PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)
  target_compile_features(imgui PUBLIC cxx_std_11)
  set_target_properties(imgui PROPERTIES POSITION_INDEPENDENT_CODE ON)
endfunction()
