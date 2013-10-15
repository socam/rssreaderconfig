#include <QDeclarativeExtensionPlugin>

 class Q_DECL_EXPORT RSSReaderPlugin : public QDeclarativeExtensionPlugin
 {
     Q_OBJECT
 public:
     void registerTypes(const char *uri);
 };
