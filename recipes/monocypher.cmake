function(_recipe_monocypher_system)
  cl_format_pkgconfig_req("monocypher" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    pkg_check_modules(monocypher IMPORTED_TARGET GLOBAL ${PKG_SPEC})
  endif()
endfunction()

function(_recipe_monocypher_source)
  set(MONOCYPHER_TAG "4.0.2")
  if(CL_REQ_VERSION)
    set(MONOCYPHER_TAG "${CL_REQ_VERSION}")
  endif()
  cl_set_version("${MONOCYPHER_TAG}")

  cl_import_source(
    NAME monocypher
    DOWNLOAD_ONLY
    REPO https://github.com/LoupVaillant/Monocypher.git
    REF ${MONOCYPHER_TAG}
  )
  if(CL_INSTALL_PREFIX)
    return()
  endif()

  if(NOT EXISTS "${CL_SOURCE_DIR}/src/monocypher.c")
    _catalog_log(FATAL_ERROR "monocypher: expected sources not found under ${CL_SOURCE_DIR}")
  endif()

  set(MONOCYPHER_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(MONOCYPHER_SHARED ON)
  endif()

  if(MONOCYPHER_SHARED)
    add_library(monocypher SHARED
      "${CL_SOURCE_DIR}/src/monocypher.c"
      "${CL_SOURCE_DIR}/src/optional/monocypher-ed25519.c"
    )
  else()
    add_library(monocypher STATIC
      "${CL_SOURCE_DIR}/src/monocypher.c"
      "${CL_SOURCE_DIR}/src/optional/monocypher-ed25519.c"
    )
  endif()
  target_include_directories(monocypher PUBLIC
    $<BUILD_INTERFACE:${CL_SOURCE_DIR}/src>
    $<BUILD_INTERFACE:${CL_SOURCE_DIR}/src/optional>
  )
  set_target_properties(monocypher PROPERTIES C_STANDARD 99 POSITION_INDEPENDENT_CODE ON)
endfunction()

function(_recipe_monocypher_latest)
  set(MONOCYPHER_TAG "4.0.2")
  if(CL_REQ_VERSION)
    set(MONOCYPHER_TAG "${CL_REQ_VERSION}")
  endif()
  cl_set_version("${MONOCYPHER_TAG}")
endfunction()

function(_recipe_monocypher_install PREFIX)
  cl_repo_file(install/project.cmake PROJECT_HELPER)
  include("${PROJECT_HELPER}")
  repo_install_project(monocypher "${PREFIX}")
endfunction()
