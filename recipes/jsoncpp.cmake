function(_recipe_jsoncpp_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(jsoncpp ${CL_REQ_VERSION} QUIET)
    else()
      find_package(jsoncpp QUIET)
    endif()

    if(TARGET jsoncpp_lib)
      add_library(deps::jsoncpp ALIAS jsoncpp_lib)
      return()
    elseif(TARGET JsonCpp::JsonCpp)
      get_target_property(_JSONCPP_ALIASED JsonCpp::JsonCpp ALIASED_TARGET)
      if(_JSONCPP_ALIASED)
        add_library(deps::jsoncpp ALIAS ${_JSONCPP_ALIASED})
      else()
        add_library(deps::jsoncpp ALIAS JsonCpp::JsonCpp)
      endif()
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("jsoncpp" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(jsoncpp IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(jsoncpp IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_jsoncpp_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libjsoncpp-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "jsoncpp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "jsoncpp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "jsoncpp-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_jsoncpp_source)
  set(JSONCPP_TAG "1.9.8")
  if(CL_REQ_VERSION)
    set(JSONCPP_TAG "${CL_REQ_VERSION}")
  endif()

  set(JSONCPP_BUILD_SHARED ON)
  set(JSONCPP_BUILD_STATIC ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(JSONCPP_BUILD_SHARED OFF)
  elseif(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(JSONCPP_BUILD_STATIC OFF)
  endif()

  cl_import_source(
    NAME jsoncpp
    URL https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/${JSONCPP_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${JSONCPP_BUILD_SHARED}"
      "BUILD_STATIC_LIBS" "${JSONCPP_BUILD_STATIC}"
      "BUILD_OBJECT_LIBS" "OFF"
      "JSONCPP_WITH_TESTS" "OFF"
      "JSONCPP_WITH_POST_BUILD_UNITTEST" "OFF"
      "JSONCPP_WITH_EXAMPLE" "OFF"
      "JSONCPP_WITH_INSTALL" "OFF"
  )

  if(TARGET jsoncpp_lib)
    add_library(deps::jsoncpp ALIAS jsoncpp_lib)
  elseif(TARGET jsoncpp_static)
    add_library(deps::jsoncpp ALIAS jsoncpp_static)
  endif()
endfunction()
