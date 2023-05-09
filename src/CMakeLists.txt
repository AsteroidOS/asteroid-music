add_library(asteroid-music main.cpp resources.qrc)
set_target_properties(asteroid-music PROPERTIES PREFIX "")

target_link_libraries(asteroid-music PUBLIC
	AsteroidApp)

install(TARGETS asteroid-music
	DESTINATION ${CMAKE_INSTALL_LIBDIR})
