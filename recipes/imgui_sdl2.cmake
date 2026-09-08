function(_recipe_imgui_sdl2_source)
  cl_add_dep(imgui)
  cl_add_dep(SDL2)

  set(IMGUI_TAG "v1.92.9")
  if(CL_REQ_VERSION)
    set(IMGUI_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME imgui_sdl2
    DOWNLOAD_ONLY
    URL https://github.com/ocornut/imgui/archive/refs/tags/${IMGUI_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/backends/imgui_impl_sdl2.h")
    _catalog_log(FATAL_ERROR "imgui_sdl2: backends/imgui_impl_sdl2.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(imgui_sdl2 STATIC
    "${CL_SOURCE_DIR}/backends/imgui_impl_sdl2.cpp"
    "${CL_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp"
  )
  target_include_directories(imgui_sdl2 PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}/backends>)
  target_link_libraries(imgui_sdl2 PUBLIC deps::imgui deps::SDL2)
  target_compile_features(imgui_sdl2 PUBLIC cxx_std_11)
  set_target_properties(imgui_sdl2 PROPERTIES POSITION_INDEPENDENT_CODE ON)

  if(UNIX AND NOT APPLE)
    target_link_libraries(imgui_sdl2 PRIVATE dl)
  endif()
endfunction()
