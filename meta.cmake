set(CATALOG_RECIPES
  SDL2:recipes/sdl2.cmake
  SDL2_ttf:recipes/sdl2_ttf.cmake
  SDL2_image:recipes/sdl2_image.cmake
  SDL2_mixer:recipes/sdl2_mixer.cmake
  SDL2_gfx:recipes/sdl2_gfx.cmake

  SDL3:recipes/sdl3.cmake
  SDL3_ttf:recipes/sdl3_ttf.cmake
  SDL3_image:recipes/sdl3_image.cmake
  SDL3_mixer:recipes/sdl3_mixer.cmake
  SDL3_gfx:recipes/sdl3_gfx.cmake

  SDL:recipes/sdl.cmake
  SDL_ttf:recipes/sdl_ttf.cmake
  SDL_gfx:recipes/sdl_gfx.cmake

  SFML2:recipes/sfml2.cmake
  SFML3:recipes/sfml3.cmake

  raylib:recipes/raylib.cmake

  libogg:recipes/libogg.cmake
  libvorbis:recipes/libvorbis.cmake
  libflac:recipes/libflac.cmake

  freetype:recipes/freetype.cmake
  harfbuzz:recipes/harfbuzz.cmake

  libcurl:recipes/libcurl.cmake
  libssh2:recipes/libssh2.cmake
  nghttp2:recipes/nghttp2.cmake
  c-ares:recipes/c-ares.cmake
  libpsl:recipes/libpsl.cmake
  websocketpp:recipes/websocketpp.cmake
  wslay:recipes/wslay.cmake
  msgpack:recipes/msgpack.cmake

  GLFW:recipes/glfw.cmake
  GLAD:recipes/glad.cmake
  GLEW:recipes/glew.cmake
  libretro:recipes/libretro.cmake

  imgui:recipes/imgui.cmake
  imgui_sdl2:recipes/imgui_sdl2.cmake
  imgui_sdl3:recipes/imgui_sdl3.cmake
  imgui_glfw:recipes/imgui_glfw.cmake

  lua:recipes/lua.cmake
  luajit:recipes/luajit.cmake
  sol2:recipes/sol2.cmake

  cjson:recipes/cjson.cmake
  nlohmann_json:recipes/nlohmann_json.cmake
  rapidjson:recipes/rapidjson.cmake
  jsoncpp:recipes/jsoncpp.cmake
  simdjson:recipes/simdjson.cmake
  yaml-cpp:recipes/yaml-cpp.cmake
  rapidyaml:recipes/rapidyaml.cmake

  plutovg:recipes/plutovg.cmake
  plutosvg:recipes/plutosvg.cmake
  lunasvg:recipes/lunasvg.cmake
  nanosvg:recipes/nanosvg.cmake

  opencl:recipes/opencl.cmake

  cxxopts:recipes/cxxopts.cmake
  lyra:recipes/lyra.cmake
  CLI11:recipes/cli11.cmake

  LLVM:recipes/llvm.cmake
  bison:recipes/bison.cmake

  miniz:recipes/miniz.cmake
  minizip:recipes/minizip.cmake
  zstd:recipes/zstd.cmake
  zlib:recipes/zlib.cmake
  bzip2:recipes/bzip2.cmake
  lz4:recipes/lz4.cmake
  brotli:recipes/brotli.cmake
  xz:recipes/xz.cmake
  libarchive:recipes/libarchive.cmake

  openssl:recipes/openssl.cmake
  monocypher:recipes/monocypher.cmake
  mbedtls:recipes/mbedtls.cmake
  openssh:recipes/openssh.cmake

  sqlite3:recipes/sqlite3.cmake

  fmt:recipes/fmt.cmake
  spdlog:recipes/spdlog.cmake

  Boost:recipes/boost.cmake

  openal:recipes/openal.cmake
  maxmod:recipes/maxmod.cmake
  libpulse:recipes/libpulse.cmake
  libpulse-simple:recipes/libpulse-simple.cmake

  ncurses:recipes/ncurses.cmake
  ftxui:recipes/ftxui.cmake

  stb_image:recipes/stb_image.cmake
  stb_truetype:recipes/stb_truetype.cmake
  stb_vorbis:recipes/stb_vorbis.cmake
  dr_libs:recipes/dr_libs.cmake
  miniaudio:recipes/miniaudio.cmake
  tsf:recipes/tsf.cmake
  dtc:recipes/dtc.cmake

  expected-lite:recipes/expected-lite.cmake

  glm:recipes/glm.cmake
  Catch2:recipes/Catch2.cmake

  libpng:recipes/libpng.cmake
  libjpeg-turbo:recipes/libjpeg-turbo.cmake
  libwebp:recipes/libwebp.cmake

  clay:recipes/clay.cmake

  box2d:recipes/box2d.cmake

  libdlgmod:recipes/libdlgmod.cmake
  __getexecname:recipes/__getexecname.cmake

  GTK3:recipes/gtk3.cmake
  GTK4:recipes/gtk4.cmake
  libadwaita:recipes/libadwaita.cmake
  Qt5:recipes/qt5.cmake
  Qt6:recipes/qt6.cmake

  llama-cpp:recipes/llama-cpp.cmake

  asmjit:recipes/asmjit.cmake
  sljit:recipes/sljit.cmake
  xbyak:recipes/xbyak.cmake

  # DEPRECATED
  mistpp:recipes/mistpp.cmake
)

