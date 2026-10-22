# Fixes behavior for custom versions
function(_recipe_llama_cpp_probe OUT_FOUND OUT_BUILD OUT_SHARED)
  set(PROBE_DIR "${CMAKE_CURRENT_BINARY_DIR}/_catalog_probe/llama")
  file(MAKE_DIRECTORY "${PROBE_DIR}")
  file(WRITE "${PROBE_DIR}/CMakeLists.txt" [=[
find_package(llama CONFIG QUIET)
if(llama_FOUND)
  set(CL_LLAMA_PROBE_FOUND TRUE PARENT_SCOPE)
  set(CL_LLAMA_PROBE_BUILD "${LLAMA_BUILD_NUMBER}" PARENT_SCOPE)
  set(CL_LLAMA_PROBE_SHARED "${LLAMA_SHARED_LIB}" PARENT_SCOPE)
endif()
]=])

  set(CL_LLAMA_PROBE_FOUND FALSE)
  set(CL_LLAMA_PROBE_BUILD "")
  set(CL_LLAMA_PROBE_SHARED "")
  add_subdirectory("${PROBE_DIR}" "${PROBE_DIR}/build")

  set(${OUT_FOUND} "${CL_LLAMA_PROBE_FOUND}" PARENT_SCOPE)
  set(${OUT_BUILD} "${CL_LLAMA_PROBE_BUILD}" PARENT_SCOPE)
  set(${OUT_SHARED} "${CL_LLAMA_PROBE_SHARED}" PARENT_SCOPE)
endfunction()

function(_recipe_llama-cpp_system)
  if(NOT CMAKE_CROSSCOMPILING)
    _recipe_llama_cpp_probe(LLAMA_SYS_FOUND LLAMA_SYS_BUILD LLAMA_SYS_SHARED)

    if(LLAMA_SYS_FOUND)
      set(LLAMA_SYS_OK TRUE)

      if(CL_VERSION_REQ)
        if(LLAMA_SYS_BUILD MATCHES "^[0-9]+$" AND LLAMA_SYS_BUILD GREATER 0)
          _catalog_version_satisfies("${LLAMA_SYS_BUILD}" "${CL_VERSION_REQ}" LLAMA_SYS_OK)
        else()
          set(LLAMA_SYS_OK FALSE)
        endif()
      endif()

      if(NOT "${LLAMA_SYS_SHARED}" STREQUAL "")
        if(CL_REQUIRE_STATIC AND LLAMA_SYS_SHARED)
          set(LLAMA_SYS_OK FALSE)
        elseif(CL_REQUIRE_SHARED AND NOT LLAMA_SYS_SHARED)
          set(LLAMA_SYS_OK FALSE)
        endif()
      endif()

      if(LLAMA_SYS_OK)
        find_package(llama CONFIG QUIET)
        if(TARGET llama)
          add_library(deps::llama-cpp ALIAS llama)
        endif()
      endif()
      return()
    endif()
  endif()

  if(NOT CL_VERSION_REQ AND NOT CL_REQUIRE_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(llama IMPORTED_TARGET GLOBAL llama)
      if(TARGET PkgConfig::llama)
        add_library(deps::llama-cpp ALIAS PkgConfig::llama)
      endif()
    endif()
  endif()
endfunction()

function(_recipe_llama-cpp_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "llama-cpp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "llama.cpp" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_llama-cpp_source)
  set(LLAMA_BUILD "11804")
  if(CL_REQ_VERSION)
    set(LLAMA_BUILD "${CL_REQ_VERSION}")
  elseif(CL_VERSION_REQ MATCHES "^=?b([0-9]+)$")
    set(LLAMA_BUILD "${CMAKE_MATCH_1}")
  endif()

  set(LLAMA_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(LLAMA_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME llama-cpp
    URL https://github.com/ggml-org/llama.cpp/archive/refs/tags/b${LLAMA_BUILD}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${LLAMA_BUILD_SHARED}"
      "LLAMA_BUILD_COMMON" "OFF"
      "LLAMA_BUILD_TESTS" "OFF"
      "LLAMA_BUILD_TOOLS" "OFF"
      "LLAMA_BUILD_EXAMPLES" "OFF"
      "LLAMA_BUILD_SERVER" "OFF"
      "LLAMA_BUILD_APP" "OFF"
      "GGML_BUILD_TESTS" "OFF"
      "GGML_BUILD_EXAMPLES" "OFF"
      "LLAMA_BUILD_NUMBER" "${LLAMA_BUILD}"
      "LLAMA_BUILD_COMMIT" "b${LLAMA_BUILD}"
  )

  if(TARGET llama)
    add_library(deps::llama-cpp ALIAS llama)
  endif()
endfunction()
