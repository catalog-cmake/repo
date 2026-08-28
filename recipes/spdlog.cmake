function(_recipe_spdlog_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(spdlog ${CL_REQ_VERSION} QUIET)
    else()
      find_package(spdlog QUIET)
    endif()
  endif()

  if(NOT TARGET spdlog AND NOT TARGET spdlog::spdlog)
    cl_format_pkgconfig_req("spdlog" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      if(CL_STATIC)
        pkg_check_modules(spdlog IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
      else()
        pkg_check_modules(spdlog IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_spdlog_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libspdlog-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "spdlog" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "spdlog" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_spdlog_source)
  set(SPDLOG_TAG "v1.17.0")
  if(CL_REQ_VERSION)
    set(SPDLOG_TAG "v${CL_REQ_VERSION}")
  endif()

  set(SPDLOG_BUILD_SHARED OFF)
  if(CL_REQ_TYPE STREQUAL "SHARED" OR CL_REQ_TYPE STREQUAL "PREFER_SHARED")
    set(SPDLOG_BUILD_SHARED ON)
  endif()

  cl_import_source(
    NAME spdlog
    URL https://github.com/gabime/spdlog/archive/refs/tags/${SPDLOG_TAG}.tar.gz
    OPTIONS "SPDLOG_BUILD_SHARED" "${SPDLOG_BUILD_SHARED}" "SPDLOG_BUILD_EXAMPLE" "OFF" "SPDLOG_BUILD_TESTS" "OFF"
  )
endfunction()
