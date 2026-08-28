function(_recipe_Catch2_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(Catch2 ${CL_REQ_VERSION} CONFIG QUIET)
    else()
      find_package(Catch2 CONFIG QUIET)
    endif()
  endif()

  if(NOT TARGET Catch2::Catch2)
    cl_format_pkgconfig_req("catch2" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(Catch2 IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_Catch2_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "catch2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "catch2" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "catch2" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_Catch2_source)
  set(CATCH2_TAG "v3.16.0")
  if(CL_REQ_VERSION)
    set(CATCH2_TAG "v${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME Catch2
    URL https://github.com/catchorg/Catch2/archive/refs/tags/${CATCH2_TAG}.tar.gz
    OPTIONS "CATCH_INSTALL_DOCS" "OFF" "CATCH_INSTALL_EXTRAS" "OFF"
  )
endfunction()
