function(_recipe_msgpack_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(msgpack-cxx ${CL_REQ_VERSION} QUIET)
    else()
      find_package(msgpack-cxx QUIET)
    endif()

    if(TARGET msgpack-cxx)
      get_target_property(_MSGPACK_ALIASED msgpack-cxx ALIASED_TARGET)
      if(_MSGPACK_ALIASED)
        add_library(deps::msgpack ALIAS ${_MSGPACK_ALIASED})
      else()
        add_library(deps::msgpack ALIAS msgpack-cxx)
      endif()
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("msgpack" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(msgpack IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_msgpack_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libmsgpack-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "msgpack-c" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "msgpack-cxx" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_msgpack_source)
  set(MSGPACK_TAG "cpp-9.0.0")
  if(CL_REQ_VERSION)
    set(MSGPACK_TAG "cpp-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME msgpack
    URL https://github.com/msgpack/msgpack-c/archive/refs/tags/${MSGPACK_TAG}.tar.gz
    OPTIONS "MSGPACK_BUILD_TESTS" "OFF" "MSGPACK_BUILD_EXAMPLES" "OFF" "MSGPACK_BUILD_DOCS" "OFF" "MSGPACK_USE_BOOST" "OFF"
  )

  if(TARGET msgpack-cxx)
    add_library(deps::msgpack ALIAS msgpack-cxx)
  endif()
endfunction()
