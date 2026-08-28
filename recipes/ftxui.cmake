function(_recipe_ftxui_system)
  find_package(ftxui CONFIG QUIET)
endfunction()

function(_recipe_ftxui_source)
  set(FTXUI_TAG "v7.0.3")
  if(CL_REQ_VERSION)
    set(FTXUI_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME ftxui
    URL https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/${FTXUI_TAG}.tar.gz
    OPTIONS
      "FTXUI_BUILD_EXAMPLES" "OFF"
      "FTXUI_BUILD_DOCS" "OFF"
      "FTXUI_BUILD_TESTS" "OFF"
      "FTXUI_ENABLE_INSTALL" "OFF"
  )
endfunction()
