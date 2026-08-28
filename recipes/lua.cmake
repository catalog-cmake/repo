function(_lua_requested_majmin OUT_VAR)
  set(${OUT_VAR} "" PARENT_SCOPE)
  if(CL_REQ_VERSION MATCHES "^([0-9]+\\.[0-9]+)")
    set(${OUT_VAR} "${CMAKE_MATCH_1}" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_lua_system)
  _lua_requested_majmin(LUA_MAJMIN)
  if(LUA_MAJMIN)
    set(LUA_CANDIDATES "${LUA_MAJMIN}")
  else()
    set(LUA_CANDIDATES "5.4" "5.3" "5.1")
  endif()

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    foreach(LUA_VER IN LISTS LUA_CANDIDATES)
      cl_format_pkgconfig_req("lua${LUA_VER}" "${CL_VERSION_REQ}" PKG_SPEC)
      if(CL_STATIC)
        pkg_check_modules(lua IMPORTED_TARGET GLOBAL "--static" QUIET ${PKG_SPEC})
      else()
        pkg_check_modules(lua IMPORTED_TARGET GLOBAL QUIET ${PKG_SPEC})
      endif()
      if(TARGET PkgConfig::lua)
        return()
      endif()
    endforeach()
  endif()
endfunction()

function(_recipe_lua_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  _lua_requested_majmin(LUA_MAJMIN)

  if(NOT LUA_MAJMIN)
    set(LUA_MAJMIN "5.4")
  endif()
  string(REPLACE "." "" LUA_MAJMIN_NODOT "${LUA_MAJMIN}")

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "liblua${LUA_MAJMIN}-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "lua${LUA_MAJMIN_NODOT}" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "lua" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "lua${LUA_MAJMIN}-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_lua_source)
  _lua_requested_majmin(LUA_MAJMIN)

  set(LUA_VER "5.4.8")
  if(CL_REQ_VERSION)
    set(LUA_VER "${CL_REQ_VERSION}")
  elseif(LUA_MAJMIN)
    set(LUA_VER "${LUA_MAJMIN}")
  endif()

  cl_import_source(
    NAME lua
    DOWNLOAD_ONLY
    URL https://www.lua.org/ftp/lua-${LUA_VER}.tar.gz
  )

  set(LUA_SRC_DIR "${CL_SOURCE_DIR}/src")
  if(NOT EXISTS "${LUA_SRC_DIR}/lua.h")
    _catalog_log(FATAL_ERROR "lua: expected sources not found under ${LUA_SRC_DIR}")
  endif()

  file(GLOB LUA_SOURCES "${LUA_SRC_DIR}/*.c")
  list(FILTER LUA_SOURCES EXCLUDE REGEX "/(lua|onelua|ltests|luac)\\.c$")

  if(NOT LUA_SOURCES)
    _catalog_log(FATAL_ERROR "lua: no source files found in ${LUA_SRC_DIR}")
  endif()

  add_library(lua STATIC ${LUA_SOURCES})
  target_include_directories(lua PUBLIC $<BUILD_INTERFACE:${LUA_SRC_DIR}>)
  if(UNIX)
    target_compile_definitions(lua PRIVATE LUA_USE_LINUX)
    find_library(LUA_DL_LIBRARY dl)
    if(LUA_DL_LIBRARY)
      target_link_libraries(lua PRIVATE ${LUA_DL_LIBRARY} m)
    else()
      target_link_libraries(lua PRIVATE m)
    endif()
  endif()
endfunction()
