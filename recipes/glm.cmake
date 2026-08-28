function(_recipe_glm_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(glm ${CL_REQ_VERSION} CONFIG QUIET)
    else()
      find_package(glm CONFIG QUIET)
    endif()
  endif()

  if(NOT TARGET glm::glm)
    cl_format_pkgconfig_req("glm" "${CL_VERSION_REQ}" PKG_SPEC)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
      pkg_check_modules(glm IMPORTED_TARGET GLOBAL ${PKG_SPEC})
    endif()
  endif()
endfunction()

function(_recipe_glm_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libglm-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "glm" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "glm" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "apk")
    set(CL_PACKAGE_NAME "glm-dev" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_glm_source)
  set(GLM_TAG "1.0.3")
  if(CL_REQ_VERSION)
    set(GLM_TAG "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME glm
    URL https://github.com/g-truc/glm/archive/refs/tags/${GLM_TAG}.tar.gz
    OPTIONS "GLM_BUILD_TESTS" "OFF" "GLM_BUILD_INSTALL" "OFF"
  )
endfunction()
