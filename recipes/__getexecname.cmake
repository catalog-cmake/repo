function(_recipe___getexecname_source)
  cl_import_source(
    NAME __getexecname
    DOWNLOAD_ONLY
    REPO https://github.com/samuelvenable/__getexecname.git
    REF main
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/__getbasepath/internal.cpp")
    _catalog_log(FATAL_ERROR "__getexecname: expected sources not found under ${CL_SOURCE_DIR}")
  endif()

  add_library(__getexecname STATIC "${CL_SOURCE_DIR}/__getbasepath/internal.cpp")
  target_include_directories(__getexecname PUBLIC $<BUILD_INTERFACE:${CL_SOURCE_DIR}>)

  if(CMAKE_SYSTEM_NAME STREQUAL "OpenBSD")
    target_link_libraries(__getexecname PUBLIC kvm)
  elseif(CMAKE_SYSTEM_NAME STREQUAL "SunOS")
    target_link_libraries(__getexecname PUBLIC proc)
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Haiku")
    target_link_libraries(__getexecname PUBLIC haiku)
  endif()
endfunction()
