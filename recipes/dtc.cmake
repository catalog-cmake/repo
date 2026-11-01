function(_recipe_dtc_source)
  set(DTC_REF "dectalk-develop")
  if(CL_REQ_VERSION)
    set(DTC_REF "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME dtc
    REPO https://github.com/dectalk/dectalkmini.git
    REF ${DTC_REF}
    OPTIONS
      "DECTALKMINI_NO_FILESYSTEM" "ON"
      "DECTALKMINI_NO_CHARSET" "ON"
      "DECTALKMINI_EXAMPLES" "OFF"
      "DECTALKMINI_SDL2_EXAMPLE" "OFF"
  )
endfunction()

function(_recipe_dtc_install PREFIX)
  cl_install_files(DESTINATION lib "${CL_SOURCE_BUILD_DIR}/libdtc.a")
  cl_install_files(DESTINATION include/dtc "${CL_SOURCE_DIR}/include/")
endfunction()
