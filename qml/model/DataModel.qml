import QtQuick 2.0
import Felgo 3.0

Item {
    property alias dispatcher: logicConnection.target
    readonly property var listings: _.createListingsModel(_.listings)
    readonly property alias loading: client.loading
    readonly property alias numTotalListings: _.numTotalListings
    readonly property int numListings: _.listings.length

    signal listingsReceived

    HttpClient {
        id: client
    }

    Connections {
        id: logicConnection

        onSearchListings: {
            client.search(searchText, _.responseCallback)
        }
    }

    Item {
        id: _

        readonly property var successCodes: ["100", "101", "110"]
        readonly property var ambiguousCodes: ["200", "202"]
        property var locations: []
        property var listings: []
        property int numTotalListings: 0
        property int currentPage: 1

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
                listings = response.listings//listings.concat(response.listings)
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
}
