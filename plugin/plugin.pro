TEMPLATE = lib
TARGET = rssreader
VERSION = 0.1

CONFIG += qt plugin
QT += declarative dbus
PKGCONFIG += qmsystem2

uri =es.zed.socam.rssreader

RESOURCES += \
    resources-qml.qrc

SOURCES += plugin.cpp desktopnotifier.cpp
HEADERS += plugin.h desktopnotifier.h

OTHER_FILES = qmldir \
    qml/TemplateRenderer.qml \ 
    qml/TemplateCell.qml \
    qml/TemplateCellPreview.qml \
    qml/TemplateCellContent.qml \
    qml/RSSWindow.qml

QMAKE_CXXFLAGS += \
    -Werror \
    -g \
    -std=c++0x \
    -fPIC \
    -fvisibility=hidden \
    -fvisibility-inlines-hidden

QMAKE_LFLAGS += \
    -pie \
    -rdynamic



!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
   QMAKE_EXTRA_TARGETS += copy_qmldir
   PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir
unix {
   installPath = $$[QT_INSTALL_IMPORTS]/$$replace(uri, \\., /)
   qmldir.path = $$installPath
   target.path = $$installPath
   qml.files = qml/*
   qml.path = $$installPath
   storage.js.files = ../app/qml/storage.js
   storage.js.path = $$installPath
   INSTALLS += target qmldir qml storage.js
}

