cmake_minimum_required(VERSION 3.15)
project(imgui_sdl3 CXX)

find_package(SDL3 REQUIRED CONFIG)

add_library(imgui_sdl3 STATIC
  ${SOURCE_DIR}/backends/imgui_impl_sdl3.cpp
  ${SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
)
target_include_directories(imgui_sdl3 PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}/backends> $<INSTALL_INTERFACE:include>)
target_include_directories(imgui_sdl3 PRIVATE ${SOURCE_DIR})
target_link_libraries(imgui_sdl3 PRIVATE SDL3::SDL3)
target_compile_features(imgui_sdl3 PUBLIC cxx_std_11)
set_target_properties(imgui_sdl3 PROPERTIES POSITION_INDEPENDENT_CODE ON)
if(UNIX AND NOT APPLE)
  target_link_libraries(imgui_sdl3 PRIVATE dl)
endif()

install(TARGETS imgui_sdl3 ARCHIVE DESTINATION lib)
install(FILES
  ${SOURCE_DIR}/backends/imgui_impl_sdl3.h
  ${SOURCE_DIR}/backends/imgui_impl_opengl3.h
  ${SOURCE_DIR}/backends/imgui_impl_opengl3_loader.h
  DESTINATION include
)
