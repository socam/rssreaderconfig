// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "storage.js" as Storage
import es.zed.socam.rssreader 1.0

Rectangle {

    id: container
    width: mainWindow.inPortrait ? parent.width : parent.width/2
    height: mainWindow.inPortrait ? parent.height/2 : parent.height

    property bool landscape
    property string templateFile

    Component.onCompleted: {
        templateFile = Storage.getTemplate(landscape);
    }

    Rectangle {

        id:previewContainer

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: titleContainer.top
        }

        onWidthChanged: {
            preview.resize();
        }

        onHeightChanged: {
            preview.resize();
        }

        Rectangle {

            height: parent.height * 0.9
            width: parent.width * 0.9
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            TemplateRendererContainer {
                id: preview
                preview: true
                templateFile: container.templateFile
                landscape: container.landscape
                name: "templateModeSelector[" + container.landscape + "]"
            }

            Label {
                font.pixelSize: parent.height/2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                visible: templateFile === undefined || templateFile === ""
                text: "?"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("TemplateModeSelector onClicked");
                    var component = Qt.createComponent("TemplateList.qml");
                    var templateList = component.createObject(appWindow, {"landscape": landscape});
                    console.log("TemplateModeSelector selected:[" + templateList + "]");
                    pageStack.push(templateList);
                }
            }

        }

    }

    Rectangle {

            id: titleContainer
            color: "#bbbbff"
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: parent.height/4

            Label {
                font.pixelSize: parent.height/2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                text: landscape?"landscape":"portrait"
            }

    }


}
