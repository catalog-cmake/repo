cmake_minimum_required(VERSION 3.15)
project(libdlgmod CXX)

set(DLGMOD_DIR ${SOURCE_DIR}/libdlgmod)

if(WIN32)
  set(DLGMOD_SOURCES
    ${DLGMOD_DIR}/win32/libdlgmod.cpp
    ${DLGMOD_DIR}/general/apiprocess/process.cpp
    ${DLGMOD_DIR}/general/xprocess.cpp
  )
elseif(APPLE)
  enable_language(OBJCXX)
  set(DLGMOD_SOURCES ${DLGMOD_DIR}/macos/libdlgmod.mm)
elseif(CMAKE_SYSTEM_NAME MATCHES "^(Linux|FreeBSD|DragonFly|NetBSD|OpenBSD|SunOS)$")
  set(DLGMOD_SOURCES
    ${DLGMOD_DIR}/xlib/libdlgmod.cpp
    ${DLGMOD_DIR}/general/apiprocess/process.cpp
    ${DLGMOD_DIR}/general/xprocess.cpp
    ${DLGMOD_DIR}/general/lodepng.cpp
  )
else()
  message(FATAL_ERROR "libdlgmod: unsupported system ${CMAKE_SYSTEM_NAME}")
endif()

add_library(libdlgmod STATIC ${DLGMOD_SOURCES})
target_compile_definitions(libdlgmod PUBLIC PROCESS_GUIWINDOW_IMPL NULLIFY_STDERR)
set_target_properties(libdlgmod PROPERTIES PREFIX "" POSITION_INDEPENDENT_CODE TRUE)
target_include_directories(libdlgmod PUBLIC
  $<BUILD_INTERFACE:${SOURCE_DIR}>
  $<BUILD_INTERFACE:${DLGMOD_DIR}/general>
  $<INSTALL_INTERFACE:include>
  $<INSTALL_INTERFACE:include/libdlgmod/general>
)

if(WIN32)
  target_compile_features(libdlgmod PUBLIC cxx_std_17)
  target_link_libraries(libdlgmod PUBLIC ntdll gdiplus comctl32 shlwapi comdlg32 ole32 oleaut32 uuid)
elseif(APPLE)
  target_compile_features(libdlgmod PUBLIC cxx_std_17)
  target_link_libraries(libdlgmod PUBLIC "-framework AppKit" "-framework UniformTypeIdentifiers")
else()
  target_compile_features(libdlgmod PUBLIC cxx_std_17)
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
endif()

install(TARGETS libdlgmod ARCHIVE DESTINATION lib)
install(FILES ${DLGMOD_DIR}/libdlgmod.h DESTINATION include/libdlgmod)
install(FILES ${DLGMOD_DIR}/general/xprocess.hpp ${DLGMOD_DIR}/general/lodepng.h DESTINATION include/libdlgmod/general)
