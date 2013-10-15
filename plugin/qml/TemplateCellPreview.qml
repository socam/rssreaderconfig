import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {

    anchors.fill: parent
    property variant colors: ["#a0cbdf", "#70a8a2","#d6872f"]
    color: colors[index%3]
    visible: templateRenderer.preview


    Rectangle {
        id: labelContainer
        z: 100
        width: parent.width/2
        height: parent.height/2
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: indexLabel
            anchors.fill: parent
            text: index
            font.pixelSize: templateCell.height/2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "black"
        }
    }

    Rectangle {
        id: labelContainerShadow
        z: 1
        width: parent.width/2
        height: parent.height/2
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: indexLabelShadow
            anchors.fill: parent
            text: templateCell.index
            font.pixelSize: templateCell.height/2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("TemplateCellPreview:click()");
            clickAnimation.start();
        }
    }

    ParallelAnimation {

        id: clickAnimation
        loops: 1

        NumberAnimation {
            target: labelContainer
            property: "scale"
            from: 1.0
            to: 2.0
            duration: 200
        }

        NumberAnimation {
            target: labelContainer
            property: "opacity"
            from: 1.0
            to:	0.3
            duration: 200
        }

        onCompleted: {
            console.log("Animation completed");
            templateCell.click();
            labelContainer.opacity = 1.0;
            labelContainer.scale = 1.0;
        }

    }

}
