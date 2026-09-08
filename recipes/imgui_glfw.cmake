function(_recipe_imgui_glfw_source)
  cl_add_dep(imgui)
  cl_add_dep(GLFW)

  set(IMGUI_TAG "v1.92.9")
  if(CL_REQ_VERSION)
    set(IMGUI_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME imgui_glfw
    DOWNLOAD_ONLY
    URL https://github.com/ocornut/imgui/archive/refs/tags/${IMGUI_TAG}.tar.gz
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/backends/imgui_impl_glfw.h")
    _catalog_log(FATAL_ERROR "imgui_glfw: backends/imgui_impl_glfw.h not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(imgui_glfw STATIC
    "${CL_SOURCE_DIR}/backends/imgui_impl_glfw.cpp"
    "${CL_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp"
  )
  target_include_directories(imgui_glfw PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}/backends>)
  target_link_libraries(imgui_glfw PUBLIC deps::imgui deps::GLFW)
  target_compile_features(imgui_glfw PUBLIC cxx_std_11)
  set_target_properties(imgui_glfw PROPERTIES POSITION_INDEPENDENT_CODE ON)

  if(UNIX AND NOT APPLE)
    target_link_libraries(imgui_glfw PRIVATE dl)
  endif()
endfunction()
