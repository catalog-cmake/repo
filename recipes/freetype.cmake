function(_recipe_freetype_system)
  cl_format_pkgconfig_req("freetype2" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(freetype IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(Freetype ${CL_REQ_VERSION} QUIET)
      else()
        find_package(Freetype QUIET)
      endif()
      if(TARGET Freetype::Freetype AND NOT TARGET freetype)
        add_library(deps::freetype ALIAS Freetype::Freetype)
        return()
      endif()
    endif()

    if(NOT TARGET freetype)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(freetype IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_freetype_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libfreetype-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "freetype2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "freetype" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "freetype-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "freetype-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "freetype2-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_freetype_source)
  set(FREETYPE_TAG "VER-2-14-3")
  if(CL_REQ_VERSION)
    string(REPLACE "." "-" FT_TAG_VER "${CL_REQ_VERSION}")
    set(FREETYPE_TAG "VER-${FT_TAG_VER}")
  endif()

  cl_import_source(
    NAME freetype
    URL https://github.com/freetype/freetype/archive/refs/tags/${FREETYPE_TAG}.tar.gz
    OPTIONS
      "FT_DISABLE_ZLIB" "OFF"
      "FT_DISABLE_BZIP2" "ON"
      "FT_DISABLE_PNG" "ON"
      "FT_DISABLE_HARFBUZZ" "ON"
      "FT_DISABLE_BROTLI" "ON"
  )
endfunction()
