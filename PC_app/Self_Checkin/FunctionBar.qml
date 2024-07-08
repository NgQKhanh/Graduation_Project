import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: funcBar
    height: 72
    width: parent.width
    anchors {
        left: parent.left
        bottom: parent.bottom
        bottomMargin: 10
        right: parent.right
    }
    property string setHomePage
    property bool adminBtnEnable
    property bool logoutBtnEnable
    property bool homeBtnEnable
    property bool backBtnEnable
    property bool isLogin

    signal backClick

    color: Qt.rgba(0,0,0,0)

    Rectangle {
        width: parent.width - 40
        height: 3
        color: "orange"
        anchors {
            top: funcBar.top
            horizontalCenter: parent.horizontalCenter
        }
    }

    Row {
        id: buttonRow
        spacing: 2
        anchors {
            left: parent.left
            leftMargin: 20
            bottom: parent.bottom
            bottomMargin: 10
        }

        FunctionButton{
            id: logoutBtn
            buttonText: def.fBtnLogout
            visible: logoutBtnEnable
            onClicked: stackView.push("LoginPage.qml",StackView.Immediate)
        }

        FunctionButton{
            id: homeBtn
            buttonText: def.fBtnHome
            visible: homeBtnEnable
            onClicked: stackView.push(setHomePage,StackView.Immediate)
        }

        FunctionButton{
            id: backBtn
            buttonText: def.fBtnBack
            visible: backBtnEnable
            onClicked: backClick()
        }

        FunctionButton{
            id: helpBtn
            buttonText: def.fBtnHelp
            //visible: backBtnEnable
            //onClicked: backClick()
        }
    }

    FunctionButton{
        id: adminBtn
        buttonText: def.fBtnAdmin
        visible: adminBtnEnable
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
        }
        onClicked: stackView.push("AdminPage.qml",StackView.Immediate)
    }
}
