cmake_minimum_required(VERSION 3.15)
project(maxmod C)

file(GLOB MAXMOD_SOURCES
  ${SOURCE_DIR}/source/core/*.c
  ${SOURCE_DIR}/source/ds/common/*.c
  ${SOURCE_DIR}/source/ds/arm9/*.c
)

add_library(maxmod STATIC ${MAXMOD_SOURCES})
target_include_directories(maxmod PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}/include> $<INSTALL_INTERFACE:include>)

file(GLOB MAXMOD_HEADERS ${SOURCE_DIR}/include/*.h)
install(TARGETS maxmod ARCHIVE DESTINATION lib)
install(FILES ${MAXMOD_HEADERS} DESTINATION include)
