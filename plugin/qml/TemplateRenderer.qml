// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {

    id: templateRenderer

    property string templateFile
    property string name
    property bool landscape
    property bool preview
    anchors.fill: parent
    clip: true

    signal regionClicked(int index);

    function reload() {
        console.log("TemplateRenderer.reload() file=" + templateFile);
        loader.source = ""; //Clear loader
        loader.source = templateFile;
        console.log("TemplateRenderer.reload() OK");
    }

    function click(index) {
        console.log("TemplateRenderer:click(" + index + ")");
        //Design horror: signal should be enough
        if(preview) {
            templateRendererContainer.click(index);
        }

    }

    Loader {
         id: loader
         anchors.fill: parent
         source: templateFile

         onStatusChanged: {
              var st = "rand";
              if(status==Loader.Ready) {
                  st = "Ready";
              } else if(status==Loader.Loading) {
                  st = "Loading";
              }
              console.log("TemplateRenderer: Loader status changed: " + st);
          }

    }

}
