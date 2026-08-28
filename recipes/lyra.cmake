function(_recipe_lyra_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(Lyra ${CL_REQ_VERSION} QUIET)
    else()
      find_package(Lyra QUIET)
    endif()

    if(TARGET bfg::lyra)
      get_target_property(_LYRA_ALIASED bfg::lyra ALIASED_TARGET)
      if(_LYRA_ALIASED)
        add_library(deps::lyra ALIAS ${_LYRA_ALIASED})
      else()
        add_library(deps::lyra ALIAS bfg::lyra)
      endif()
    endif()
  endif()
endfunction()

function(_recipe_lyra_source)
  set(LYRA_TAG "1.8.0")
  if(CL_REQ_VERSION)
    set(LYRA_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME lyra
    URL https://github.com/bfgroup/Lyra/archive/refs/tags/${LYRA_TAG}.tar.gz
    DOWNLOAD_ONLY
  )

  add_library(lyra INTERFACE)
  target_include_directories(lyra INTERFACE ${CL_SOURCE_DIR}/include)
endfunction()
