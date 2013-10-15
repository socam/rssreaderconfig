
import QtQuick 1.1
import com.nokia.meego 1.0
import "storage.js" as Storage
import es.zed.socam.rssreader 1.0

Page {

    id: templateConfiguration
    tools: buttonTools
    orientationLock: PageOrientation.LockPortrait

    property bool landscape: false
    property string filePath
    property variant colors: ["#ffaaaa","#aaffaa","#aaaaff", "#ffaaff", "#aaffff"]

    onFilePathChanged: {
        //templateModel.reload();
    }

    function init(filePath_, landscape_) {
        templateConfiguration.landscape = landscape_;
        templateConfiguration.filePath = filePath_;
    }


    ToolBarLayout {
        id: buttonTools
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

    }

    Rectangle {

        anchors.fill: parent

        URLDialog {
            id: urlDialog

            icon: "image://theme/icon-l-rss"
            titleText: "Enter URL"

            onAccepted: {
                console.log("URL entered: " +  urlDialog.inputText);
                Storage.setURL(urlDialog.templateIndex, landscape, urlDialog.url);
            }
        }

        //Main template view
        Rectangle {

            anchors.fill: parent

            Component.onCompleted: {
                console.log("TP container size=" + width+"x" + height);
            }

            onWidthChanged: {
                console.log("TP container onWidthChanged=" + width+"x" + height);
                preview.resize();

            }

            onHeightChanged: {
                console.log("TP container onHeightChanged=" + width+"x" + height);
                preview.resize();
            }

            TemplateRendererContainer {

                id: preview
                preview: true
                templateFile: filePath
                landscape: templateConfiguration.landscape
                name: "templateConfiguration[" + filePath +  "]"

                onRegionClicked: {
                    console.log("TemplateConfiguration::templateRendererContainer.onRegionClicked(" + index + ")");
                    var url = Storage.getURL(index, landscape);
                    console.log("Region clicked. URL=" + url + ". Show dialog");
                    urlDialog.show(index, url);
                }

            }

        }

    }

}
