function(_recipe_rapidjson_system)
  find_package(RapidJSON CONFIG QUIET)
  if(TARGET rapidjson AND NOT TARGET deps::rapidjson)
    return()
  endif()
  if(RapidJSON_FOUND AND NOT TARGET deps::rapidjson)
    add_library(_rapidjson_system INTERFACE)
    if(DEFINED RapidJSON_INCLUDE_DIRS)
      target_include_directories(_rapidjson_system INTERFACE "${RapidJSON_INCLUDE_DIRS}")
    endif()
    add_library(deps::rapidjson ALIAS _rapidjson_system)
  endif()
endfunction()

function(_recipe_rapidjson_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "rapidjson-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "rapidjson" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "rapidjson" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_rapidjson_source)
  set(RAPIDJSON_TAG "v1.1.0")
  if(CL_REQ_VERSION)
    set(RAPIDJSON_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_repo_file(patches/rapidjson.patch RAPIDJSON_PATCH)

  cl_import_source(
    NAME rapidjson
    DOWNLOAD_ONLY
    URL https://github.com/Tencent/rapidjson/archive/refs/tags/${RAPIDJSON_TAG}.tar.gz
    PATCHES "${RAPIDJSON_PATCH}"
  )

  if(NOT EXISTS "${CL_SOURCE_DIR}/include/rapidjson/rapidjson.h")
    _catalog_log(FATAL_ERROR "rapidjson: rapidjson.h not found under ${CL_SOURCE_DIR}/include")
  endif()

  add_library(RapidJSON INTERFACE)
  target_include_directories(RapidJSON INTERFACE $<BUILD_INTERFACE:${CL_SOURCE_DIR}/include>)

  if(TARGET RapidJSON AND NOT TARGET deps::rapidjson)
    add_library(deps::rapidjson ALIAS RapidJSON)
  endif()
endfunction()
