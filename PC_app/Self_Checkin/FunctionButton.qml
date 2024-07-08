import QtQuick 2.15

Rectangle {
    id : funcBtn
    width: 150
    height: 50
    color : "blue"
    property alias buttonText: buttonTextId.text
    signal clicked()

    gradient: Gradient {
        GradientStop { position: 0; color: "white" }
        GradientStop { position: 1; color: "#B9A9A9" }
    }

    border{
        color: "#888888"
        width: 2
    }

    Text {
        id: buttonTextId
        text: buttonText
        anchors.centerIn: parent
        font.bold: true
        font.pointSize: 12
        color: "#222222"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            funcBtn.clicked()
        }
        onPressed: {
            funcBtn.scale = 0.95
        }
        onReleased: {
            funcBtn.scale = 1.0
        }
    }
}
