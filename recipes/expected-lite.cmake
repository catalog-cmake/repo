function(_recipe_expected-lite_system)
  find_package(expected-lite CONFIG QUIET)
  if(TARGET nonstd::expected-lite)
    get_target_property(_EXPLITE_ALIASED nonstd::expected-lite ALIASED_TARGET)
    if(_EXPLITE_ALIASED)
      add_library(deps::expected-lite ALIAS ${_EXPLITE_ALIASED})
    else()
      add_library(deps::expected-lite ALIAS nonstd::expected-lite)
    endif()
  endif()
endfunction()

function(_recipe_expected-lite_source)
  set(EXPLITE_TAG "v0.10.0")
  if(CL_REQ_VERSION)
    set(EXPLITE_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME expected-lite
    URL https://github.com/nonstd-lite/expected-lite/archive/refs/tags/${EXPLITE_TAG}.tar.gz
  )

  if(TARGET nonstd::expected-lite)
    get_target_property(_EXPLITE_ALIASED nonstd::expected-lite ALIASED_TARGET)
    if(_EXPLITE_ALIASED)
      add_library(deps::expected-lite ALIAS ${_EXPLITE_ALIASED})
    else()
      add_library(deps::expected-lite ALIAS nonstd::expected-lite)
    endif()
  endif()
endfunction()
