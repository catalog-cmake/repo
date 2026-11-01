cmake_minimum_required(VERSION 3.15)
project(imgui_sdl2 CXX)

find_package(SDL2 REQUIRED)

add_library(imgui_sdl2 STATIC
  ${SOURCE_DIR}/backends/imgui_impl_sdl2.cpp
  ${SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
)
target_include_directories(imgui_sdl2 PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}/backends> $<INSTALL_INTERFACE:include>)
target_include_directories(imgui_sdl2 PRIVATE ${SOURCE_DIR})
target_link_libraries(imgui_sdl2 PRIVATE SDL2::SDL2)
target_compile_features(imgui_sdl2 PUBLIC cxx_std_11)
set_target_properties(imgui_sdl2 PROPERTIES POSITION_INDEPENDENT_CODE ON)
if(UNIX AND NOT APPLE)
  target_link_libraries(imgui_sdl2 PRIVATE dl)
endif()

install(TARGETS imgui_sdl2 ARCHIVE DESTINATION lib)
install(FILES
  ${SOURCE_DIR}/backends/imgui_impl_sdl2.h
  ${SOURCE_DIR}/backends/imgui_impl_opengl3.h
  ${SOURCE_DIR}/backends/imgui_impl_opengl3_loader.h
  DESTINATION include
)
