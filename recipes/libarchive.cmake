function(_recipe_libarchive_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(LibArchive ${CL_REQ_VERSION} QUIET)
    else()
      find_package(LibArchive QUIET)
    endif()

    if(TARGET LibArchive::LibArchive)
      add_library(deps::libarchive ALIAS LibArchive::LibArchive)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libarchive" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libarchive IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libarchive IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libarchive_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libarchive-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libarchive" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "libarchive" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libarchive-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "libarchive-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libarchive_source)
  cl_add_dep(zlib)
  cl_add_dep(bzip2)
  cl_add_dep(xz)
  cl_add_dep(zstd)
  cl_add_dep(lz4)

  set(LIBARCHIVE_TAG "v3.8.9")
  if(CL_REQ_VERSION)
    set(LIBARCHIVE_TAG "v${CL_REQ_VERSION}")
  endif()

  set(LIBARCHIVE_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(LIBARCHIVE_BUILD_SHARED OFF)
  endif()

  cl_repo_file(patches/libarchive.patch LIBARCHIVE_PATCH)

  cl_import_source(
    NAME libarchive
    URL https://github.com/libarchive/libarchive/archive/refs/tags/${LIBARCHIVE_TAG}.tar.gz
    PATCHES "${LIBARCHIVE_PATCH}"
    OPTIONS
      "BUILD_SHARED_LIBS" "${LIBARCHIVE_BUILD_SHARED}"
      "ENABLE_TEST" "OFF"
      "ENABLE_COVERAGE" "OFF"
      "ENABLE_WERROR" "OFF"
      "ENABLE_TAR" "OFF"
      "ENABLE_CPIO" "OFF"
      "ENABLE_CAT" "OFF"
      "ENABLE_UNZIP" "OFF"
      "ENABLE_ZLIB" "ON"
      "ENABLE_BZip2" "ON"
      "ENABLE_LZO" "OFF"
      "ENABLE_LZMA" "ON"
      "ENABLE_ZSTD" "ON"
      "ENABLE_LZ4" "ON"
      "ENABLE_LIBB2" "OFF"
      "ENABLE_LIBXML2" "OFF"
      "ENABLE_EXPAT" "OFF"
      "ENABLE_PCREPOSIX" "OFF"
      "ENABLE_PCRE2POSIX" "OFF"
      "ENABLE_OPENSSL" "OFF"
      "ENABLE_MBEDTLS" "OFF"
      "ENABLE_NETTLE" "OFF"
      "ENABLE_CNG" "OFF"
  )

  if(CL_STATIC AND TARGET archive_static)
    add_library(deps::libarchive ALIAS archive_static)
  elseif(TARGET archive)
    add_library(deps::libarchive ALIAS archive)
  elseif(TARGET archive_static)
    add_library(deps::libarchive ALIAS archive_static)
  endif()
endfunction()
