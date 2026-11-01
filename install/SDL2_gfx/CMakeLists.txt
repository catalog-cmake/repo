cmake_minimum_required(VERSION 3.15)
project(SDL2_gfx C)

find_package(SDL2 REQUIRED)

add_library(SDL2_gfx
  ${SOURCE_DIR}/SDL2_framerate.c
  ${SOURCE_DIR}/SDL2_gfxPrimitives.c
  ${SOURCE_DIR}/SDL2_imageFilter.c
  ${SOURCE_DIR}/SDL2_rotozoom.c
)
target_include_directories(SDL2_gfx PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}> $<INSTALL_INTERFACE:include/SDL2>)
target_link_libraries(SDL2_gfx PUBLIC SDL2::SDL2)
if(UNIX)
  target_link_libraries(SDL2_gfx PRIVATE m)
endif()

install(TARGETS SDL2_gfx ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
install(FILES
  ${SOURCE_DIR}/SDL2_framerate.h
  ${SOURCE_DIR}/SDL2_gfxPrimitives.h
  ${SOURCE_DIR}/SDL2_gfxPrimitives_font.h
  ${SOURCE_DIR}/SDL2_imageFilter.h
  ${SOURCE_DIR}/SDL2_rotozoom.h
  DESTINATION include/SDL2
)
