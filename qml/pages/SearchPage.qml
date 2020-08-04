import QtQuick 2.0
import QtQuick.Layouts 1.3
import Felgo 3.0


Page {
    id: searchPage
    property alias searchInput: searchInput
    title: qsTr("Property Cross")

    rightBarItem: NavigationBarRow {

        ActivityIndicatorBarItem {
            visible: true
            animating: false
        }

        IconButtonBarItem {
            icon: IconType.heart
            title: qsTr("Favourites")

            onClicked: showListings(true)
        }
    }

    Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: contentPadding
        spacing: contentPadding

        AppText {
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(12)
            text: qsTr("Use the form below to search for houses to buy. You can search by place name, postcode or click 'My location'.")
        }

        AppText {
            width: parent.width
            font.pixelSize: sp(12)
            font.italic: true
            color: Theme.secondaryTextColor
            text: qsTr("Hint: You can quickly find something by typing 'London'...")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        AppTextField {
            id: searchInput
            width: parent.width
            placeholderText: qsTr("Search...")
            showClearButton: true
            inputMethodHints: Qt.ImhNoPredictiveText

            onTextChanged: {
                console.debug(text)
                showRecentSearches()
            }
            onEditingFinished: if(navigationStack.currentPage === searchPage) search()
        }

        Row {
            spacing: contentPadding
            layoutDirection: Qt.LeftToRight

            AppButton {
                id: goBtn
                text: qsTr("Go")
                fontCapitalization: Font.Capitalize
                onClicked: search()
            }

            AppButton {
                id: locBtn
                fontCapitalization: Font.Capitalize
                text: qsTr("Get my location")
                enabled: true

                onClicked: {
                    searchInput.text = ""
                    searchInput.placeholderText = qsTr("Looking for location...")
                    locBtn.enabled = false
                }
            }
        }
    }

    function showRecentSearches() {
    }

    function search() {
        logic.searchListings(searchInput.text, true)
    }

    function showListings(favourites){
        if (navigationStack.depth === 1) {
            navigationStack.popAllExceptFirstAndPush(listPageComponent, {favourites: favourites})
        }
    }

    Component {
        id: listPageComponent
        ListingsListPage {}
    }

    Connections {
        target: dataModel
        onListingsReceived: showListings(false)
    }
}
