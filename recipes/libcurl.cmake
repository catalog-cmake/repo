function(_recipe_libcurl_toolchain)
  if(DEFINED NINTENDO_WIIU AND DEFINED DEVKITPRO)
		add_library(libcurl INTERFACE)
		target_link_libraries(libcurl INTERFACE curl mbedtls mbedx509 mbedcrypto z wut m)
		target_include_directories(libcurl INTERFACE "${DEVKITPRO}/portlibs/wiiu/include")
	endif()
endfunction()

function(_recipe_libcurl_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(CURL ${CL_REQ_VERSION} QUIET)
    else()
      find_package(CURL QUIET)
    endif()

    if(TARGET CURL::libcurl)
      get_target_property(IS_ALIAS CURL::libcurl ALIASED_TARGET)
      if(IS_ALIAS)
        add_library(deps::libcurl ALIAS ${IS_ALIAS})
      else()
        add_library(deps::libcurl ALIAS CURL::libcurl)
      endif()
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("libcurl" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(libcurl IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(libcurl IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_libcurl_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libcurl4-openssl-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "curl" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "curl" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "libcurl-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "curl-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libcurl-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_libcurl_source)
  set(CURL_TAG "curl-8_21_0")
  if(CL_REQ_VERSION)
    string(REPLACE "." "_" CURL_TAG_VER "${CL_REQ_VERSION}")
    set(CURL_TAG "curl-${CURL_TAG_VER}")
  endif()

  set(CURL_BUILD_SHARED ON)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(CURL_BUILD_SHARED OFF)
  endif()

  cl_repo_file(patches/libcurl.patch LIBCURL_PATCH)

  cl_import_source(
    NAME libcurl
    URL https://github.com/curl/curl/archive/refs/tags/${CURL_TAG}.tar.gz
    PATCHES "${LIBCURL_PATCH}"
    OPTIONS
      "BUILD_SHARED_LIBS" "${CURL_BUILD_SHARED}"
      "BUILD_CURL_EXE" "OFF"
      "BUILD_TESTING" "OFF"
      "BUILD_EXAMPLES" "OFF"
      "CURL_DISABLE_INSTALL" "ON"
      "CURL_ENABLE_SSL" "OFF"
      "ENABLE_ARES" "OFF"
      "CURL_USE_LIBSSH2" "OFF"
      "CURL_USE_LIBPSL" "OFF"
  )

  if(TARGET CURL::libcurl)
    set(_LIBCURL_RESOLVED CURL::libcurl)
    get_target_property(_LIBCURL_ALIASED ${_LIBCURL_RESOLVED} ALIASED_TARGET)
    while(_LIBCURL_ALIASED)
      set(_LIBCURL_RESOLVED ${_LIBCURL_ALIASED})
      get_target_property(_LIBCURL_ALIASED ${_LIBCURL_RESOLVED} ALIASED_TARGET)
    endwhile()
    add_library(deps::libcurl ALIAS ${_LIBCURL_RESOLVED})
  endif()
endfunction()
