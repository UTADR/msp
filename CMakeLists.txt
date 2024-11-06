cmake_minimum_required(VERSION 3.25.0)
project(
  msp
  DESCRIPTION
    "Implementation of the MultiWii Serial Protocol (MSP) for MultiWii and Cleanflight flight controller"
  VERSION 3.4.0
  LANGUAGES CXX)

if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

# Localize the impact of setting CMAKE_MODULE_PATH
block()
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/")

find_package(ASIO MODULE REQUIRED)
endblock()

include(CMakeDependentOption)
cmake_dependent_option(MSP_BUILD_EXAMPLES "Build Library with examples" ON
                       "${PROJECT_IS_TOP_LEVEL}" OFF)
cmake_dependent_option(MSP_BUILD_TESTS "Build Library with tests" OFF
                       "${PROJECT_IS_TOP_LEVEL}" OFF)
cmake_dependent_option(MSP_INSTALL "Enable installation of the MSP target" ON
                       "${PROJECT_IS_TOP_LEVEL}" OFF)
find_package(Threads)

# ##############################################################################
# libraries

add_library(msp_msp INTERFACE)
target_sources(
  msp_msp
  INTERFACE FILE_SET
            HEADERS
            BASE_DIRS
            inc
            FILES
            inc/msp/ByteVector.hpp
            inc/msp/FirmwareVariants.hpp
            inc/msp/FlightController.hpp
            inc/msp/FlightMode.hpp
            inc/msp/Message.hpp
            inc/msp/Subscription.hpp
            inc/msp/Value.hpp
            inc/msp/msp_msg.hpp)
target_compile_features(msp_msp INTERFACE cxx_std_17)
target_compile_definitions(
  msp_msp
  INTERFACE -DASIO_STANDALONE -DASIO_HAS_STD_ADDRESSOF -DASIO_HAS_STD_ARRAY
            -DASIO_HAS_CSTDINT -DASIO_HAS_STD_SHARED_PTR
            -DASIO_HAS_STD_TYPE_TRAITS)
set_target_properties(msp_msp PROPERTIES EXPORT_NAME msp)
add_library(msp::msp ALIAS msp_msp)

# client library
add_library(msp_client)
target_sources(
  msp_client
  PUBLIC FILE_SET
         HEADERS
         BASE_DIRS
         inc
         FILES
         inc/msp/Client.hpp
         inc/msp/PeriodicTimer.hpp
  PRIVATE src/Client.cpp src/PeriodicTimer.cpp)
target_link_libraries(msp_client PUBLIC Threads::Threads ASIO::ASIO msp::msp)
set_target_properties(msp_client PROPERTIES EXPORT_NAME client)
add_library(msp::client ALIAS msp_client)

# high-level API
add_library(msp_fcu)
target_sources(
  msp_fcu
  PUBLIC FILE_SET HEADERS BASE_DIRS inc FILES inc/msp/FlightController.hpp
  PRIVATE src/FlightController.cpp)
target_link_libraries(msp_fcu PUBLIC msp::client)
set_target_properties(msp_fcu PROPERTIES EXPORT_NAME fcu)
add_library(msp::fcu ALIAS msp_fcu)

# ##############################################################################
# examples / tests

if(MSP_BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

if(MSP_INSTALL)
  # installation
  # ============

  include(cmake/install_rules.cmake)
  set(PKG_CONFIG_LIBDIR "\${prefix}/lib")
  set(PKG_CONFIG_INCLUDEDIR "\${prefix}/include/")
  set(PKG_CONFIG_LIBS "-L\${libdir} -lmsp_fcu -lmsp_client")
  set(PKG_CONFIG_CFLAGS "-I\${includedir}")

  configure_file("${CMAKE_CURRENT_SOURCE_DIR}/pkg-config.pc.cmake"
                 "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc")

  install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.pc"
          DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

endif()

# testing
# =======
include(CTest)
if(MSP_BUILD_TESTS)
  add_subdirectory(test)
endif()
