function(_recipe_libdlgmod_source)
  set(LIBDLGMOD_REF "main")
  if(CL_REQ_VERSION)
    set(LIBDLGMOD_REF "${CL_REQ_VERSION}")
  endif()

  cl_import_source(
    NAME libdlgmod
    DOWNLOAD_ONLY
    REPO https://github.com/samuelvenable/libdlgmod.git
    REF ${LIBDLGMOD_REF}
  )

  set(LIBDLGMOD_DIR "${CL_SOURCE_DIR}/libdlgmod")
  if(NOT EXISTS "${LIBDLGMOD_DIR}")
    _catalog_log(FATAL_ERROR "libdlgmod: expected sources not found under ${LIBDLGMOD_DIR}")
  endif()

  if(WIN32)
    add_library(libdlgmod STATIC
      "${LIBDLGMOD_DIR}/win32/libdlgmod.cpp"
      "${LIBDLGMOD_DIR}/general/apiprocess/process.cpp"
      "${LIBDLGMOD_DIR}/general/xprocess.cpp"
    )
    target_compile_definitions(libdlgmod PUBLIC PROCESS_GUIWINDOW_IMPL NULLIFY_STDERR)
    target_link_libraries(libdlgmod PUBLIC ntdll gdiplus comctl32 shlwapi comdlg32 ole32 oleaut32 uuid)
    set_target_properties(libdlgmod PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED ON POSITION_INDEPENDENT_CODE TRUE)
  elseif(APPLE)
    add_library(libdlgmod STATIC "${LIBDLGMOD_DIR}/macos/libdlgmod.mm")
    target_compile_definitions(libdlgmod PUBLIC PROCESS_GUIWINDOW_IMPL NULLIFY_STDERR)
    target_link_libraries(libdlgmod PUBLIC "-framework AppKit" "-framework UniformTypeIdentifiers")
    set_target_properties(libdlgmod PROPERTIES OBJCXX_STANDARD 17 OBJCXX_STANDARD_REQUIRED ON POSITION_INDEPENDENT_CODE TRUE)
  elseif(CMAKE_SYSTEM_NAME MATCHES "^(Linux|FreeBSD|DragonFly|NetBSD|OpenBSD|SunOS)$")
    add_library(libdlgmod STATIC
      "${LIBDLGMOD_DIR}/xlib/libdlgmod.cpp"
      "${LIBDLGMOD_DIR}/general/apiprocess/process.cpp"
      "${LIBDLGMOD_DIR}/general/xprocess.cpp"
      "${LIBDLGMOD_DIR}/general/lodepng.cpp"
    )
    target_compile_definitions(libdlgmod PUBLIC PROCESS_GUIWINDOW_IMPL NULLIFY_STDERR)
    set_target_properties(libdlgmod PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED ON POSITION_INDEPENDENT_CODE TRUE)

    find_package(X11 REQUIRED)
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
    target_link_libraries(libdlgmod PUBLIC X11::X11 Threads::Threads)

    if(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD" OR CMAKE_SYSTEM_NAME STREQUAL "DragonFly")
      target_include_directories(libdlgmod PUBLIC "/usr/local/include")
      target_link_directories(libdlgmod PUBLIC "/usr/local/lib")
      target_link_libraries(libdlgmod PUBLIC kvm)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "NetBSD")
      target_include_directories(libdlgmod PUBLIC "/usr/X11R7/include")
      target_link_directories(libdlgmod PUBLIC "/usr/X11R7/lib")
      target_link_libraries(libdlgmod PUBLIC kvm)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "OpenBSD")
      target_include_directories(libdlgmod PUBLIC "/usr/X11R6/include")
      target_link_directories(libdlgmod PUBLIC "/usr/X11R6/lib")
      target_link_libraries(libdlgmod PUBLIC kvm)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "SunOS")
      target_link_libraries(libdlgmod PUBLIC kvm proc)
    endif()
  else()
    return()
  endif()

  target_include_directories(libdlgmod PUBLIC
    $<BUILD_INTERFACE:${CL_SOURCE_DIR}>
    $<BUILD_INTERFACE:${LIBDLGMOD_DIR}/general>
  )

  set_target_properties(libdlgmod PROPERTIES PREFIX "")
endfunction()
