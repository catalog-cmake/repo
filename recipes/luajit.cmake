function(_recipe_luajit_system)
  cl_format_pkgconfig_req("luajit" "${CL_VERSION_REQ}" PKG_SPEC)

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(luajit IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(luajit IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_luajit_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libluajit-5.1-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "luajit" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "luajit" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "luajit-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_luajit_source)
  if(WIN32)
    return()
  endif()

  find_program(LUAJIT_MAKE_EXE make)
  find_program(LUAJIT_GIT_EXE git)
  if(NOT LUAJIT_MAKE_EXE OR NOT LUAJIT_GIT_EXE)
    return()
  endif()

  set(LUAJIT_REF "v2.1")
  if(CL_REQ_VERSION)
    set(LUAJIT_REF "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME luajit
    DOWNLOAD_ONLY
    REPO https://github.com/LuaJIT/LuaJIT.git
    REF ${LUAJIT_REF}
  )

  execute_process(
    COMMAND ${LUAJIT_MAKE_EXE}
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE LUAJIT_BUILD_RESULT
  )
  if(NOT LUAJIT_BUILD_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "luajit: build failed")
  endif()

  add_library(luajit STATIC IMPORTED)
  set_target_properties(luajit PROPERTIES
    IMPORTED_LOCATION "${CL_SOURCE_DIR}/src/libluajit.a"
    INTERFACE_INCLUDE_DIRECTORIES "${CL_SOURCE_DIR}/src"
  )
  find_library(LUAJIT_DL_LIBRARY dl)
  if(LUAJIT_DL_LIBRARY)
    set_property(TARGET luajit APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${LUAJIT_DL_LIBRARY})
  endif()
  set_property(TARGET luajit APPEND PROPERTY INTERFACE_LINK_LIBRARIES m)
endfunction()
