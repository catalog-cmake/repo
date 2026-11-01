cmake_minimum_required(VERSION 3.15)
project(bzip2 C)

add_library(bz2
  ${SOURCE_DIR}/blocksort.c
  ${SOURCE_DIR}/bzlib.c
  ${SOURCE_DIR}/compress.c
  ${SOURCE_DIR}/crctable.c
  ${SOURCE_DIR}/decompress.c
  ${SOURCE_DIR}/huffman.c
  ${SOURCE_DIR}/randtable.c
)
target_include_directories(bz2 PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}> $<INSTALL_INTERFACE:include>)
target_compile_definitions(bz2 PRIVATE _FILE_OFFSET_BITS=64)
set_target_properties(bz2 PROPERTIES POSITION_INDEPENDENT_CODE ON)

install(TARGETS bz2 ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
install(FILES ${SOURCE_DIR}/bzlib.h DESTINATION include)
