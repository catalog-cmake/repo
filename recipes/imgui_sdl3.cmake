function(_recipe_imgui_sdl3_source)
  cl_add_dep(imgui)
  cl_add_dep(SDL3)

  set(IMGUI_TAG "v1.92.9")
  if(CL_REQ_VERSION)
    set(IMGUI_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME imgui_sdl3
    DOWNLOAD_ONLY
    URL https://github.com/ocornut/imgui/archive/refs/tags/${IMGUI_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/backends/imgui_impl_sdl3.h")
    _catalog_log(FATAL_ERROR "imgui_sdl3: backends/imgui_impl_sdl3.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(imgui_sdl3 STATIC
    "${CL_SOURCE_DIR}/backends/imgui_impl_sdl3.cpp"
    "${CL_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp"
  )
  target_include_directories(imgui_sdl3 PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}/backends>)
  target_link_libraries(imgui_sdl3 PUBLIC deps::imgui deps::SDL3)
  target_compile_features(imgui_sdl3 PUBLIC cxx_std_11)
  set_target_properties(imgui_sdl3 PROPERTIES POSITION_INDEPENDENT_CODE ON)

  if(UNIX AND NOT APPLE)
    target_link_libraries(imgui_sdl3 PRIVATE dl)
  endif()
endfunction()
