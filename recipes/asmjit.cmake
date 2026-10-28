function(_recipe_asmjit_system)
  if(NOT CMAKE_CROSSCOMPILING)
    find_package(asmjit CONFIG QUIET)
  endif()

  if(NOT TARGET asmjit::asmjit)
    cl_format_pkgconfig_req("asmjit" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(asmjit IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_asmjit_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libasmjit-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_asmjit_source)
  set(ASMJIT_REF "master")
  if(CL_REQ_VERSION)
    set(ASMJIT_REF "${CL_REQ_VERSION}")
  endif()

  set(ASMJIT_BUILD_STATIC ON)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(ASMJIT_BUILD_STATIC OFF)
  endif()

  cl_import_source(
    NAME asmjit
    REPO https://github.com/asmjit/asmjit.git
    REF ${ASMJIT_REF}
    OPTIONS
      "ASMJIT_STATIC" "${ASMJIT_BUILD_STATIC}"
      "ASMJIT_TEST" "OFF"
      "ASMJIT_NO_INSTALL" "ON"
  )
endfunction()
