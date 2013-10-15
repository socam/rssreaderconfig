// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

import es.zed.socam.rssreader 1.0
import "storage.js" as Storage

PageStackWindow {

    id: mainWindow
    initialPage: mainPage

    Page {

        id: mainPage
        tools: buttonTools
        anchors.fill: parent
        orientationLock: PageOrientation.LockPortrait


        ToolBarLayout {
            id: buttonTools

            /*ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); }  }
            ToolButtonRow {
                ToolButton { text: "Copy"; onClicked: { label.text = textField.text } }
                ToolButton { text: "Clear"; onClicked: { textField.text = ""; label.text = "empty label" } }
            }*/
            ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
        }

        Menu {
            id: myMenu
            visualParent: pageStack

            MenuLayout {
                MenuItem { text: "Exit"; onClicked: { Qt.quit() } }
            }
        }

        Rectangle {

            id: appWindow
            anchors.fill: parent

            Component.onCompleted: {
                Storage.initialize();
            }

            Flow {

                anchors.fill: parent

                TemplateModeSelector {
                    id: portraitTemplateModeSelector
                    landscape: false
                }

                TemplateModeSelector {
                    id: landscapeTemplateModeSelector
                    landscape: true
                }

            }

        }

    }




}


