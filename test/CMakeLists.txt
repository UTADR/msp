project(msp_test)
include(FetchContent)

set(INSTALL_GTEST OFF)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.15.2
  GIT_SHALLOW TRUE)

include(GoogleTest)

add_executable(value_test src/value_test.cpp)
target_link_libraries(value_test PRIVATE GTest::gtest GTest::gtest_main)
gtest_discover_tests(value_test)

add_executable(bytevector_test src/ByteVector_test.cpp)
target_link_libraries(bytevector_test PRIVATE GTest::gtest GTest::gtest_main)
gtest_discover_tests(bytevector_test)
