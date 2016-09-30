TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml

lupdate_only{
    SOURCES = main.qml
}

TARGET = asteroid-music
target.path = /usr/bin/

desktop.files = asteroid-music.desktop
desktop.path = /usr/share/applications

INSTALLS += target desktop
