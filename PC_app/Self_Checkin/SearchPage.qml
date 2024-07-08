import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

Item {
    width: parent.width
    height: parent.height

    ListModel {
        id: bookList
    }

    Rectangle {
        id : searchPage
        width: parent.width - 40
        height: parent.height - 40
        anchors.centerIn: parent
        radius: 10
        color: "lightgrey"
        border.color: "darkgrey"
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                TextField {
                    id: keyword
                    font.pointSize: 12
                    placeholderText: "Nhập từ khoá"
                    verticalAlignment: TextInput.AlignVCenter
                    leftPadding: 24
                    maximumLength: 200
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 400
                }

                ListModel {
                    id : listField
                    ListElement { text: "Tiêu đề"; name: "bookName"}
                    ListElement { text: "Tác giả"; name: "author"}
                    ListElement { text: "Thể loại"; name: "category"}
                    ListElement { text: "Nhà xuất bản"; name: "pulisher"}
                }

                ComboBox {
                    id: category
                    font.pointSize: 12
                    leftPadding: 24
                    model: ["Tiêu đề", "Tác giả", "Phân loại", "Nhà xuất bản"]
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 50
                    delegate: ItemDelegate {
                        width: 150
                        height: 40
                        Text {
                            leftPadding: 24
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData
                            font.pointSize: 12
                        }
                        background: Rectangle {
                            border.color: "#ccc"
                            border.width: 1
                        }
                    }
                }

                FunctionButton {
                    id : btnSearch
                    buttonText: "Tìm kiếm"
                    onClicked: {
                        searchTitleBooks(keyword.text,listField.get(category.currentIndex).name)
                        console.log("Search keyword:", keyword.text)
                        console.log("Search category:", listField.get(category.currentIndex).name)
                    }
                }
            }

            Rectangle {
                id : dataShow
                width: parent.width - 200
                height: parent.height - 100
                Layout.alignment: Qt.AlignHCenter
                border.color: "grey"
                border.width: 1
                radius: 5

                ListView {
                    id: resultsList
                    width: parent.width
                    height: parent.height
                    clip: true
                    model: bookList

                    delegate: Item {
                        width: ListView.view.width
                        height: 80

                        Rectangle {
                            id : info
                            width: parent.width
                            height: parent.height
                            anchors{
                                left: parent.left
                                top: parent.top
                            }
                            color: "white"
                            border.color: "grey"
                            border.width: 1
                            Column {
                                spacing: 5
                                anchors{
                                    left: parent.left
                                    leftMargin: 20
                                    verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: model.title
                                    font.bold: true
                                    font.pointSize: 12
                                }
                                Text {
                                    text: model.author
                                    font.italic: true
                                    font.pointSize: 12
                                }
                            }
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                onClicked: {
                                    stackView.push("SearchDetailPage.qml",
                                                   {"id": model.id,"title": model.title,"author":model.author,"publisher":publisher,"category":category}
                                                   ,StackView.Immediate)
                                }
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

    function setup() {
        console.log("Nav => SearchPage")
        header.welcomeText = def.searchHeaderText
        funcBar.adminBtnEnable = false
        funcBar.homeBtnEnable = false
        funcBar.backBtnEnable = true

        if(true === funcBar.isLogin){
            funcBar.logoutBtnEnable = true
            funcBar.setHomePage = "HomePage.qml"
        } else {
            funcBar.logoutBtnEnable = false
            funcBar.setHomePage = "LoginPage.qml"
        }
    }

    function searchTitleBooks(key, field){
        var xhr = new XMLHttpRequest();
        var url = common.baseUrl + common.searchUrl + "?type=title&key=" + key + "&field=" + field;
        xhr.open("GET", url);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    bookList.clear()
                    for (var i = 0; i < response.list.length; i++) {
                        var book = response.list[i]
                        bookList.append({
                            id: book.id,
                            title: book.bookName,
                            author: book.author,
                            publisher: book.publisher,
                            category: book.category
                        })
                    }
                }
                else if (xhr.status === 404) {
                    announcement.show("Không tìm thấy dữ liệu!")
                    console.error("[SearchPage] Request failed with status: " + xhr.status);
                } else {
                    announcement.show("Có lỗi xảy ra: " + xhr.status)
                    console.error("[SearchPage]  Request failed with status: " + xhr.status);
                }
            }
        };
        xhr.send();
    }

    Component.onCompleted: {
        setup()
    }
}
