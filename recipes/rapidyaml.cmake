function(_recipe_rapidyaml_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(ryml ${CL_REQ_VERSION} QUIET)
    else()
      find_package(ryml QUIET)
    endif()

    if(TARGET ryml::ryml)
      add_library(deps::rapidyaml ALIAS ryml::ryml)
      return()
    endif()
  endif()
endfunction()

function(_recipe_rapidyaml_source)
  set(RYML_TAG "v0.16.0")
  if(CL_REQ_VERSION)
    set(RYML_TAG "v${CL_REQ_VERSION}")
  endif()

  set(RYML_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(RYML_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME rapidyaml
    URL https://github.com/biojppm/rapidyaml/archive/refs/tags/${RYML_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${RYML_BUILD_SHARED}"
      "RYML_BUILD_TESTS" "OFF"
      "RYML_BUILD_BENCHMARKS" "OFF"
      "RYML_BUILD_TOOLS" "OFF"
      "RYML_SYSTEM_C4CORE" "OFF"
  )

  if(TARGET ryml::ryml)
    get_target_property(_RYML_ALIASED ryml::ryml ALIASED_TARGET)
    if(_RYML_ALIASED)
      add_library(deps::rapidyaml ALIAS ${_RYML_ALIASED})
    else()
      add_library(deps::rapidyaml ALIAS ryml::ryml)
    endif()
  elseif(TARGET ryml)
    add_library(deps::rapidyaml ALIAS ryml)
  endif()
endfunction()
