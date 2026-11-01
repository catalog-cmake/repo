cmake_minimum_required(VERSION 3.15)
project(imgui_glfw CXX)

find_package(glfw3 REQUIRED)

add_library(imgui_glfw STATIC
  ${SOURCE_DIR}/backends/imgui_impl_glfw.cpp
  ${SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
)
target_include_directories(imgui_glfw PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}/backends> $<INSTALL_INTERFACE:include>)
target_include_directories(imgui_glfw PRIVATE ${SOURCE_DIR})
target_link_libraries(imgui_glfw PRIVATE glfw)
target_compile_features(imgui_glfw PUBLIC cxx_std_11)
set_target_properties(imgui_glfw PROPERTIES POSITION_INDEPENDENT_CODE ON)
if(UNIX AND NOT APPLE)
  target_link_libraries(imgui_glfw PRIVATE dl)
endif()

install(TARGETS imgui_glfw ARCHIVE DESTINATION lib)
install(FILES
  ${SOURCE_DIR}/backends/imgui_impl_glfw.h
  ${SOURCE_DIR}/backends/imgui_impl_opengl3.h
  ${SOURCE_DIR}/backends/imgui_impl_opengl3_loader.h
  DESTINATION include
)
