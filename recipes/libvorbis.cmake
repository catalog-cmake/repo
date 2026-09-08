function(_recipe_libvorbis_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(Vorbis ${CL_REQ_VERSION} QUIET)
    else()
      find_package(Vorbis QUIET)
    endif()

    if(TARGET Vorbis::vorbis AND TARGET Vorbis::vorbisenc AND TARGET Vorbis::vorbisfile)
      add_library(_libvorbis_system INTERFACE)
      target_link_libraries(_libvorbis_system INTERFACE Vorbis::vorbis Vorbis::vorbisenc Vorbis::vorbisfile)
      add_library(deps::libvorbis ALIAS _libvorbis_system)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("vorbis" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libvorbis IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC} "vorbisenc" "vorbisfile")
    else()
      pkg_check_modules(libvorbis IMPORTED_TARGET GLOBAL ${PKG_SPEC} "vorbisenc" "vorbisfile")
    endif()
  endif()
endfunction()

function(_recipe_libvorbis_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libvorbis-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libvorbis" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "libvorbis" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libvorbis-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "libvorbis-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libvorbis-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libvorbis_source)
  cl_add_dep(libogg)

  set(LIBVORBIS_TAG "v1.3.7")
  if(CL_REQ_VERSION)
    set(LIBVORBIS_TAG "v${CL_REQ_VERSION}")
  endif()

  set(LIBVORBIS_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(LIBVORBIS_BUILD_SHARED OFF)
  endif()

  cl_repo_file(patches/libvorbis.patch LIBVORBIS_PATCH)

  cl_import_source(
    NAME libvorbis
    URL https://github.com/xiph/vorbis/archive/refs/tags/${LIBVORBIS_TAG}.tar.gz
    PATCHES "${LIBVORBIS_PATCH}"
    OPTIONS
      "BUILD_SHARED_LIBS" "${LIBVORBIS_BUILD_SHARED}"
      "INSTALL_CMAKE_PACKAGE_MODULE" "OFF"
  )

  if(TARGET vorbis AND TARGET vorbisenc AND TARGET vorbisfile)
    add_library(_libvorbis_bundle INTERFACE)
    target_link_libraries(_libvorbis_bundle INTERFACE vorbis vorbisenc vorbisfile)
    add_library(deps::libvorbis ALIAS _libvorbis_bundle)
  endif()
endfunction()
