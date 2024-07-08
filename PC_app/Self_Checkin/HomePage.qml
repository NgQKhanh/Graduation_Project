import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    id : homepage

    ListModel {
        id: listModel
        ListElement { name: "Tin tức"; page: "NewsPage.qml"; icon: "qrc:/Items/news_icon.png" }
        ListElement { name: "Tra cứu"; page: "SearchPage.qml"; icon: "qrc:/Items/search_icon.png" }
        ListElement { name: "Của tôi"; page: "MyItemsPage.qml"; icon: "qrc:/Items/myAccount_icon.png" }
        ListElement { name: "Mượn sách"; page: "BorrowPage.qml"; icon: "qrc:/Items/borrow_icon.png" }
        ListElement { name: "Trả sách"; page: "ReturnPage.qml"; icon: "qrc:/Items/return_icon.png" }
    }

    GridView {
        id: gridView
        width: parent.width - 50
        height: parent.height - 50
        anchors.centerIn: parent
        model: listModel
        cellHeight: gridView.height/2
        cellWidth: gridView.width/3
        delegate: delegate
    }

    Component {
        id : delegate
        Item{
            height: gridView.height/2
            width: gridView.width/3

            HomePageBigButton{
                height: parent.height - 50
                width: parent.width - 50
                anchors.centerIn: parent
                buttonText: name
                imageSource: icon
                onClicked: stackView.push(page,StackView.Immediate)
            }
        }
    }

    function setup() {
        console.log("Nav => HomPage")
        header.welcomeText = qsTr("Xin chào: ") + common.username
        funcBar.isLogin = true
        funcBar.adminBtnEnable = true
        funcBar.homeBtnEnable = false
        funcBar.backBtnEnable = false
        funcBar.logoutBtnEnable = true
        funcBar.setHomePage = "HomePage.qml"
    }

    Component.onCompleted: {
        setup()
    }
}
