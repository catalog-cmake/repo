cmake_minimum_required(VERSION 3.15)
project(imgui CXX)

add_library(imgui STATIC
  ${SOURCE_DIR}/imgui.cpp
  ${SOURCE_DIR}/imgui_draw.cpp
  ${SOURCE_DIR}/imgui_tables.cpp
  ${SOURCE_DIR}/imgui_widgets.cpp
)
target_include_directories(imgui PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}> $<INSTALL_INTERFACE:include>)
target_compile_features(imgui PUBLIC cxx_std_11)
set_target_properties(imgui PROPERTIES POSITION_INDEPENDENT_CODE ON)

install(TARGETS imgui ARCHIVE DESTINATION lib)
install(FILES
  ${SOURCE_DIR}/imgui.h
  ${SOURCE_DIR}/imconfig.h
  ${SOURCE_DIR}/imgui_internal.h
  ${SOURCE_DIR}/imstb_rectpack.h
  ${SOURCE_DIR}/imstb_textedit.h
  ${SOURCE_DIR}/imstb_truetype.h
  DESTINATION include
)