set(CATALOG_DESCRIPTIONS
  "SDL2:Simple DirectMedia Layer 2, cross-platform audio, video and input"
  "SDL2_ttf:TrueType font rendering for SDL2"
  "SDL2_image:Image loading for SDL2 (PNG, JPEG, WebP and more)"
  "SDL2_mixer:Audio mixing and music playback for SDL2"
  "SDL2_gfx:Drawing primitives and rotozoom for SDL2"
  "SDL3:Simple DirectMedia Layer 3, cross-platform audio, video and input"
  "SDL3_ttf:TrueType font rendering for SDL3"
  "SDL3_image:Image loading for SDL3 (PNG, JPEG, WebP and more)"
  "SDL3_mixer:Audio mixing and music playback for SDL3"
  "SDL3_gfx:Drawing primitives and rotozoom for SDL3"
  "SDL:Simple DirectMedia Layer 1.2 (legacy)"
  "SDL_ttf:TrueType font rendering for SDL 1.2"
  "SDL_gfx:Drawing primitives and rotozoom for SDL 1.2"
  "SFML2:Simple and Fast Multimedia Library 2"
  "SFML3:Simple and Fast Multimedia Library 3"
  "raylib:Simple library for games and graphics programming"
  "libogg:Ogg media container format"
  "libvorbis:Vorbis audio codec"
  "libflac:FLAC lossless audio codec"
  "freetype:Font rendering library"
  "harfbuzz:Text shaping engine"
  "libcurl:Multiprotocol file transfer library (HTTP, FTP and more)"
  "libssh2:SSH2 client library"
  "nghttp2:HTTP/2 library"
  "c-ares:Asynchronous DNS resolver library"
  "libpsl:Public Suffix List library"
  "websocketpp:Header-only C++ WebSocket client and server library"
  "wslay:WebSocket library written in C"
  "msgpack:MessagePack serialization for C and C++"
  "GLFW:Windows, contexts and input for OpenGL and Vulkan"
  "GLAD:OpenGL, GLES and Vulkan loader"
  "GLEW:OpenGL Extension Wrangler Library"
  "libretro:libretro API and common support code"
  "imgui:Dear ImGui, an immediate mode GUI library"
  "imgui_sdl2:Dear ImGui backend for SDL2"
  "imgui_sdl3:Dear ImGui backend for SDL3"
  "imgui_glfw:Dear ImGui backend for GLFW"
  "lua:Lua scripting language"
  "luajit:Just-in-time compiler for Lua"
  "sol2:C++ and Lua binding library"
  "cjson:Ultralightweight JSON parser in C"
  "nlohmann_json:JSON for Modern C++"
  "rapidjson:Fast JSON parser and generator for C++"
  "jsoncpp:C++ JSON library"
  "simdjson:Gigabytes per second JSON parsing"
  "yaml-cpp:YAML parser and emitter for C++"
  "rapidyaml:Fast YAML parsing and emitting library"
  "plutovg:Tiny 2D vector graphics library"
  "plutosvg:Tiny SVG rendering library, built on plutovg"
  "lunasvg:SVG rendering library in C++"
  "nanosvg:Simple single-header SVG parser"
  "opencl:OpenCL parallel computing API"
  "cxxopts:Lightweight C++ command line option parser"
  "lyra:Command line argument parser for C++"
  "CLI11:Command line parser for C++11 and later"
  "LLVM:LLVM compiler infrastructure libraries"
  "bison:GNU parser generator"
  "miniz:Single-file deflate, zlib and zip implementation"
  "minizip:Zip file library built on zlib"
  "zstd:Zstandard fast lossless compression"
  "zlib:General purpose compression library"
  "bzip2:bzip2 block-sorting compression"
  "lz4:Extremely fast lossless compression"
  "brotli:Brotli compression format"
  "xz:XZ Utils, LZMA compression (liblzma)"
  "libarchive:Multi-format archive and compression library"
  "openssl:TLS and cryptography toolkit"
  "monocypher:Small, fast cryptography library (Ed25519, X25519, ChaCha20, BLAKE2b)"
  "mbedtls:Small TLS and cryptography library"
  "openssh:OpenSSH client and server"
  "sqlite3:Embedded SQL database engine"
  "fmt:Modern C++ formatting library"
  "spdlog:Fast C++ logging library"
  "Boost:Peer-reviewed portable C++ libraries"
  "openal:Cross-platform 3D audio API"
  "maxmod:Maxmod audio engine for Nintendo DS and GBA"
  "libpulse:PulseAudio client library"
  "libpulse-simple:PulseAudio simple client API"
  "ncurses:Terminal user interface library"
  "ftxui:Functional terminal user interface library for C++"
  "stb_image:stb single-header image loader"
  "stb_truetype:stb single-header TrueType font rasterizer"
  "stb_vorbis:stb single-file Ogg Vorbis decoder"
  "dr_libs:Single-file audio decoders (dr_wav, dr_mp3, dr_flac)"
  "miniaudio:Single-file audio playback and capture library"
  "tsf:TinySoundFont, a SoundFont2 synthesizer"
  "dtc:DECtalk Mini speech synthesizer"
  "expected-lite:std::expected for C++11 and later"
  "glm:OpenGL Mathematics, a header-only C++ math library"
  "Catch2:C++ unit testing framework"
  "libpng:PNG image format library"
  "libjpeg-turbo:Fast JPEG codec library"
  "libwebp:WebP image format library"
  "clay:High-performance UI layout library in C"
  "box2d:2D physics engine"
  "__getexecname:__getexecname() for platforms that lack it"
  "GTK3:GTK 3 GUI toolkit"
  "GTK4:GTK 4 GUI toolkit"
  "libadwaita:Building blocks for modern GNOME applications (GTK 4)"
  "Qt5:Qt 5 cross-platform application framework"
  "Qt6:Qt 6 cross-platform application framework"
  "llama-cpp:LLM inference in C and C++"
  "asmjit:Low-latency machine code generation library"
  "sljit:Platform independent low-level JIT compiler"
  "xbyak:JIT assembler for x86 and x64 in C++"
  "mistpp:Deprecated, use gh:ScratchEverywhere/mistpp directly"
)
