import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.meego 1.0

Page {

    id: rssWindow

    tools: buttonTools
    property string url

    Component.onCompleted: rssWindowContent.reset();

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

        id: rssWindowContent
        signal finished(string url)
        signal loadFailed()
        anchors.fill: parent
        color: "#fff"

        function reset() {
            webView.url = rssWindow.url;
            webView.reload.trigger();
        }


        Flickable {

            width: parent.width
            height: parent.height
            contentWidth: Math.max(parent.width,webView.contentsSize.width)
            contentHeight: Math.max(parent.height,webView.contentsSize.height)
            pressDelay: 200


            WebView {
                id: webView
                anchors.fill: parent
                preferredHeight: Math.max(parent.height,800)
                preferredWidth: Math.min(parent.width,800)

                url: ""

                onLoadStarted: {
                    loadingIndicator.visible = true;
                    hiddenInput.closeVirtualKeyboard();
                }

                onLoadFinished: {
                    loadingIndicator.visible = false;
                    rssWindowContent.finished( webView.url );
                }

                onLoadFailed: {
                    loadingText.text = "Error";
                    progressBar.visible = false;
                    errorIcon.visible = true;
                }

            }

        }

        Rectangle {

            id: loadingIndicator
            width: parent.width
            height: 120
            anchors.centerIn: parent
            visible: false

            Text {
                id: loadingText
                text: "Loading"
                horizontalAlignment: Text.Center
                width: parent.width
                height:40
                anchors {
                    top: parent.top
                    topMargin: 20
                }
                font.pixelSize: 40
                font.bold: true
                color: "black"
            }

            ProgressBar {
                id: progressBar
                width: 300
                minimumValue: 0
                maximumValue: 100
                value: webView.progress*100
                anchors {
                    top:loadingText.bottom
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                platformStyle: ProgressBarStyle{
                    inverted: false
                }
            }

            Image {
                id: errorIcon
                sourceSize.width: 100
                sourceSize.height: 100
                source: "image://theme/icon-m-transfer-error"
                visible: false
                anchors {
                    top:loadingText.bottom
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
            }

        }


    }

}
