TARGET = asteroid-music
CONFIG += asteroidapp

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml

lupdate_only{ SOURCES += i18n/asteroid-music.desktop.h }
TRANSLATIONS = $$files(i18n/$$TARGET.*.ts)
