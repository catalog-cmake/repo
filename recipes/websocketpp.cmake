function(_recipe_websocketpp_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(websocketpp ${CL_REQ_VERSION} QUIET)
    else()
      find_package(websocketpp QUIET)
    endif()

    if(TARGET websocketpp::websocketpp)
      get_target_property(_WSPP_ALIASED websocketpp::websocketpp ALIASED_TARGET)
      if(_WSPP_ALIASED)
        add_library(deps::websocketpp ALIAS ${_WSPP_ALIASED})
      else()
        add_library(deps::websocketpp ALIAS websocketpp::websocketpp)
      endif()
    endif()
  endif()
endfunction()

function(_recipe_websocketpp_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libwebsocketpp-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "websocketpp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "websocketpp" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_websocketpp_source)
  set(WSPP_TAG "0.8.2")
  if(CL_REQ_VERSION)
    set(WSPP_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME websocketpp
    URL https://github.com/zaphoyd/websocketpp/archive/refs/tags/${WSPP_TAG}.tar.gz
    DOWNLOAD_ONLY
  )
  cl_get_var("SOURCE_DIR" WSPP_SRC_DIR)

  add_library(websocketpp INTERFACE)
  target_include_directories(websocketpp INTERFACE "${WSPP_SRC_DIR}")
  add_library(deps::websocketpp ALIAS websocketpp)
endfunction()
