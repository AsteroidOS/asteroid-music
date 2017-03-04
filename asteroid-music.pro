TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml

lupdate_only{
    SOURCES = main.qml \
              i18n/asteroid-music.desktop.h
}

# Needed for lupdate
TRANSLATIONS = i18n/asteroid-music.ca.ts \
               i18n/asteroid-music.de.ts \
               i18n/asteroid-music.el.ts \
               i18n/asteroid-music.es.ts \
               i18n/asteroid-music.fa.ts \
               i18n/asteroid-music.fr.ts \
               i18n/asteroid-music.hu.ts \
               i18n/asteroid-music.it.ts \
               i18n/asteroid-music.kab.ts \
               i18n/asteroid-music.ko.ts \
               i18n/asteroid-music.nl.ts \
               i18n/asteroid-music.pl.ts \
               i18n/asteroid-music.pt_BR.ts \
               i18n/asteroid-music.ru.ts \
               i18n/asteroid-music.ta.ts \
               i18n/asteroid-music.tr.ts \
               i18n/asteroid-music.uk.ts \
               i18n/asteroid-music.zh_Hans.ts

TARGET = asteroid-music
target.path = /usr/bin/

desktop.commands = bash $$PWD/i18n/generate-desktop.sh $$PWD asteroid-music.desktop
desktop.files = $$OUT_PWD/asteroid-music.desktop
desktop.path = /usr/share/applications

INSTALLS += target desktop
