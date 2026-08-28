function(_recipe_Boost_system)
  if(NOT CMAKE_CROSSCOMPILING)
    if(CL_REQ_VERSION)
      find_package(Boost ${CL_REQ_VERSION} QUIET)
    else()
      find_package(Boost QUIET)
    endif()

    set(_BOOST_PICK "")
    if(TARGET Boost::headers)
      set(_BOOST_PICK Boost::headers)
    elseif(TARGET Boost::boost)
      set(_BOOST_PICK Boost::boost)
    endif()
    if(_BOOST_PICK)
      get_target_property(_BOOST_ALIASED ${_BOOST_PICK} ALIASED_TARGET)
      if(_BOOST_ALIASED)
        add_library(deps::Boost ALIAS ${_BOOST_ALIASED})
      else()
        add_library(deps::Boost ALIAS ${_BOOST_PICK})
      endif()
    endif()
  endif()
endfunction()

function(_recipe_Boost_package)
  if(CL_PACKAGE_MANAGER STREQUAL "apt")
    set(CL_PACKAGE_NAME "libboost-all-dev" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "pacman")
    set(CL_PACKAGE_NAME "boost" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "brew")
    set(CL_PACKAGE_NAME "boost" PARENT_SCOPE)
  elseif(CL_PACKAGE_MANAGER STREQUAL "yum")
    set(CL_PACKAGE_NAME "boost-devel" PARENT_SCOPE)
  endif()
endfunction()

function(_recipe_Boost_source)
  find_program(BOOST_GIT_EXE git)
  if(NOT BOOST_GIT_EXE)
    return()
  endif()

  set(BOOST_REF "boost-1.92.0")
  if(CL_REQ_VERSION)
    set(BOOST_REF "boost-${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME Boost
    DOWNLOAD_ONLY
    REPO https://github.com/boostorg/boost.git
    REF ${BOOST_REF}
  )

  execute_process(
    COMMAND ${BOOST_GIT_EXE} submodule update --init --recursive --jobs 8
    WORKING_DIRECTORY "${CL_SOURCE_DIR}"
    RESULT_VARIABLE BOOST_SUBMODULE_RESULT
  )
  if(NOT BOOST_SUBMODULE_RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "Boost: git submodule update failed")
  endif()

  # Without this, the superproject's root CMakeLists.txt compiles every
  # component library (confirmed directly - 370+ compiled targets even
  # though only Boost::headers ends up used below) regardless of what a
  # consumer actually links against.
  set(BOOST_INCLUDE_LIBRARIES headers CACHE STRING "" FORCE)
  add_subdirectory("${CL_SOURCE_DIR}" "${CL_SOURCE_DIR}-build")

  set(_BOOST_PICK "")
  if(TARGET Boost::headers)
    set(_BOOST_PICK Boost::headers)
  elseif(TARGET Boost::boost)
    set(_BOOST_PICK Boost::boost)
  endif()
  if(_BOOST_PICK)
    get_target_property(_BOOST_ALIASED ${_BOOST_PICK} ALIASED_TARGET)
    if(_BOOST_ALIASED)
      add_library(deps::Boost ALIAS ${_BOOST_ALIASED})
    else()
      add_library(deps::Boost ALIAS ${_BOOST_PICK})
    endif()
  endif()
endfunction()
