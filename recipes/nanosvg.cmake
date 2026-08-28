function(_recipe_nanosvg_system)
  find_package(NanoSVG CONFIG QUIET)
  if(TARGET nanosvg)
    return()
  endif()
endfunction()

function(_recipe_nanosvg_source)
  set(NANOSVG_TAG "master")
  if(CL_REQ_VERSION)
    set(NANOSVG_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME nanosvg
    URL https://github.com/memononen/nanosvg/archive/${NANOSVG_TAG}.tar.gz
  )
endfunction()
