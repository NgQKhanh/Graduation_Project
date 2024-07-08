import QtQuick 2.15

Item {
    id: root

    //Language ----------------------------------------
    property bool isVN : true;

    property string fBtnHome: isVN ? "Trang chủ" : "Home";
    property string fBtnLogout: isVN ? "Đăng xuất" : "Logout";
    property string fBtnBack: isVN ? "Trở lại" : "Back";
    property string fBtnHelp: isVN ? "Trợ giúp" : "Help";
    property string fBtnAdmin: "Admin";

    property string hBtnNews: isVN ? "Tin tức" : "News";
    property string hBtnSearch: isVN ? "Tra cứu" : "Search";
    property string hBtnBorrow: isVN ? "Mượn sách" : "Borrow";
    property string hBtnReturn: isVN ? "Trả sách" : "Return";

    property string loginHeaderText: isVN ? "Quẹt thẻ để đăng nhập" : "Scan to login";
    property string homeHeaderText: isVN ? "Xin chào: " : "Welcome: ";
    property string borrowHeaderText: isVN ? "Mượn sách" : "Borrow book";
    property string returnHeaderText: isVN ? "Trả sách" : "Return book";
    property string searchHeaderText: isVN ? "Tra cứu" : "Search";
    property string searchDetailHeaderText: isVN ? "Chi tiết" : "Search Detail";
}
