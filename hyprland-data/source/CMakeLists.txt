cmake_minimum_required(VERSION 3.0)

include(CheckIncludeFile)
include(GNUInstallDirs)

# installable assets
file(GLOB_RECURSE INSTALLABLE_ASSETS "assets/*")
install(FILES ${INSTALLABLE_ASSETS}
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/hypr)

