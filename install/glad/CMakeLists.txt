cmake_minimum_required(VERSION 3.15)
project(glad C)

if(NOT GLAD_API)
  set(GLAD_API "gl:core=4.1")
endif()

add_subdirectory(${SOURCE_DIR}/cmake glad-cmake)
glad_add_library(glad STATIC REPRODUCIBLE LOADER LANGUAGE C API ${GLAD_API})
set_target_properties(glad PROPERTIES POSITION_INDEPENDENT_CODE ON)

get_target_property(GLAD_INCLUDE_DIRS glad INTERFACE_INCLUDE_DIRECTORIES)
install(TARGETS glad ARCHIVE DESTINATION lib)
foreach(GLAD_INCLUDE_DIR ${GLAD_INCLUDE_DIRS})
  install(DIRECTORY ${GLAD_INCLUDE_DIR}/ DESTINATION include)
endforeach()
