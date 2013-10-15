
import QtQuick 1.0
import com.nokia.meego 1.2
import "storage.js" as Storage

Rectangle {

   id: templateCellContent
   anchors.fill: parent

   property bool enabled
   property string link: ""
   property bool loading: feedModel.status == XmlListModel.Loading

   Component.onCompleted: {
       console.log("TemplateCell.onCompleted visible=" + visible + "enabled=" + enabled);
       if (enabled) {
           feedURL = Storage.getURL(templateCell.index, templateRenderer.landscape);
       }
   }

    XmlListModel {
        id: feedModel
        source: templateCell.feedURL
        query: "/rss/channel/item[1]"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "description"; query: "description/string()" }

        onStatusChanged: {

            if(status==XmlListModel.Loading) {
                 console.log("RSS loading:" + templateCell.feedURL);
            }
            else if(status==XmlListModel.Ready) {

                console.log("RSS complete:" + templateCell.feedURL);

                if(count>0) {

                    var rss = get(0);

                    console.log("title:" + rss.title);
                    titleText.text = rss.title;

                    console.log("link:" + rss.link);
                    link = rss.link;

                    console.log("description:" + rss.description);
                    descriptionText.text = rss.description;

                }
            } else if(status==XmlListModel.Error) {
                console.log("Error loading RSS");
            }

        }
    }

    XmlListModel {
        id: feedInfoModel
        source: templateCell.feedURL
        query: "/rss/channel/image[1]"
        XmlRole { name: "url"; query: "url/string()" }

        onStatusChanged: {
            if(status==XmlListModel.Ready) {
                console.log("RSSInfo complete:" + count);
                if (count>0) {
                    var url = get(0);
                    console.log("URL:" + url.url);
                    channelImage.source = url.url;
                }
            }
        }

    }

    Item {
        Timer {
            interval: 300000
            running: true
            repeat: true
            onTriggered: reload();

        }
    }



    function reload() {
        feedModel.reload();
        feedInfoModel.reload()
    }

    Image {
         source: "image://theme/icon-m-transfer-error"
         anchors {
             horizontalCenter: parent.horizontalCenter
             verticalCenter: parent.verticalCenter
         }
         z: 100
         sourceSize.width: parent.width>parent.height ? parent.height/2 : parent.width/2
         sourceSize.height: parent.width>parent.height ? parent.height/2 : parent.width/2
         visible: feedModel.status==XmlListModel.Error
    }

    Rectangle {

        id: rssHeader
        height: 0
        width: parent.width
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Image {

           id: channelImage
           height: 40
           anchors {
               top: parent.top
               horizontalCenter: parent.horizontalCenter
           }

           onStatusChanged: {
               if(status==Image.Ready) {
                   var scaleH =height/sourceSize.height;
                   var scaleW = width/sourceSize.width;
                   var scaleX = Math.min(scaleH, scaleW);
                   console.log("scale:" + scaleX + " scaleH:" + scaleH + " scaleW:" + scaleW);
                   height = height*scaleX;
                   width = width*scaleX;
                   channelImageSeparator.visible=true;
                   rssHeader.height =  channelImage.height + channelImageSeparator.height;
               }
           }

        }

        Rectangle {
            id: channelImageSeparator
            visible: false
            height: 3
            width: parent.width * 0.8
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            color: "black"
        }

    }

    Rectangle {

        anchors {
            top: rssHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {

            height: column.height
            width: parent.width

            Column {
                id: column
                x: 20; y: 10
                width: parent.width - 40

                Text {
                    id: titleText
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font { bold: true; pointSize: 16 }
                }

                Text {
                    id: descriptionText
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

        }


        BusyIndicator {

            running: templateCellContent.loading
            visible: templateCellContent.loading
            platformStyle: BusyIndicatorStyle { size: "large" }
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }


        BusyIndicator {

            id: pressIndicator
            visible: mouseArea.pressed
            running: visible
            platformStyle: BusyIndicatorStyle { size: "large" }
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

        }


    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressAndHold: {
            buttonsPanel.show();
        }
    }


    Rectangle {

        id: buttonsPanel
        anchors.fill: parent
        z: 2
        visible: false
        color: "transparent"

        Rectangle {
            id:background
            anchors.fill: parent
            color: "black"
            opacity: 0.2
        }

        Button {
            z:3
            text: "Go to link"
            anchors {
               horizontalCenter: parent.horizontalCenter
            }
            width: parent.width/2
            y: parent.height/2 - height/2
            onClicked: {
                console.log("TemplateCellContent => button[gotolink].click()");
                if (link != "") {
                    var component = Qt.createComponent("RSSWindow.qml");
                    var rssWindow = component.createObject(mainWindow, {"url": templateCellContent.link});
                    buttonsPanel.visible = false;
                    pageStack.push(rssWindow);
                }
            }
        }

        Button {
            z:3
            text: "Reload"
            anchors {
               horizontalCenter: parent.horizontalCenter
            }
            width: parent.width/2
            y: parent.height/2 + height/2
            onClicked: {
                console.log("TemplateCellContent => button[reload].click()");
                buttonsPanel.visible = false;
                reload();
            }
        }

        function show() {
            buttonsPanel.visible = true;
            timer.start();
        }

        Timer {
            id: timer
            interval: 5000
            running: false
            repeat: false
            onTriggered: {
                buttonsPanel.visible = false;
            }
        }

    }

}
