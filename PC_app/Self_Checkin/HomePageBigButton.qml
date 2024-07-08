import QtQuick
import QtQuick.Layouts

Rectangle {
    id: hpbutton
    width: parent.width
    height: parent.height
    radius: 15

    property alias buttonText: buttonTextId.text
    property alias imageSource: background.source

    signal clicked()

    // gradient: Gradient {
    //     GradientStop { position: 0; color: "white" }
    //     GradientStop { position: 1; color: "#B9A9A9" }
    // }
        color: Qt.rgba(0,0,0,0)
    Image {
        width: parent.width
        height: parent.height
        source: "qrc:/Items/blue_button.png"
    }

    // border{
    //     color: "#888888"
    //     width: 2
    // }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            hpbutton.clicked()
        }
    }
    Row {
        anchors.centerIn:  parent
        spacing: 20
        Image {
            id: background
            width: 50
            height: 50
            source: hpbutton.imageSource
        }
        Text {
            id: buttonTextId
            text: buttonText
            //anchors.centerIn: parent
            font.bold: true
            font.pointSize: 20
            color: "black"
        }
    }


}

