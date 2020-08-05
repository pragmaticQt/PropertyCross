import QtQuick 2.0
import Felgo 3.0

Page {

    property var model: ({})
    readonly property bool isFavourite: true //dataModel.isFavourite(model)

    title: qsTr("Property details")

    rightBarItem: IconButtonBarItem {
        icon: isFavourite ? IconType.heart : IconType.hearto
        onClicked: {
            logic.toggleFavourite(model)
        }
    }

    clip: true

    Flickable {
        id: scroll
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentCol.height + contentPadding
        bottomMargin: contentPadding

        Column {
            id: contentCol
            y: contentPadding
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: contentPadding
            spacing: contentPadding

            AppText {
                text: model.price_formatted
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: sp(24)
            }

            AppText {
                text: model.title
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: sp(20)
            }

            AppImage {
                source: model.img_url
                width: parent.width
                height: model && width * model.img_height / model.img_width || 0
                anchors.horizontalCenter: parent.horizontalCenter
            }

            AppText {
                text: "%1 bed, %2 bathrooms".arg(model.bedroom_number).arg(model.bathroom_number)
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            AppText {
                text: model.summary
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
        ScrollIndicator {
            flickable: scroll
        }
    }
}
