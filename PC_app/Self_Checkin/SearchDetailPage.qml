import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

Item {

    id : searchDetailPage
    property var id
    property var title
    property var author
    property var category
    property var publisher

    ListModel {
        id: bookCopyList
    }

    Rectangle {
        width: parent.width - 40
        height: parent.height - 40
        anchors.centerIn: parent
        radius: 10

        Row {
            width: parent.width
            height: parent.height
            spacing: 20

            Column {
                id : info
                width: parent.width/2 - 150
                height: parent.height
                anchors {
                    left: parent.left
                    leftMargin: 20
                    top: parent.top
                    topMargin: 20
                }

                Text {
                    text: title
                    color: "darkblue"
                    font.bold: true
                    font.pointSize: 20
                }
                Text {
                    text: "Tác giả: "
                    color: "blue"
                    font.bold: true
                    font.pointSize: 16
                }
                Text {
                    text: author
                    color: "black"
                    font.pointSize: 14
                }
                Text {
                    text: "Nhà xuất bản: "
                    color: "blue"
                    font.bold: true
                    font.pointSize: 16
                }
                Text {
                    text: publisher
                    color: "black"
                    font.pointSize: 14
                }
                Text {
                    text: "Mô tả: "
                    color: "blue"
                    font.bold: true
                    font.pointSize: 16
                }
                Text {
                    text: category
                    color: "black"
                    font.pointSize: 14
                }
            }

            Column{
                width: parent.width/2 + 100
                height: parent.height
                anchors {
                    left: info.right
                    leftMargin: 20
                    top: parent.top
                    topMargin: 20
                }
                spacing: 0

                Row{
                    width: parent.width
                    height: 50
                    Rectangle {
                        id : col1
                        width: parent.width / 3 - 80
                        height: 50
                        color: "lightblue"
                        border.color: "grey"
                        border.width: 1
                        Text {
                            text: "STT"
                            font.bold: true
                            font.pointSize: 12
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle {
                        id : col2
                        width: parent.width / 3 + 40
                        height: 50
                        color: "lightblue"
                        border.color: "grey"
                        border.width: 1
                        Text {
                            text: "Vị trí"
                            font.bold: true
                            font.pointSize: 12
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle {
                        id : col3
                        width: parent.width / 3 + 40
                        height: 50
                        color: "lightblue"
                        border.color: "grey"
                        border.width: 1
                        Text {
                            text: "Trạng thái"
                            font.bold: true
                            font.pointSize: 12
                            anchors.centerIn: parent
                        }
                    }
                }

                Rectangle {
                    id : dataShow
                    width: parent.width
                    height: parent.height - 100
                    color: "lightgray"
                    border.color: "grey"
                    border.width: 1
                    radius: 5

                    ListView {
                        id: resultsList
                        width: parent.width
                        height: parent.height
                        clip: true
                        model: bookCopyList

                        delegate: Item {
                            width: ListView.view.width
                            height: 50

                            Rectangle {
                                id : stt
                                width: parent.width/3 - 80
                                height: parent.height
                                anchors{
                                    left: parent.left
                                    top: parent.top
                                }
                                color: "white"
                                border.color: "grey"
                                border.width: 1
                                Text {
                                    text: index + 1
                                    font.pointSize: 12
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle {
                                id : statusID
                                width: parent.width/3 + 40
                                height: parent.height
                                anchors{
                                    left: stt.right
                                    top: parent.top
                                }
                                color: "white"
                                border.color: "grey"
                                border.width: 1
                                Text {
                                    text: model.location
                                    font.pointSize: 12
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle {
                                id : locationID
                                width: parent.width/3 + 40
                                height: parent.height
                                anchors{
                                    left: statusID.right
                                    top: parent.top
                                }
                                color: "white"
                                border.color: "grey"
                                border.width: 1
                                Text {
                                    text: model.status
                                    font.pointSize: 12
                                    anchors.centerIn: parent
                                }
                            }
                        }
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AlwaysOn
                        }
                    }
                }
            }
        }
    }

    function setup() {
        console.log("Nav => SearchDetailPage")
        header.welcomeText = def.searchDetailHeaderText
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

        searchBooks(id)
    }

    function searchBooks(id){
        var xhr = new XMLHttpRequest();
        var url = common.baseUrl + common.searchUrl + "?type=copy&id=" + id;
        xhr.open("GET", url);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    bookCopyList.clear()
                    for (var i = 0; i < response.list.length; i++) {
                        var book = response.list[i]
                        var status;
                        if(0 === book.status) {
                            status = qsTr("Có sẵn")
                        }else if(1 === book.status){
                            status = qsTr("Đang mượn")
                        }

                        bookCopyList.append({
                            bookID: book.bookID,
                            status: status,
                            location: book.location
                        })
                    }
                }
                else if (xhr.status === 404) {
                    announcement.show("Không tìm thấy dữ liệu!")
                    console.error("[SearchDetail] Request failed with status: " + xhr.status);
                } else {
                    announcement.show("Có lỗi xảy ra: " + xhr.status)
                    console.error("[SearchDetail]  Request failed with status: " + xhr.status);
                }
            }
        };
        xhr.send();
    }

    Component.onCompleted: {
        setup()
    }
}
