// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import es.zed.socam.rssreader 1.0

Rectangle {

    id: templateRendererContainer
    clip: true

    signal regionClicked(int index);

    property string templateFile
    property string name
    property bool landscape
    property bool preview

    anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
    }

    Component.onCompleted: {
        resize();
    }

    onLandscapeChanged: {
        resize();
    }

    onHeightChanged: {
        resize();
    }

    onWidthChanged: {
        resize();
    }

    function resize() {
        var ratio = mainWindow.inPortrait ? (mainWindow.width / mainWindow.height) : (mainWindow.height/ mainWindow.width );
        if (landscape) {
            width =  parent.width;
            height = width/ratio;
        } else {
            height = parent.height;
            width =  height/ratio;
        }
    }

    TemplateRenderer {
        id: templateRenderer
         anchors.fill: parent
         templateFile: templateRendererContainer.templateFile
         landscape: templateRendererContainer.landscape
         preview: templateRendererContainer.preview
         onRegionClicked: function(index) {
              console.log("!!!!templateRendererContainer.click(" + index + ")");
              regionClicked(index);
            }
     }

    Connections {
        target: templateRenderer
        onRegionClicked: function(index) {
             console.log("!!!!!!!templateRendererContainer.click(" + index + ")");
             regionClicked(index);
           }
    }

    function click(index) {
        console.log("templateRendererContainer.click(" + index + ")");
        regionClicked(index);
    }

}
