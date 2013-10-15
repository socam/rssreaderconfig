import QtQuick 1.1
import com.nokia.meego 1.0
import "storage.js" as Storage

Rectangle {

    id:templateCell
    property int index
    property string feedURL

    signal click();

    onClick:  {
        console.log("TemplateCell.onClick() templateRenderer=" + templateRenderer + " templateRenderer.file=" + templateRenderer.templateFile);
        templateRenderer.click(index);
    }

    Component.onCompleted: {
        console.log("TemplateCell.onCompleted: preview=" + templateRenderer.preview);
    }

    /*
    MouseArea {

        anchors.fill: parent

        onPressAndHold: {
            console.log("PressAndHold cell!!! " + index + " container=" + templateRenderer.template);
            if(!templateRenderer.preview) {
                templateCellContent.pressAndHold();
            }
        }

        onClicked: {
            console.log("Clicked cell!!! " + index + " container=" + templateRenderer.template);
            if(templateRenderer.preview) {
                templateCellPreview.click();
            } else {
                templateCellContent.click();
            }
        }

    }

    */

    TemplateCellContent {
        visible: !templateRenderer.preview
        enabled: !templateRenderer.preview
    }

    TemplateCellPreview {
        visible: templateRenderer.preview
    }




}
