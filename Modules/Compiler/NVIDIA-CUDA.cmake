set(CMAKE_CUDA_COMPILER_HAS_DEVICE_LINK_PHASE True)
set(CMAKE_CUDA_VERBOSE_FLAG "-v")
set(CMAKE_CUDA_VERBOSE_COMPILE_FLAG "-Xcompiler=-v")

if (NOT CMAKE_CUDA_COMPILER_VERSION VERSION_LESS 10.2)
  # The -forward-unknown-to-host-compiler flag was only
  # added to nvcc in 10.2 so before that we had no good
  # way to invoke the CUDA compiler and propagate unknown
  # flags such as -pthread to the host compiler
  set(_CMAKE_CUDA_EXTRA_FLAGS "-forward-unknown-to-host-compiler")
else()
  set(_CMAKE_CUDA_EXTRA_FLAGS "")
endif()

if(CMAKE_CUDA_COMPILER_VERSION VERSION_GREATER_EQUAL "8.0.0")
  set(_CMAKE_CUDA_EXTRA_DEVICE_LINK_FLAGS "-Wno-deprecated-gpu-targets")
else()
  set(_CMAKE_CUDA_EXTRA_DEVICE_LINK_FLAGS "")
endif()

if(NOT "x${CMAKE_CUDA_SIMULATE_ID}" STREQUAL "xMSVC")
  set(CMAKE_CUDA_COMPILE_OPTIONS_PIE -Xcompiler=-fPIE)
  set(CMAKE_CUDA_COMPILE_OPTIONS_PIC -Xcompiler=-fPIC)
  set(CMAKE_CUDA_COMPILE_OPTIONS_VISIBILITY -Xcompiler=-fvisibility=)
  # CMAKE_SHARED_LIBRARY_CUDA_FLAGS is sent to the host linker so we
  # don't need to forward it through nvcc.
  set(CMAKE_SHARED_LIBRARY_CUDA_FLAGS -fPIC)
  string(APPEND CMAKE_CUDA_FLAGS_INIT " ")
  string(APPEND CMAKE_CUDA_FLAGS_DEBUG_INIT " -g")
  string(APPEND CMAKE_CUDA_FLAGS_RELEASE_INIT " -O3 -DNDEBUG")
  string(APPEND CMAKE_CUDA_FLAGS_MINSIZEREL_INIT " -O1 -DNDEBUG")
  string(APPEND CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT " -O2 -g -DNDEBUG")
endif()
set(CMAKE_SHARED_LIBRARY_CREATE_CUDA_FLAGS -shared)
set(CMAKE_INCLUDE_SYSTEM_FLAG_CUDA -isystem=)

if("x${CMAKE_CUDA_SIMULATE_ID}" STREQUAL "xMSVC")
  set(CMAKE_CUDA_STANDARD_DEFAULT "")
else()
  set(CMAKE_CUDA_STANDARD_DEFAULT 98)
  set(CMAKE_CUDA98_STANDARD_COMPILE_OPTION "")
  set(CMAKE_CUDA98_EXTENSION_COMPILE_OPTION "")
  set(CMAKE_CUDA11_STANDARD_COMPILE_OPTION "-std=c++11")
  set(CMAKE_CUDA11_EXTENSION_COMPILE_OPTION "-std=c++11")

  if (NOT CMAKE_CUDA_COMPILER_VERSION VERSION_LESS 9.0)
    set(CMAKE_CUDA98_STANDARD_COMPILE_OPTION "-std=c++03")
    set(CMAKE_CUDA98_EXTENSION_COMPILE_OPTION "-std=c++03")
    set(CMAKE_CUDA14_STANDARD_COMPILE_OPTION "-std=c++14")
    set(CMAKE_CUDA14_EXTENSION_COMPILE_OPTION "-std=c++14")
  endif()

endif()

# FIXME: investigate use of --options-file.
# Tell Makefile generator that nvcc does not support @<rspfile> syntax.
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_INCLUDES 0)
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_LIBRARIES 0)
set(CMAKE_CUDA_USE_RESPONSE_FILE_FOR_OBJECTS 0)

if (CMAKE_CUDA_COMPILER_VERSION VERSION_GREATER_EQUAL "9.0")
  set(CMAKE_CUDA_RESPONSE_FILE_LINK_FLAG "--options-file ")
  set(CMAKE_CUDA_RESPONSE_FILE_FLAG "--options-file ")
endif()
