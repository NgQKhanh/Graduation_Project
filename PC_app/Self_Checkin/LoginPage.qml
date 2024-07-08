import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.example.uartreader 1.0

Item {
    id : loginPage
    ListModel {
        id: listModel
        ListElement { name: "Tin tức" ; page: "HomePage.qml"; icon: "qrc:/Items/news_icon.png" }
        ListElement { name: "Tra cứu"; page: "SearchPage.qml"; icon: "qrc:/Items/search_icon.png" }
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
                onClicked: {
                    stackView.push(page,StackView.Immediate) }
            }
        }
    }

    function processUARTSignal(userId){
        var xhr = new XMLHttpRequest();
        var url = common.baseUrl + common.loginUrl;
        xhr.open("POST", url);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    console.log("[LoginPage] User login: ", response.username);
                    common.login(userId,response.username);
                    stackView.push("HomePage.qml",StackView.Immediate)
                }
                else if (xhr.status === 404) {
                    announcement.show("Người dùng chưa đăng ký!")
                    console.error("[LoginPage] Request failed with status: " + xhr.status);
                } else {
                    announcement.show("Có lỗi xảy ra: " + xhr.status)
                    console.error("[LoginPage]  Request failed with status: " + xhr.status);
                }
            }
        };
        var sendData = JSON.stringify({ "userId": userId });
        xhr.send(sendData);
    }

    function setup() {
        console.log("Nav => LoginPage")
        header.welcomeText = def.loginHeaderText
        funcBar.isLogin = false
        funcBar.adminBtnEnable = true
        funcBar.homeBtnEnable = false
        funcBar.backBtnEnable = false
        funcBar.logoutBtnEnable = false
    }

    Component.onCompleted: {
        setup()
    }
}
