
# Main project file for RSSReaderConfig

TEMPLATE = app
TARGET = rssreaderconfig
VERSION = 0.1

INSTALLS = target
target.path = /usr/bin

CONFIG += qt link_pkgconfig
QT += declarative dbus

HEADERS += qmlapplicationviewer/qmlapplicationviewer.h

SOURCES += \
    main.cpp \
    qmlapplicationviewer/qmlapplicationviewer.cpp \
    eventfilter.h

INCLUDEPATH += qmlapplicationviewer

RESOURCES += \
    resources-qml.qrc

OTHER_FILES += \
    qml/Main.qml \
    qml/TemplateList.qml \
    qml/TemplateConfiguration.qml \
    qml/TemplateModeSelector.qml \
    qml/TemplateRendererContainer.qml \
    qml/URLDialog.qml \
    qml/storage.js

CONFIG += mobility

templatesP.files = ../templates/portrait/*.qml
templatesP.path = /usr/share/socam/feeds/templates/portrait
templatesL.files = ../templates/landscape/*.qml
templatesL.path = /usr/share/socam/feeds/templates/landscape

applet.files = rssreaderconfig.desktop
applet.path = /usr/lib/duicontrolpanel/

INSTALLS += applet templatesP  templatesL

