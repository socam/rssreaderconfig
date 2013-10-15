#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"
#include "eventfilter.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    app.setApplicationName("Lipstick");

    QmlApplicationViewer viewer;

    EventFilter ef;
    //viewer.installEventFilter(&ef);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setSource(QUrl("qrc:qml/Main.qml"));

    viewer.showFullScreen();
    return app.exec();

}
