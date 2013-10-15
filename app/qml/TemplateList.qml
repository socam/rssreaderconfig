import QtQuick 1.0
import com.nokia.meego 1.0
import Qt.labs.folderlistmodel 1.0
import "storage.js" as Storage
import es.zed.socam.rssreader 1.0

Page {

    id: templateList
    tools: buttonTools
    orientationLock: PageOrientation.LockPortrait

    ToolBarLayout {
        id: buttonTools
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }
    }

    property bool landscape: false
    property string selectedTemplate
    property TemplateConfiguration templateConfiguration
    property variant colors: ["#ffaaaa","#aaffaa","#aaaaff", "#ffaaff", "#aaffff"]


    onVisibleChanged: {
        selectedTemplate = Storage.getTemplate(landscape);
    }

    Component.onCompleted: {
        selectedTemplate = Storage.getTemplate(landscape);
    }

    Rectangle {

        anchors.fill: parent

        FolderListModel {
            id: templateListModel
            folder: "file:///usr/share/socam/feeds/templates/" + (landscape ? "landscape" : "portrait")
            nameFilters: ["*.qml"]
        }

        Rectangle {

            anchors.fill: parent;

            GridView {

                id: grid

                anchors.fill: parent

                cellWidth: parent.width/2
                cellHeight: parent.height/2
                model: templateListModel

                delegate: Component {

                    id: templateListCell

                    Rectangle {

                        color: "white"
                        width: grid.cellWidth
                        height: grid.cellHeight

                        Rectangle {

                            width: parent.width-10
                            height: parent.height-10
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }

                            color: "white"

                            Rectangle {

                                color: (filePath == selectedTemplate) ? "#ffbbbb" : "white"
                                anchors {
                                    top: parent.top
                                    left: parent.left
                                    right: parent.right
                                    bottom: titlePanel.top
                                }

                                Rectangle {

                                    id: templatePreviewContainer

                                    height: parent.height * 0.9
                                    width: parent.width * 0.9
                                    color: (filePath == selectedTemplate) ? "#ffbbbb" : "white"
                                    anchors {
                                        horizontalCenter: parent.horizontalCenter
                                        verticalCenter: parent.verticalCenter
                                    }

                                    TemplateRendererContainer {
					                    preview: true
                                        templateFile: filePath
                                        landscape: templateList.landscape
                                        name: "templateList[" + filePath +  "]"
                                    }

                                    DesktopNotifier {
                                        id:desktopNotifier
                                    }

                                    MouseArea {

                                        anchors.fill: parent

                                        onClicked: {
                                            selectedTemplate = filePath;
                                            if(landscape) {
                                                landscapeTemplateModeSelector.templateFile = filePath;
                                            } else {
                                                portraitTemplateModeSelector.templateFile = filePath;
                                            }

                                            Storage.setTemplate(landscape, filePath);

                                            desktopNotifier.notifyFeedTemplatesModified();

                                            var component = Qt.createComponent("TemplateConfiguration.qml");
                                            var templateConfiguration = component.createObject(appWindow, {"landscape": landscape, "filePath": filePath});
                                            pageStack.push(templateConfiguration);                                            
                                        }

                                    }


                                }

                            }

                            Rectangle {
                                id: titlePanel
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    bottom: parent.bottom
                                }
                                height: parent.height/5
                                color: "#ccffcc"

                                Text {
                                    text: fileName
                                    anchors {
                                        verticalCenter: parent.verticalCenter
                                        horizontalCenter: parent.horizontalCenter
                                    }

                                }

                            }

                        }

                    }

                }


            }

        }

    }


}
