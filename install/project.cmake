function(repo_install_project NAME PREFIX)
  cmake_parse_arguments(P "FROM_SOURCE" "SUBDIR" "OPTIONS" ${ARGN})

  set(WORK "${CL_SOURCE_DIR}-${NAME}-install")
  file(REMOVE_RECURSE "${WORK}")
  file(MAKE_DIRECTORY "${WORK}/project" "${WORK}/stage")

  if(P_FROM_SOURCE)
    set(PROJECT_DIR "${CL_SOURCE_DIR}")
    if(P_SUBDIR)
      set(PROJECT_DIR "${PROJECT_DIR}/${P_SUBDIR}")
    endif()
  else()
    cl_repo_file(install/${NAME}/CMakeLists.txt PROJECT_FILE)
    file(COPY_FILE "${PROJECT_FILE}" "${WORK}/project/CMakeLists.txt")
    set(PROJECT_DIR "${WORK}/project")
  endif()

  cl_get_var("BUILD_TYPE" BUILD_TYPE)
  if(NOT BUILD_TYPE)
    set(BUILD_TYPE "Release")
  endif()
  cl_get_var("INSTALL_CMAKE_ARGS" FORWARDED_ARGS)
  cl_get_var("REQ_TYPE" REQ_TYPE)

  set(GENERATOR_ARGS -G "${CMAKE_GENERATOR}")
  if(CMAKE_GENERATOR_PLATFORM)
    list(APPEND GENERATOR_ARGS -A "${CMAKE_GENERATOR_PLATFORM}")
  endif()
  if(CMAKE_GENERATOR_TOOLSET)
    list(APPEND GENERATOR_ARGS -T "${CMAKE_GENERATOR_TOOLSET}")
  endif()

  set(CONFIGURE_ARGS "-DCMAKE_INSTALL_PREFIX=${PREFIX}" "-DCMAKE_BUILD_TYPE=${BUILD_TYPE}" "-DSOURCE_DIR=${CL_SOURCE_DIR}")
  if(REQ_TYPE STREQUAL "STATIC" OR REQ_TYPE STREQUAL "PREFER_STATIC")
    list(APPEND CONFIGURE_ARGS "-DBUILD_SHARED_LIBS=OFF")
  elseif(REQ_TYPE STREQUAL "SHARED" OR REQ_TYPE STREQUAL "PREFER_SHARED")
    list(APPEND CONFIGURE_ARGS "-DBUILD_SHARED_LIBS=ON")
  endif()
  list(APPEND CONFIGURE_ARGS ${FORWARDED_ARGS})

  list(LENGTH P_OPTIONS OPTION_COUNT)
  set(OPTION_INDEX 0)
  while(OPTION_INDEX LESS OPTION_COUNT)
    list(GET P_OPTIONS ${OPTION_INDEX} OPTION_NAME)
    math(EXPR OPTION_INDEX "${OPTION_INDEX} + 1")
    list(GET P_OPTIONS ${OPTION_INDEX} OPTION_VALUE)
    math(EXPR OPTION_INDEX "${OPTION_INDEX} + 1")
    list(APPEND CONFIGURE_ARGS "-D${OPTION_NAME}=${OPTION_VALUE}")
  endwhile()

  execute_process(
    COMMAND "${CMAKE_COMMAND}" -S "${PROJECT_DIR}" -B "${WORK}/build" ${GENERATOR_ARGS} ${CONFIGURE_ARGS}
    RESULT_VARIABLE RESULT
  )
  if(NOT RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "${NAME}: failed to configure for installation")
  endif()

  execute_process(
    COMMAND "${CMAKE_COMMAND}" --build "${WORK}/build" --config "${BUILD_TYPE}" --parallel
    RESULT_VARIABLE RESULT
  )
  if(NOT RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "${NAME}: failed to build")
  endif()

  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E env "DESTDIR=${WORK}/stage" "${CMAKE_COMMAND}" --install "${WORK}/build" --config "${BUILD_TYPE}"
    RESULT_VARIABLE RESULT
  )
  if(NOT RESULT EQUAL 0)
    _catalog_log(FATAL_ERROR "${NAME}: failed to install")
  endif()

  file(GLOB STAGED LIST_DIRECTORIES true "${WORK}/stage${PREFIX}/*")
  if(NOT STAGED)
    _catalog_log(FATAL_ERROR "${NAME}: the build installed no files")
  endif()
  cl_install_files(DESTINATION . ${STAGED})
endfunction()
