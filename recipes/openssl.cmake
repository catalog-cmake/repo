function(_recipe_openssl_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(OpenSSL ${CL_REQ_VERSION} QUIET)
    else()
      find_package(OpenSSL QUIET)
    endif()

    if(TARGET OpenSSL::SSL AND TARGET OpenSSL::Crypto)
      add_library(_deps_openssl_combined INTERFACE)
      target_link_libraries(_deps_openssl_combined INTERFACE OpenSSL::SSL OpenSSL::Crypto)
      add_library(deps::openssl ALIAS _deps_openssl_combined)
      return()
    endif()
  endif()

  cl_format_pkgconfig_req("openssl" "${CL_VERSION_REQ}" PKG_SPEC)
  find_package(PkgConfig QUIET)
  if(PkgConfig_FOUND)
    if(CL_STATIC)
      pkg_check_modules(openssl IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
    else()
      pkg_check_modules(openssl IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_openssl_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libssl-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "openssl" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "openssl@3" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "openssl-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "openssl-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libopenssl-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_openssl_source)
  if(WIN32)
    return()
  endif()

  find_program(OPENSSL_MAKE_EXE make)
  find_program(OPENSSL_PERL_EXE perl)
  if(NOT OPENSSL_MAKE_EXE OR NOT OPENSSL_PERL_EXE)
    return()
  endif()

  set(OPENSSL_TAG "openssl-3.6.4")
  if(CL_REQ_VERSION)
    set(OPENSSL_TAG "openssl-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME openssl
    DOWNLOAD_ONLY
    URL https://github.com/openssl/openssl/archive/refs/tags/${OPENSSL_TAG}.tar.gz
  )

  set(OPENSSL_PREFIX "${CL_SOURCE_DIR}-install")
  set(OPENSSL_CONFIG_ARGS --prefix=${OPENSSL_PREFIX} --openssldir=${OPENSSL_PREFIX}/ssl no-tests)
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    list(APPEND OPENSSL_CONFIG_ARGS no-shared)
  endif()

  execute_process(
    COMMAND ${OPENSSL_PERL_EXE} ./Configure ${OPENSSL_CONFIG_ARGS}
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE OPENSSL_CONFIGURE_RESULT
  )
  if(NOT OPENSSL_CONFIGURE_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "openssl: Configure failed")
  endif()

  execute_process(
    COMMAND ${OPENSSL_MAKE_EXE} install_sw
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE OPENSSL_BUILD_RESULT
  )
  if(NOT OPENSSL_BUILD_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "openssl: build failed")
  endif()

  set(OPENSSL_LIB_MODE STATIC)
  if(NOT (CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC"))
    set(OPENSSL_LIB_MODE SHARED)
  endif()

  find_library(OPENSSL_CRYPTO_LIBRARY NAMES crypto PATHS "${OPENSSL_PREFIX}/lib" "${OPENSSL_PREFIX}/lib64" NO_DEFAULT_PATH)
  find_library(OPENSSL_SSL_LIBRARY NAMES ssl PATHS "${OPENSSL_PREFIX}/lib" "${OPENSSL_PREFIX}/lib64" NO_DEFAULT_PATH)
  if(NOT OPENSSL_CRYPTO_LIBRARY OR NOT OPENSSL_SSL_LIBRARY)
    _catalog_log(FATAL_ERROR "openssl: built libraries not found under ${OPENSSL_PREFIX}")
  endif()

  add_library(OpenSSL::Crypto ${OPENSSL_LIB_MODE} IMPORTED)
  set_target_properties(OpenSSL::Crypto PROPERTIES
    IMPORTED_LOCATION "${OPENSSL_CRYPTO_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_PREFIX}/include"
  )
  add_library(OpenSSL::SSL ${OPENSSL_LIB_MODE} IMPORTED)
  set_target_properties(OpenSSL::SSL PROPERTIES
    IMPORTED_LOCATION "${OPENSSL_SSL_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${OPENSSL_PREFIX}/include"
    INTERFACE_LINK_LIBRARIES OpenSSL::Crypto
  )

  add_library(_deps_openssl_combined INTERFACE)
  target_link_libraries(_deps_openssl_combined INTERFACE OpenSSL::SSL OpenSSL::Crypto)
  add_library(deps::openssl ALIAS _deps_openssl_combined)
endfunction()
