import QtQuick 2.0
import Felgo 3.0
import Qt.labs.settings 1.1

Item {
    property alias dispatcher: logicConnection.target
    readonly property var listings: _.createListingsModel(_.listings)
    readonly property alias loading: client.loading
    readonly property alias numTotalListings: _.numTotalListings
    readonly property int numListings: _.listings.length
    readonly property var favouriteListings: _.createListingsModel(_.favouriteListings, true)

    signal listingsReceived

    Settings {
        property string favListings: JSON.stringify(_.favouriteListings)

        Component.onCompleted: {
            _.favouriteListings = favListings && JSON.parse(favListings) || []
        }
    }

    HttpClient {
        id: client
    }

    Connections {
        id: logicConnection

        onSearchListings: {
            _.reset()
            client.search(searchText, _.responseCallback)
        }

        onLoadNextPage: {
            client.repeatForPage(_.currentPage + 1, _.responseCallback)
        }

        onToggleFavourite: {
            var listingDataStr = JSON.stringify(listingData)
            var index = _.favouriteListings.indexOf(listingDataStr)
            if (index === -1) {
                console.debug("Listing added")
                _.favouriteListings.push(listingDataStr)
            } else {
                console.debug("Listing removed")
                _.favouriteListings.splice(index, 1)
            }

            _.favouriteListingsChanged()
        }
    }

    Item {
        id: _

        readonly property var successCodes: ["100", "101", "110"]
        readonly property var ambiguousCodes: ["200", "202"]
        property var locations: []
        property var listings: []
        property var favouriteListings: []
        property int numTotalListings: 0
        property int currentPage: 1

        function reset() {
            listings = []
        }

        function createListingsModel(source, parseValues) {
            return source.map(function(data) {

                      if (parseValues) data = JSON.parse(data)

                      return {
                          text: data.price_formatted,
                    detailText: data.title,
                         image: data.thumb_url,
                         model: data
                      }
            })
        }

        function responseCallback(obj) {
            var response = obj.response
            var code = response.application_response_code
            console.debug("Server returned code: ", code)

            if (successCodes.indexOf(code) >= 0) {//location found
                currentPage = parseInt(response.page)
                listings = listings.concat(response.listings)
                numTotalListings = response.total_results || 0

                listingsReceived()

            } else if (ambiguousCodes.indexOf(code) >= 0) {
                locations = response.locations
            } else if (code === "210") {
                locations = []
            } else {
                locations = []
            }
        }
    }

    function isFavourite(listingsData) {
        return _.favouriteListings.indexOf(JSON.stringify(listingsData)) !== -1
    }
}
