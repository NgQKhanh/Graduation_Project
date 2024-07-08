import QtQuick 2.15


Item {
    id: common

    property string libraryName: "Thư viện Trường Điện - Điện Tử"
    property int maxBorrow: 5

    property bool _isLogin: false
    property string _userID: ""
    property string _username: ""

    readonly property bool isLogin: _isLogin
    readonly property string userID: _userID
    readonly property string username: _username

    property string defaultPortName: "COM5"
    property int startupPeriod: 2000


    property string baseUrl: "http://localhost:3000/app"
    property string loginUrl: "/RFIDlogin"
    property string searchUrl: "/search"
    property string confirmBorrowUrl: "/confirmBorrow"
    property string confirmReturnUrl: "/confirmReturn"
    property string getBookNameUrl: "/bookName"

    function login(id, user) {
        _username = user
        _userID = id
        _isLogin = true
    }

    function logout() {
        _username = ""
        _userID = ""
        _isLogin = false
    }
}

