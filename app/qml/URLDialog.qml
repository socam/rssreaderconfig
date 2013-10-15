
import QtQuick 1.1
import com.nokia.meego 1.0

Dialog {
    id: root
    objectName: "URLDialog"

    property string titleText
    property string url
    property int templateIndex: 0

    //ToDo
    property alias icon: iconImage.source

    property Style platformStyle: QueryDialogStyle {}

    //__centerContentField: true

    __dim: platformStyle.dim
    __fadeInDuration:  platformStyle.fadeInDuration
    __fadeOutDuration: platformStyle.fadeOutDuration
    __fadeInDelay:     platformStyle.fadeInDelay
    __fadeOutDelay:    platformStyle.fadeOutDelay

    __animationChief: "queryDialog"

    // the default is a modal QueryDialog, but don't make it modal when no buttons are shown
    __platformModal: true

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    signal linkActivated(string link)

    function show(index, url) {
        templateIndex = index;
        root.url = url
        textInput.text = url;
        open();
        //textInput.forceActiveFocus();
    }

    function __beginTransformationToHidden() {
        __fader().state = "hidden";
        root.opacity = 1.0;
        queryContent.opacity = 1.0
        titleField.opacity = 1.0
        root.status = DialogStatus.Closing;
    }

    // reset button and make sure, root isn't visible
    function __endTransformationToHidden() {
        root.opacity = 0.0;
        status = DialogStatus.Closed;
    }

    function __beginTransformationToVisible() {
        __fader().state = "visible";
       root.status = DialogStatus.Opening;
       root.opacity = 1.0
       titleField.opacity = 0.0
       queryContent.opacity = 0.0
    }

    function __endTransformationToVisible() {
        root.status = DialogStatus.Open;
    }

    // the title field consists of the following parts: title string and
    // a close button (which is in fact an image)
    // it can additionally have an icon
    title: Item {
        id: titleField
        width: parent.width
        height: titleText == "" ? titleBarIconField.height :
                    titleBarIconField.height + titleLabel.height + root.platformStyle.titleColumnSpacing
        Column {
            id: titleFieldCol
            spacing: root.platformStyle.titleColumnSpacing

            anchors.left:  parent.left
            anchors.right:  parent.right
            anchors.top:  parent.top

            width: root.width

            Item {
                id: titleBarIconField
                height: iconImage.height
                width: parent.width
                Image {
                    id: iconImage
                    anchors.horizontalCenter: titleBarIconField.horizontalCenter
                    source: ""
                }
            }

            Item {
                id: titleBarTextField
                height: titleLabel.height
                width: parent.width

                Text {
                    id: titleLabel
                    width: parent.width

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter

                    font.family: root.platformStyle.titleFontFamily
                    font.pixelSize: root.platformStyle.titleFontPixelSize
                    font.bold:  root.platformStyle.titleFontBold
                    font.capitalization: root.platformStyle.titleFontCapitalization
                    elide: root.platformStyle.titleElideMode
                    wrapMode: elide == Text.ElideNone ? Text.Wrap : Text.NoWrap
                    color: root.platformStyle.titleTextColor
                    text: root.titleText

                }
            }

            // needed for animation
            transform: Scale {
                id: titleScale
                xScale: 1.0; yScale: 1.0
                origin.x: mapFromItem(queryContent, queryContent.width / 2, queryContent.height / 2).x
                origin.y: mapFromItem(queryContent, queryContent.width / 2, queryContent.height / 2).y
            }
        }
    }

    // the content field which contains the message text
    content: Item {
        id: queryContentWrapper

        property int upperBound: visualParent ? visualParent.height - titleField.height - 64
                                                : root.parent.height - titleField.height - 64
        property int __sizeHint: Math.min(Math.max(root.platformStyle.contentFieldMinSize, queryFlickable.height), upperBound)

        height: __sizeHint + root.platformStyle.contentTopMargin
        width: root.width

        Item {
            id: queryContent
            width: parent.width
            y: root.platformStyle.contentTopMargin

            Flickable {
                id: queryFlickable
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                //anchors.bottom: parent.bottom
                height: textInput.height + acceptButton.height
                contentHeight: textInput.height + acceptButton.height
                flickableDirection: Flickable.VerticalFlick
                clip: true

                interactive:  true

                Column {
                    TextField {
                        id: textInput
                        height: 60
                        width: queryFlickable.width
                    }

                    Button {
                        id: acceptButton
                        width: queryFlickable.width
                        text: "Accept"
                        onClicked:  {
                            console.log("accepted: " + textInput.text);
                            root.url= textInput.text
                            accept();
                        }
                        __positiveDialogButton: true
                        platformStyle: ButtonStyle {inverted: true}
                    }
                }




            }

        }
    }


    buttons: Item {

    }

    StateGroup {
        id: statesWrapper

        state: "__query__hidden"

        // needed for button animation
        // without resetting the button row's coordinate system would be translated

        states: [
            State {
                name: "__query__visible"
                when: root.__animationChief == "queryDialog" && (root.status == DialogStatus.Opening || root.status == DialogStatus.Open)
                PropertyChanges {
                    target: root
                    opacity: 1.0
                }
            },
            State {
                name: "__query__hidden"
                when: root.__animationChief == "queryDialog" && (root.status == DialogStatus.Closing || root.status == DialogStatus.Closed)
                PropertyChanges {
                    target: root
                    opacity: 0.0
                }
            }
        ]

        transitions: [
            Transition {
                from: "__query__visible"; to: "__query__hidden"
                SequentialAnimation {
                    ScriptAction {script: __beginTransformationToHidden()}

                    NumberAnimation { target: root; properties: "opacity"; from: 0.0; to: 1.0; duration: 0 }
                    NumberAnimation { target: queryContent; properties: "opacity"; from: 0.0; to: 1.0; duration: 0 }
                    NumberAnimation { target: titleField; properties: "opacity"; from: 0.0; to: 1.0; duration: 0 }

                    // The closing transition fades out the dialog's content from 100% to 0%,
                    // scales down the content to 80% anchored in the center over 175msec, quintic ease in,
                    // then, after a 175ms delay the background fades to alpha 0% (350ms, quintic ease out).
                    // (background fading is done in Fader.qml)

                    ParallelAnimation {
                        NumberAnimation {target: queryContent; properties: "opacity"; from: 1.0; to: 0.0; duration: 175}
                        NumberAnimation {target: titleField; properties: "opacity"; from: 1.0; to: 0.0; duration: 175}
                        NumberAnimation {target: titleScale; properties: "xScale,yScale"; from: 1.0 ; to: 0.8; duration: 175; easing.type: Easing.InQuint}
                        NumberAnimation {target: queryContent; property: "scale"; from: 1.0 ; to: 0.8; duration: 175; easing.type: Easing.InQuint}
                    }

                    ScriptAction {script: __endTransformationToHidden()}

                }
            },
            Transition {
                from: "__query__hidden"; to: "__query__visible"
                SequentialAnimation {
                    ScriptAction {script: __beginTransformationToVisible()}

                    // The opening transition fades in from 0% to 100% and at the same time
                    // scales in the content from 80% to 100%, 350msec, anchored in the center
                    // cubic ease out). --> Done inside the fader

                    ParallelAnimation {
                        NumberAnimation {target: queryContent; properties: "opacity"; from: 0.0; to: 1.0; duration: 350; easing.type: Easing.OutCubic; }
                        NumberAnimation {target: titleField; properties: "opacity"; from: 0.0; to: 1.0; duration: 350; easing.type: Easing.OutCubic; }
                        NumberAnimation {target: titleScale; properties: "xScale,yScale"; from: 0.8 ; to: 1.0; duration: 350; easing.type: Easing.OutCubic; }
                        NumberAnimation {target: queryContent; property: "scale"; from: 0.8 ; to: 1.0; duration: 350; easing.type: Easing.OutCubic; }
                    }

                    ScriptAction {script: __endTransformationToVisible()}
                }
            }
        ]
    }






}
