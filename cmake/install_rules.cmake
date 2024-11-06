include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
install(
  TARGETS msp_msp msp_client msp_fcu
  EXPORT ${CMAKE_PROJECT_NAME}Targets
  FILE_SET HEADERS
  DESTINATION
    "${CMAKE_INSTALL_INCLUDEDIR}/${CMAKE_PROJECT_NAME}-${PROJECT_VERSION}")

write_basic_package_version_file(
  "${CMAKE_PROJECT_NAME}ConfigVersion.cmake" COMPATIBILITY SameMajorVersion
                                                           ARCH_INDEPENDENT)

configure_package_config_file(
  ${CMAKE_SOURCE_DIR}/cmake/install_config.cmake.in
  "${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${CMAKE_PROJECT_NAME}")

install(FILES "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
              "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${CMAKE_PROJECT_NAME}")

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindASIO.cmake"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${CMAKE_PROJECT_NAME}")

install(
  EXPORT ${CMAKE_PROJECT_NAME}Targets
  NAMESPACE ${CMAKE_PROJECT_NAME}::
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${CMAKE_PROJECT_NAME}")
