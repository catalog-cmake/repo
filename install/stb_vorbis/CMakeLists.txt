cmake_minimum_required(VERSION 3.15)
project(stb_vorbis C)

add_library(stb_vorbis STATIC ${SOURCE_DIR}/stb_vorbis.c)
target_include_directories(stb_vorbis PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}> $<INSTALL_INTERFACE:include>)

install(TARGETS stb_vorbis ARCHIVE DESTINATION lib)
install(FILES ${SOURCE_DIR}/stb_vorbis.c DESTINATION include)
