#include <qdeclarative.h>
#include "plugin.h"

#include "desktopnotifier.h"

 void RSSReaderPlugin::registerTypes(const char *uri)
 {
     Q_UNUSED(uri);

     qmlRegisterType<DesktopNotifier>("es.zed.socam.rssreader", 1, 0, "DesktopNotifier");
 }

 Q_EXPORT_PLUGIN2(rssreader, RSSReaderPlugin);
