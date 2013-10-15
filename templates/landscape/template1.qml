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
		width: parent.width/2
		height: parent.height

	}

	Cell {
		id: second
		index: 2
		anchors {
			top: parent.top
			left: first.right
		}
		width: parent.width/2
		height: parent.height/2

	}


	Cell {
              	index: 3
                anchors {
                        top: second.bottom
                        left: first.right
                }
                width: parent.width/2
                height: parent.height/2

        }


}

