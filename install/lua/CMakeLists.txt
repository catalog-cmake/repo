cmake_minimum_required(VERSION 3.15)
project(lua C)

file(GLOB LUA_SOURCES ${SOURCE_DIR}/src/*.c)
list(FILTER LUA_SOURCES EXCLUDE REGEX "/(lua|onelua|ltests|luac)\\.c$")

add_library(lua STATIC ${LUA_SOURCES})
target_include_directories(lua PUBLIC $<BUILD_INTERFACE:${SOURCE_DIR}/src> $<INSTALL_INTERFACE:include>)
if(UNIX)
  target_compile_definitions(lua PRIVATE LUA_USE_LINUX)
  find_library(LUA_DL_LIBRARY dl)
  if(LUA_DL_LIBRARY)
    target_link_libraries(lua PRIVATE ${LUA_DL_LIBRARY} m)
  else()
    target_link_libraries(lua PRIVATE m)
  endif()
endif()

install(TARGETS lua ARCHIVE DESTINATION lib)
install(FILES
  ${SOURCE_DIR}/src/lua.h
  ${SOURCE_DIR}/src/luaconf.h
  ${SOURCE_DIR}/src/lualib.h
  ${SOURCE_DIR}/src/lauxlib.h
  ${SOURCE_DIR}/src/lua.hpp
  DESTINATION include
)
