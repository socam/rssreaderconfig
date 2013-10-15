import QtQuick 1.1
import es.zed.socam.rssreader 1.0

Item {

	anchors.fill: parent


	Cell {
		id: first
		index: 1
		anchors {
			top: parent.top
			left: parent.left
		}
		width: parent.width
        height: parent.height/3

	}

	Cell {
		id: second
		index: 2
		anchors {
			top: first.bottom
			left: parent.left
		}
		width: parent.width
        height: parent.height/3

	}


	Cell {
              	index: 3
                anchors {
                        top: second.bottom
                        left: parent.left
                }
                width: parent.width
                height: parent.height/3

        }


}

