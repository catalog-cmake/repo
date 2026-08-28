function(_recipe_cjson_system)
  find_package(cJSON CONFIG QUIET)
  if(TARGET cjson)
    return()
  endif()

  cl_format_pkgconfig_req("libcjson" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(cjson IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(cjson IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_cjson_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libcjson-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "cjson" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "cjson" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "cjson-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_cjson_source)
  set(CJSON_BUILD_SHARED "ON")
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(CJSON_BUILD_SHARED "OFF")
  endif()

  set(CJSON_TAG "v1.7.19")
  if(CL_REQ_VERSION)
    set(CJSON_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME cjson
    URL https://github.com/DaveGamble/cJSON/archive/refs/tags/${CJSON_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${CJSON_BUILD_SHARED}"
      "ENABLE_CJSON_TEST" "OFF"
      "ENABLE_CJSON_UTILS" "OFF"
      "ENABLE_TARGET_EXPORT" "OFF"
  )
endfunction()
