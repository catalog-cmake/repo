function(_recipe_simdjson_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(simdjson ${CL_REQ_VERSION} CONFIG QUIET)
    else()
      find_package(simdjson CONFIG QUIET)
    endif()
  endif()
endfunction()

function(_recipe_simdjson_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsimdjson-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "simdjson" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "simdjson" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_simdjson_source)
  set(SIMDJSON_TAG "v4.6.10")
  if(CL_REQ_VERSION)
    set(SIMDJSON_TAG "v${CL_REQ_VERSION}")
  endif()

  set(SIMDJSON_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(SIMDJSON_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME simdjson
    URL https://github.com/simdjson/simdjson/archive/refs/tags/${SIMDJSON_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${SIMDJSON_BUILD_SHARED}"
      "SIMDJSON_DEVELOPER_MODE" "OFF"
      "SIMDJSON_INSTALL" "OFF"
  )
endfunction()
