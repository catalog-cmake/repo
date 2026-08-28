function(_recipe_openal_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(OpenAL ${CL_REQ_VERSION} QUIET)
    else()
      find_package(OpenAL QUIET)
    endif()
    # CMake's bundled FindOpenAL only sets variables, not a target - wrap it.
    if(OPENAL_FOUND AND NOT TARGET deps::openal)
      add_library(_openal_system INTERFACE)
      target_include_directories(_openal_system INTERFACE "${OPENAL_INCLUDE_DIR}")
      target_link_libraries(_openal_system INTERFACE "${OPENAL_LIBRARY}")
      add_library(deps::openal ALIAS _openal_system)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("openal" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(openal IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(openal IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_openal_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libopenal-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "openal" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "openal-soft" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "openal-soft-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "openal-soft-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "openal-soft-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_openal_source)
  set(OPENAL_LIBTYPE "SHARED")
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(OPENAL_LIBTYPE "STATIC")
  endif()

  set(OPENAL_TAG "1.25.2")
  if(CL_REQ_VERSION)
    set(OPENAL_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME openal
    URL https://github.com/kcat/openal-soft/archive/refs/tags/${OPENAL_TAG}.tar.gz
    OPTIONS
      "LIBTYPE" "${OPENAL_LIBTYPE}"
      "ALSOFT_UTILS" "OFF"
      "ALSOFT_EXAMPLES" "OFF"
      "ALSOFT_TESTS" "OFF"
      "ALSOFT_INSTALL" "OFF"
  )

  if(TARGET OpenAL::OpenAL AND NOT TARGET deps::openal)
    get_target_property(_OPENAL_REAL_TARGET OpenAL::OpenAL ALIASED_TARGET)
    if(_OPENAL_REAL_TARGET)
      add_library(deps::openal ALIAS ${_OPENAL_REAL_TARGET})
    else()
      add_library(deps::openal ALIAS OpenAL::OpenAL)
    endif()
  elseif(TARGET OpenAL AND NOT TARGET deps::openal)
    add_library(deps::openal ALIAS OpenAL)
  endif()
endfunction()
