import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import com.example.uartreader 1.0

Window {
    id : root
    visible: true
    width: 1024
    height: 680
    title: qsTr("Self Service")
    property bool isStart: true

    Timer {
        id: startupDelay
        interval: 2000
        repeat: false
        running: true
        onTriggered: {
            root.isStart = false
        }
    }

    Definition{
        id: def
    }

    Common{
        id: common
    }

    Image {
        id: background
        width: parent.width
        height: parent.height
        source: "qrc:/Items/background.PNG"
    }

    Header{
        id : header
        welcomeText : qsTr("Quẹt thẻ để đăng nhập")
        libraryName: common.libraryName
    }

    Rectangle{
        id : mainLoader
        color: Qt.rgba(0,0,0,0)
        anchors{
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: funcBar.top
        }
        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: "LoginPage.qml"

            function handleUARTSignal(data) {
                var currentQMLItem = stackView.currentItem;
                if (currentQMLItem && typeof currentQMLItem.processUARTSignal === "function") {
                    currentQMLItem.processUARTSignal(data);
                }
            }
        }
    }

    FunctionBar {
        id: funcBar
        onBackClick : {
            stackView.pop(StackView.Immediate)
            stackView.currentItem.setup()
        }
    }

    MessageDialog {
        id: announcement
        title: qsTr("Thông báo")
        buttons: MessageDialog.Close
        text: annText
        property string annText

        function show(text){
            announcement.annText = text
            announcement.open()
        }
    }

    UartReader {
        id: uartReader
        portName: "COM3"
        baudRate: 115200
        onDataReceived: {
            if(false === root.isStart){
                stackView.handleUARTSignal(data)
            }
        }
    }

    Component.onCompleted: {
        uartReader.portName = common.defaultPortName
        uartReader.openPort()
    }
}
