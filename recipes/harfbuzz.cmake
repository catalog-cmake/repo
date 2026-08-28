function(_recipe_harfbuzz_system)
  cl_format_pkgconfig_req("harfbuzz" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(harfbuzz IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(harfbuzz ${CL_REQ_VERSION} QUIET)
      else()
        find_package(harfbuzz QUIET)
      endif()
    endif()

    if(NOT TARGET harfbuzz AND NOT TARGET harfbuzz::harfbuzz)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(harfbuzz IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_harfbuzz_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libharfbuzz-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "harfbuzz" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "harfbuzz" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "harfbuzz-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "harfbuzz-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "harfbuzz-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_harfbuzz_source)
  set(HARFBUZZ_TAG "14.4.0")
  if(CL_REQ_VERSION)
    set(HARFBUZZ_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME harfbuzz
    URL https://github.com/harfbuzz/harfbuzz/archive/refs/tags/${HARFBUZZ_TAG}.tar.gz
    OPTIONS
      "HB_BUILD_UTILS" "OFF"
      "HB_HAVE_FREETYPE" "OFF"
      "HB_HAVE_CAIRO" "OFF"
      "HB_HAVE_GLIB" "OFF"
      "HB_HAVE_ICU" "OFF"
  )
endfunction()
