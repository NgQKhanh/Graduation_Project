import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import com.example.uartreader 1.0

Rectangle {
    width: parent.width - 40
    height: parent.height - 40
    anchors.centerIn: parent
    color: "lightgrey"
    border.color: "darkgrey"
    border.width: 2
    radius: 10

    Rectangle{
        width: parent.width
        height: 200
        color: Qt.rgba(0,0,0,0)
        anchors{
            left: parent.left
            leftMargin: 50
            top: parent.top
            topMargin: 50
        }

        ColumnLayout{
            width: parent.width
            height: parent.height
            spacing: 10

            // Setup UART Section
            Rectangle {
                Text {
                    text: "Setup UART: "
                }
            }

            RowLayout {
                ComboBox {
                    id: portComboBox
                    width: parent.width
                    model: uartReader.availablePorts
                    onCurrentTextChanged: {
                        uartReader.portName = currentText
                    }
                }
                Button {
                    text: "Open Port"
                    onClicked: uartReader.openPort()
                }
                Button {
                    text: "Close Port"
                    onClicked: uartReader.closePort()
                }
            }

            // Change Language Section
            RowLayout {
                Rectangle {
                    width: 100
                    Text {
                        text: "Change language: "
                    }
                }
                ComboBox {
                    width: 150
                    model: ["Việt Nam", "English"]
                    onCurrentTextChanged: {
                        if (currentText === "Việt Nam") {
                            def.isVN = true
                        } else if(currentText === "English"){
                            def.isVN = false
                        }
                    }
                    delegate: ItemDelegate {
                        text: modelData
                    }
                }
            }
        }
    }

    // Setup function to initialize page
    function setup() {
        console.log("Nav => AdminPage")
        header.welcomeText = "Admin"
        funcBar.adminBtnEnable = false
        funcBar.homeBtnEnable = false
        funcBar.backBtnEnable = true
        funcBar.logoutBtnEnable = true
    }

    Component.onCompleted: {
        setup()
    }
}
