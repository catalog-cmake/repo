function(_recipe_SFML2_system)
  set(SFML2_COMPONENTS system window graphics audio network)

  set(SFML2_FIND_VERSION "2")
  if(CL_REQ_VERSION)
    set(SFML2_FIND_VERSION "${CL_REQ_VERSION}")
  endif()

  if(NOT CMAKE_CROSSCOMPILING)
    find_package(SFML ${SFML2_FIND_VERSION} QUIET COMPONENTS ${SFML2_COMPONENTS})

    if(SFML_FOUND)
      set(SFML2_MODULE_TARGETS "")
      foreach(COMPONENT ${SFML2_COMPONENTS})
        list(APPEND SFML2_MODULE_TARGETS "sfml-${COMPONENT}")
      endforeach()

      add_library(SFML2_bundle INTERFACE)
      target_link_libraries(SFML2_bundle INTERFACE ${SFML2_MODULE_TARGETS})
      add_library(deps::SFML2 ALIAS SFML2_bundle)
      return()
    endif()
  endif()

  set(SFML2_PKG_VERSION_REQ "2.0.0..2.999.999")
  if(CL_VERSION_REQ)
    set(SFML2_PKG_VERSION_REQ "${CL_VERSION_REQ}")
  endif()
  cl_format_pkgconfig_req("sfml-all" "${SFML2_PKG_VERSION_REQ}" PKG_SPEC)

  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(SFML2 IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(SFML2 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_SFML2_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libsfml-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "sfml-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "sfml@2" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_SFML2_source)
  # SFML only vendors its dependencies (freetype, openal, vorbis, flac) as
  # prebuilt binaries for Windows/macOS/iOS/Android - on Linux it always
  # calls find_package()/find_library() for them. Build them from source too
  # and patch SFML's CMakeLists.txt (see patches/sfml2.patch) to prefer our
  # in-tree targets over its own find_package()/sfml_find_package() calls.
  # The window backend (X11/Xrandr/Xcursor/udev/OpenGL) is still resolved
  # against the system, same as SDL2's window backend.
  #
  # SFML2 is built as a shared library by default, so any of these that
  # get built from source need PIC objects to link into it - a CACHE var
  # since cl_add_dep resolves each one in its own function scope.
  set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "")

  cl_add_dep(freetype)
  cl_add_dep(openal)
  cl_add_dep(libvorbis)
  cl_add_dep(libflac)

  set(SFML2_TAG "2.6.2")
  if(CL_REQ_VERSION)
    set(SFML2_TAG "${CL_REQ_VERSION}")
  endif()

  set(SFML2_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(SFML2_BUILD_SHARED OFF)
  endif()

  cl_repo_file(patches/sfml2.patch SFML2_PATCH)

  cl_import_source(
    NAME SFML2
    URL https://github.com/SFML/SFML/archive/refs/tags/${SFML2_TAG}.tar.gz
    PATCHES "${SFML2_PATCH}"
    OPTIONS
      "BUILD_SHARED_LIBS" "${SFML2_BUILD_SHARED}"
      "SFML_BUILD_EXAMPLES" "OFF"
      "SFML_BUILD_DOC" "OFF"
      "SFML_BUILD_TEST_SUITE" "OFF"
      "SFML_USE_SYSTEM_DEPS" "TRUE"
  )

  if(TARGET sfml-system AND TARGET sfml-window AND TARGET sfml-graphics AND TARGET sfml-audio AND TARGET sfml-network)
    add_library(SFML2_bundle INTERFACE)
    target_link_libraries(SFML2_bundle INTERFACE sfml-system sfml-window sfml-graphics sfml-audio sfml-network)
    add_library(deps::SFML2 ALIAS SFML2_bundle)
  endif()
endfunction()
