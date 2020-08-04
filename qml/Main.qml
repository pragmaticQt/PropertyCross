import Felgo 3.0
import QtQuick 2.0
import "pages"
import "model"

App {

    readonly property real contentPadding: dp(Theme.navigationBar.defaultBarItemPadding)

    NavigationStack {

        SearchPage {}

    }

    DataModel {
        id: dataModel
        dispatcher: logic
    }

    Logic {
        id: logic
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
