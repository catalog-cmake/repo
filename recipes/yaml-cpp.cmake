function(_recipe_yaml-cpp_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(yaml-cpp ${CL_REQ_VERSION} QUIET)
    else()
      find_package(yaml-cpp QUIET)
    endif()
  endif()

  if(NOT TARGET yaml-cpp AND NOT TARGET yaml-cpp::yaml-cpp)
    cl_format_pkgconfig_req("yaml-cpp" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      if(CL_STATIC)
        pkg_check_modules(yaml-cpp IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
      else()
        pkg_check_modules(yaml-cpp IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_yaml-cpp_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libyaml-cpp-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "yaml-cpp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "yaml-cpp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "yaml-cpp-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_yaml-cpp_source)
  set(YAMLCPP_TAG "yaml-cpp-0.9.0")
  if(CL_REQ_VERSION)
    set(YAMLCPP_TAG "yaml-cpp-${CL_REQ_VERSION}")
  endif()

  set(YAMLCPP_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(YAMLCPP_BUILD_SHARED OFF)
  endif()

  cl_import_source(
    NAME yaml-cpp
    URL https://github.com/jbeder/yaml-cpp/archive/refs/tags/${YAMLCPP_TAG}.tar.gz
    OPTIONS
      "YAML_BUILD_SHARED_LIBS" "${YAMLCPP_BUILD_SHARED}"
      "YAML_CPP_BUILD_TESTS" "OFF"
      "YAML_CPP_BUILD_TOOLS" "OFF"
      "YAML_CPP_BUILD_CONTRIB" "OFF"
      "YAML_CPP_INSTALL" "OFF"
  )
endfunction()
