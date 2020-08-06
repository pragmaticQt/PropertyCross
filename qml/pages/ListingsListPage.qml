import QtQuick 2.0
import Felgo 3.0

ListPage {

    id: listPageWrapper

    property var scrollPos: null
    property bool favourites

    rightBarItem: ActivityIndicatorBarItem {
        visible: dataModel.loading
    }

    model: JsonListModel {
        id: listModel
        source: favourites ? dataModel.favouriteListings : dataModel.listings
        fields: ["text", "detailText", "image", "model"]
    }

    title: favourites ? qsTr("Favourites") : qsTr("%1 of %2 matches").arg(dataModel.numListings).arg(dataModel.numTotalListings)

    emptyText.text: favourites ? qsTr("No favourites chosen") : qsTr("No listings available")

    Component {
        id: detailPageComponent
        ListingsDetailPage {}
    }

    delegate: SimpleRow {
        item: listModel.get(index)
        autoSizeImage: true
        imageMaxSize: dp(40)
        image.fillMode: Image.PreserveAspectCrop

        onSelected: navigationStack.push(detailPageComponent, {model: item.model})
    }

    listView.footer: VisibilityRefreshHandler {
        visible: !favourites && dataModel.numListings < dataModel.numTotalListings
        onRefresh: {
            scrollPos = listView.getScrollPosition()
            logic.loadNextPage()
        }
    }

}
