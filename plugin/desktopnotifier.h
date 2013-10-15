#ifndef DESKTOPNOTIFIER_H
#define DESKTOPNOTIFIER_H


#include <QtGlobal>
#include <QObject>

/*!
 * \class DesktopNotifier
 *
 */
class Q_DECL_EXPORT DesktopNotifier : public QObject
{

    Q_OBJECT

public:

    explicit DesktopNotifier(QObject *parent=0);

    /*!
     * Destroys the SMS notifier.
     */
    virtual ~DesktopNotifier();

    /*!
     * Notify desktop that the feed templates have been modified
     *
     */
    Q_INVOKABLE void notifyFeedTemplatesModified();




};


#endif // DESKTOPNOTIFIER_H
