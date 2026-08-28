function(_recipe_GLFW_system)
  cl_format_pkgconfig_req("glfw3" "${CL_VERSION_REQ}" PKG_SPEC)

  if(CL_STATIC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(GLFW IMPORTED_TARGET GLOBAL "--static" ${PKG_SPEC})
      if(TARGET PkgConfig::GLFW)
        return()
      endif()
    endif()
  else()
    if(NOT CMAKE_CROSSCOMPILING)
      if(CL_REQ_VERSION)
        find_package(glfw3 ${CL_REQ_VERSION} QUIET)
      else()
        find_package(glfw3 QUIET)
      endif()
    endif()

    # glfw3's own CMake config exports a bare "glfw" target (not GLFW::GLFW),
    # so the auto-alias candidates in catalog don't match - alias manually.
    if(TARGET glfw AND NOT TARGET deps::GLFW)
      add_library(deps::GLFW ALIAS glfw)
      return()
    endif()

    if(NOT TARGET glfw)
      find_package(PkgConfig QUIET)
      if(PkgConfig_FOUND)
        pkg_check_modules(GLFW IMPORTED_TARGET GLOBAL ${PKG_SPEC})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_GLFW_package)
  if(CL_REQUIRE_STATIC) # Most package managers don't provide static libs.
    return()
  endif()

  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libglfw3-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "glfw" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "glfw" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "glfw-devel" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "glfw-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "zypper")
    set(CL_PACKAGE_NAME "libglfw-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_GLFW_source)
  set(GLFW_BUILD_SHARED "ON")
  if(CL_REQ_TYPE STREQUAL "STATIC" OR CL_REQ_TYPE STREQUAL "PREFER_STATIC")
    set(GLFW_BUILD_SHARED "OFF")
  endif()

  set(GLFW_TAG "3.5.1")
  if(CL_REQ_VERSION)
    set(GLFW_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME GLFW
    URL https://github.com/glfw/glfw/archive/refs/tags/${GLFW_TAG}.tar.gz
    OPTIONS
      "BUILD_SHARED_LIBS" "${GLFW_BUILD_SHARED}"
      "GLFW_BUILD_DOCS" "OFF"
      "GLFW_BUILD_TESTS" "OFF"
      "GLFW_BUILD_EXAMPLES" "OFF"
      "GLFW_INSTALL" "OFF"
  )

  if(TARGET glfw AND NOT TARGET deps::GLFW)
    add_library(deps::GLFW ALIAS glfw)
  endif()
endfunction()
