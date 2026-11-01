cmake_minimum_required(VERSION 3.15)
project(SDL_gfx C)

find_package(SDL REQUIRED)

add_library(SDL_gfx
  ${SOURCE_DIR}/SDL_framerate.c
  ${SOURCE_DIR}/SDL_gfxBlitFunc.c
  ${SOURCE_DIR}/SDL_gfxPrimitives.c
  ${SOURCE_DIR}/SDL_imageFilter.c
  ${SOURCE_DIR}/SDL_rotozoom.c
)
target_include_directories(SDL_gfx PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}> $<INSTALL_INTERFACE:include/SDL>)
target_include_directories(SDL_gfx PRIVATE ${SDL_INCLUDE_DIR})
target_link_libraries(SDL_gfx PUBLIC ${SDL_LIBRARY})
if(UNIX)
  target_link_libraries(SDL_gfx PRIVATE m)
endif()

install(TARGETS SDL_gfx ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
install(FILES
  ${SOURCE_DIR}/SDL_framerate.h
  ${SOURCE_DIR}/SDL_gfxBlitFunc.h
  ${SOURCE_DIR}/SDL_gfxPrimitives.h
  ${SOURCE_DIR}/SDL_gfxPrimitives_font.h
  ${SOURCE_DIR}/SDL_imageFilter.h
  ${SOURCE_DIR}/SDL_rotozoom.h
  DESTINATION include/SDL
)
