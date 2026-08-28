function(_recipe_libwebp_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(WebP ${CL_REQ_VERSION} CONFIG QUIET)
    else()
      find_package(WebP CONFIG QUIET)
    endif()
    if(TARGET WebP::webp)
      add_library(deps::libwebp ALIAS WebP::webp)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libwebp" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libwebp IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libwebp IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libwebp_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libwebp-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "libwebp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "webp" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libwebp-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "libwebp-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libwebp_source)
  set(LIBWEBP_TAG "v1.6.0")
  if(CL_REQ_VERSION)
    set(LIBWEBP_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME libwebp
    URL https://github.com/webmproject/libwebp/archive/refs/tags/${LIBWEBP_TAG}.tar.gz
    OPTIONS
      "WEBP_BUILD_ANIM_UTILS" "OFF"
      "WEBP_BUILD_CWEBP" "OFF"
      "WEBP_BUILD_DWEBP" "OFF"
      "WEBP_BUILD_GIF2WEBP" "OFF"
      "WEBP_BUILD_IMG2WEBP" "OFF"
      "WEBP_BUILD_VWEBP" "OFF"
      "WEBP_BUILD_WEBPINFO" "OFF"
      "WEBP_BUILD_WEBPMUX" "OFF"
      "WEBP_BUILD_EXTRAS" "OFF"
  )

  if(TARGET webp)
    add_library(deps::libwebp ALIAS webp)
  endif()
endfunction()
