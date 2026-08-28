function(_recipe_mbedtls_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(MbedTLS ${CL_REQ_VERSION} QUIET)
    else()
      find_package(MbedTLS QUIET)
    endif()

    if(TARGET MbedTLS::mbedtls)
      get_target_property(_MBEDTLS_ALIASED MbedTLS::mbedtls ALIASED_TARGET)
      if(_MBEDTLS_ALIASED)
        add_library(deps::mbedtls ALIAS ${_MBEDTLS_ALIASED})
      else()
        add_library(deps::mbedtls ALIAS MbedTLS::mbedtls)
      endif()
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("mbedtls" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(mbedtls IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_mbedtls_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libmbedtls-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "mbedtls" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "mbedtls" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_mbedtls_source)
  find_program(MBEDTLS_GIT_EXE git)
  if(NOT MBEDTLS_GIT_EXE)
    return()
  endif()

  set(MBEDTLS_REF "v4.2.0")
  if(CL_REQ_VERSION)
    set(MBEDTLS_REF "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME mbedtls
    DOWNLOAD_ONLY
    REPO https://github.com/Mbed-TLS/mbedtls.git
    REF ${MBEDTLS_REF}
  )

  execute_process(
    COMMAND ${MBEDTLS_GIT_EXE} submodule update --init --recursive
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE MBEDTLS_SUBMODULE_RESULT
  )
  if(NOT MBEDTLS_SUBMODULE_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "mbedtls: git submodule update failed")
  endif()

  # ENABLE_TESTING is a generic name other projects check too, so its prior
  # cache value is restored afterward rather than left forced for the rest
  # of the configure (same leak risk noted for BUILD_SHARED_LIBS in lz4).
  set(_MBEDTLS_PREV_TESTING "${ENABLE_TESTING}")
  set(ENABLE_PROGRAMS OFF CACHE BOOL "" FORCE)
  set(ENABLE_TESTING OFF CACHE BOOL "" FORCE)
  add_subdirectory("${CL_SOURCE_DIR}" "${CL_SOURCE_DIR}-build")
  set(ENABLE_TESTING "${_MBEDTLS_PREV_TESTING}" CACHE BOOL "" FORCE)

  if(TARGET MbedTLS::mbedtls)
    get_target_property(_MBEDTLS_ALIASED MbedTLS::mbedtls ALIASED_TARGET)
    if(_MBEDTLS_ALIASED)
      add_library(deps::mbedtls ALIAS ${_MBEDTLS_ALIASED})
    else()
      add_library(deps::mbedtls ALIAS MbedTLS::mbedtls)
    endif()
  endif()
endfunction()
