cmake_minimum_required(VERSION 3.20)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Release>:DLL>")

project(windows7)

add_library(api-ms-win-core-synch-l1-2-0 SHARED
	api-ms-win-core-synch-l1-2-0.c
	api-ms-win-core-synch-l1-2-0.def
)
set_target_properties(api-ms-win-core-synch-l1-2-0 PROPERTIES PREFIX "")
install(TARGETS api-ms-win-core-synch-l1-2-0)

add_library(dxgi SHARED
	dxgi.c
	dxgi.def
)
set_target_properties(dxgi PROPERTIES PREFIX "")
install(TARGETS dxgi)
