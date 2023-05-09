cmake_minimum_required(VERSION 3.6.0)

project(asteroid-music
	VERSION 0.0.1
	DESCRIPTION "Default music app for AsteroidOS")

find_package(ECM REQUIRED NO_MODULE)
find_package(AsteroidApp REQUIRED)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ASTEROID_MODULE_PATH})

include(FeatureSummary)
include(GNUInstallDirs)
include(ECMFindQmlModule)
include(AsteroidCMakeSettings)
include(AsteroidTranslations)

ecm_find_qmlmodule(org.nemomobile.mpris 1.0)

add_subdirectory(src)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/asteroid-music.in
	${CMAKE_BINARY_DIR}/asteroid-music
	@ONLY)

install(PROGRAMS ${CMAKE_BINARY_DIR}/asteroid-music
	DESTINATION ${CMAKE_INSTALL_BINDIR})

build_translations(i18n)
generate_desktop(${CMAKE_SOURCE_DIR} asteroid-music)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
