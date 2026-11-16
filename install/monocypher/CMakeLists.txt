cmake_minimum_required(VERSION 3.15)
project(monocypher C)

add_library(monocypher
  ${SOURCE_DIR}/src/monocypher.c
  ${SOURCE_DIR}/src/optional/monocypher-ed25519.c
)
target_include_directories(monocypher PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}/src> $<BUILD_INTERFACE:${SOURCE_DIR}/src/optional> $<INSTALL_INTERFACE:include>)
set_target_properties(monocypher PROPERTIES C_STANDARD 99 POSITION_INDEPENDENT_CODE ON)

install(TARGETS monocypher ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
install(FILES ${SOURCE_DIR}/src/monocypher.h ${SOURCE_DIR}/src/optional/monocypher-ed25519.h DESTINATION include)
