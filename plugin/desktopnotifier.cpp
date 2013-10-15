
#include <QDBusConnection>
#include <QDBusArgument>
#include <QDBusInterface>

#include "desktopnotifier.h"


DesktopNotifier::DesktopNotifier(QObject *parent) :
    QObject(parent)
{

}

DesktopNotifier::~DesktopNotifier() {

}

void DesktopNotifier::notifyFeedTemplatesModified() {
    QDBusConnection connection = QDBusConnection::sessionBus();
    if (connection.isConnected()) {
        QDBusInterface* dbusIface = new QDBusInterface("org.freedesktop.Notifications",
                            "/org/freedesktop/Notifications", "org.freedesktop.Notifications", connection);
        dbusIface->call(QDBus::NoBlock, "reloadFeedTemplates");
    }
}
