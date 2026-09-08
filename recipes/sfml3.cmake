function(_recipe_SFML3_system)
  set(SFML3_COMPONENTS System Window Graphics Audio Network)

  set(SFML3_FIND_VERSION "3")
  if(CL_REQ_VERSION)
    set(SFML3_FIND_VERSION "${CL_REQ_VERSION}")
  endif()

  if(NOT CMAKE_CROSSCOMPILING)
    find_package(SFML ${SFML3_FIND_VERSION} QUIET COMPONENTS ${SFML3_COMPONENTS})

    if(SFML_FOUND)
      set(SFML3_MODULE_TARGETS "")
      foreach(COMPONENT ${SFML3_COMPONENTS})
        list(APPEND SFML3_MODULE_TARGETS "SFML::${COMPONENT}")
      endforeach()

      add_library(SFML3_bundle INTERFACE)
      target_link_libraries(SFML3_bundle INTERFACE ${SFML3_MODULE_TARGETS})
      add_library(deps::SFML3 ALIAS SFML3_bundle)
      return()
    endif()
  endif()

  set(SFML3_PKG_VERSION_REQ "3.0.0..3.999.999")
  if(CL_VERSION_REQ)
    set(SFML3_PKG_VERSION_REQ "${CL_VERSION_REQ}")
  endif()
  cl_format_pkgconfig_req("sfml-all" "${SFML3_PKG_VERSION_REQ}" PKG_SPEC)

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(SFML3 IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(SFML3 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_SFML3_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "sfml" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "sfml" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SFML3_source)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "")

  cl_add_dep(freetype)
  cl_add_dep(harfbuzz)
  cl_add_dep(libvorbis)
  cl_add_dep(libflac)
  cl_add_dep(miniaudio)

  set(SFML3_TAG "3.1.0")
  if(CL_REQ_VERSION)
    set(SFML3_TAG "${CL_REQ_VERSION}")
  endif()

  set(SFML3_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(SFML3_BUILD_SHARED OFF)
  endif()

  cl_repo_file(patches/sfml3.patch SFML3_PATCH)

  cl_import_source(
    NAME SFML3
    URL https://github.com/SFML/SFML/archive/refs/tags/${SFML3_TAG}.tar.gz
    PATCHES "${SFML3_PATCH}"
    OPTIONS
      "BUILD_SHARED_LIBS" "${SFML3_BUILD_SHARED}"
      "SFML_BUILD_EXAMPLES" "OFF"
      "SFML_BUILD_DOC" "OFF"
      "SFML_BUILD_TEST_SUITE" "OFF"
      "SFML_USE_SYSTEM_DEPS" "TRUE"
  )

  if(TARGET SFML::System AND TARGET SFML::Window AND TARGET SFML::Graphics AND TARGET SFML::Audio AND TARGET SFML::Network)
    add_library(SFML3_bundle INTERFACE)
    target_link_libraries(SFML3_bundle INTERFACE SFML::System SFML::Window SFML::Graphics SFML::Audio SFML::Network)
    add_library(deps::SFML3 ALIAS SFML3_bundle)
  endif()
endfunction()
