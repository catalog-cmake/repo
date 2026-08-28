function(_recipe_plutovg_system)
  if(CL_REQ_VERSION)
    find_package(plutovg ${CL_REQ_VERSION} CONFIG QUIET)
  else()
    find_package(plutovg 1.3.2 CONFIG QUIET) # 1.3.2 fixed a CMake config issue
  endif()
endfunction()

function(_recipe_plutovg_source)
  set(PLUTOVG_TAG "v1.3.3")
  if(CL_REQ_VERSION)
    set(PLUTOVG_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME plutovg
    URL https://github.com/sammycage/plutovg/archive/refs/tags/${PLUTOVG_TAG}.tar.gz
    OPTIONS "PLUTOVG_BUILD_EXAMPLES" "OFF"
  )
endfunction()
