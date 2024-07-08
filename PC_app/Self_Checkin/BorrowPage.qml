import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Dialogs

Item {
    id: borrowPage

    property int count: 0
    property int currentSelected

    ListModel {
        id: bList
    }

    Rectangle {
        width: parent.width - 40
        height: parent.height - 40
        anchors.centerIn: parent
        color: "lightgrey"
        border.color: "darkgrey"
        border.width: 2
        radius: 10

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            Rectangle {
                id : headSeaction
                width: parent.width - 200
                anchors.horizontalCenter: parent.horizontalCenter
                height: 50
                color: Qt.rgba(0,0,0,0)

                Text {
                    anchors{
                        left: parent.left
                    }
                    font.pointSize: 20
                    font.bold: true
                    text: qsTr("Danh sách mượn: ")
                    verticalAlignment: TextInput.AlignVCenter
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 400
                }

                FunctionButton {
                    anchors{
                        right: parent.right
                    }
                    buttonText: qsTr("Hoàn tất")
                    onClicked: {
                        borrowPage.sendBorrowList()
                    }
                }
            }

            Rectangle {
                id : result
                width: parent.width - 200
                height: parent.height - 100
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "grey"
                border.width: 1

                ListView {
                    id: resultsList
                    width: parent.width
                    height: parent.height
                    clip: true
                    model: bList

                    delegate: Item {
                        width: ListView.view.width
                        height: 70

                        Rectangle {
                            id : info
                            width: parent.width
                            height: parent.height
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
                                    font.pointSize: 12
                                    font.bold: true
                                }
                                Text {
                                    text: model.author
                                    font.pointSize: 12
                                    font.italic: true
                                }
                            }
                            Rectangle {
                                width: 30
                                height: 30
                                radius: 10
                                color: "red"
                                Text {
                                    text: qsTr("X")
                                    font.pointSize: 12
                                    font.bold: true
                                    color: "white"
                                    anchors.centerIn: parent
                                }
                                anchors {
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                    rightMargin: 30
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        borrowPage.currentSelected = index
                                        notice.text = qsTr("Xác nhận huỷ " + bList.get(index).title)
                                        notice.open()
                                    }
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

    MessageDialog {
        id: notice
        property string diaText
        title: qsTr("Xác nhận")
        text: "diaText"

        buttons: MessageDialog.Cancel | MessageDialog.Ok

        onAccepted: { borrowPage.removeModel(bList,borrowPage.currentSelected) }

        onRejected: {}
    }

    function processUARTSignal(id){
        console.log("[BorrowPage]  UART received: " + id)
        if(true === isValid(id)){
            getBookTitle(id)
        }
    }

    function isValid(bookID) {
        for (var i = 0; i < bList.count; i++) {
            if(bookID === bList.get(i).id) {
                announcement.show(qsTr("Trùng lặp tài liệu đã chọn!"))
                return false
            }
        }
        if(bList.count >= common.maxBorrow){
            announcement.show(qsTr("Vượt quá số lượng"))
            return false
        }
        return true;
    }

    function getBookTitle(bookID){
        var xhr = new XMLHttpRequest();
        var url = common.baseUrl + common.getBookNameUrl+ "?bookID="+bookID;
        xhr.open("GET", url);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    borrowPage.addModel(bList,bookID,response.bookName,response.author)
                }
                else if (xhr.status === 404) {
                    announcement.show("Không tìm thấy dữ liệu!")
                    console.error("[BorrowPage] Request failed with status: " + xhr.status);
                } else {
                    announcement.show("Có lỗi xảy ra: " + xhr.status)
                    console.error("[BorrowPage]  Request failed with status: " + xhr.status);
                }
            }
        };
        xhr.send();
    }

    function setup() {
        console.log("Nav => BorrowPage")
        header.welcomeText = def.borrowHeaderText
        funcBar.adminBtnEnable = false
        funcBar.homeBtnEnable = false
        funcBar.backBtnEnable = true
        funcBar.logoutBtnEnable = true
        funcBar.setHomePage = "HomePage.qml"
    }

    function sendBorrowList(){
        var jsonArray = [];
        for (var i = 0; i < bList.count; i++) {
            var item = bList.get(i);
            jsonArray.push(item.id);
        }

        var xhr = new XMLHttpRequest();
        var url = common.baseUrl + common.confirmBorrowUrl;
        xhr.open("POST", url);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    announcement.show("Mượn sách thành công!")
                    console.error("[BorrowPage] Borrow Success!");
                    bList.clear()
                } else {
                    announcement.show("Có lỗi xảy ra!")
                    console.error("[BorrowPage] Request failed with status: " + xhr.status);
                }
            }
        };
        var sendData = JSON.stringify({ "userID": common.userID, "bList": jsonArray});
        xhr.send(sendData);
    }

    function addModel (model, id, title, author) {
        model.append( { id: id, title : title, author : author } )
    }

    function removeModel (model, index) {
        model.remove( index )
    }

    Component.onCompleted: {
        setup()
    }
}
