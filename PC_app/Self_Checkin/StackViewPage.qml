import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    ListModel {
        id: listModel
        ListElement { name: "Search Detail"; page: "SearchDetailPage.qml" }
    }

    GridView {
        id: gridView
        anchors.fill: parent
        model: listModel
        cellHeight: 240
        cellWidth: 240
        delegate: Rectangle {
            width: 200
            height: 200
            color: "grey"
            radius: 5
            Text {
                color: "white"
                text: name
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: mainLoader.source = page
            }
        }
    }

    Button {
        text: "Send POST Request"
        anchors.centerIn: parent
        onClicked: {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        console.log("Response:", xhr.responseText);

                        try {
                            var responseObject = JSON.parse(xhr.responseText);
                            console.log("Username:", responseObject.username);
                            header.welcomeText = responseObject.username;
                            // Xử lý dữ liệu phản hồi ở đây
                        } catch (e) {
                            console.error("Error parsing JSON:", e);
                            // Xử lý lỗi phân tích JSON
                        }
                    } else {
                        console.error("Request failed:", xhr.statusText);
                        // Xử lý lỗi yêu cầu
                    }
                }
            };

            var url = "http://localhost:3000/app/login";
            var params = "username=k&password=1"; // Dữ liệu POST

            xhr.open("POST", url, true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhr.send(params);
        }
    }

    function setup() {
        header.welcomeText = "Search Document"
        funcBar.adminBtnEnable = false
        funcBar.homeBtnEnable = true
        funcBar.backBtnEnable = true

        if(true === funcBar.isLogin){
            funcBar.logoutBtnEnable = true
            funcBar.setHomePage = "HomePage.qml"
        } else {
            funcBar.logoutBtnEnable = false
            funcBar.setHomePage = "LoginPage.qml"
        }


    }

    Component.onCompleted: {
        setup()
    }
}
