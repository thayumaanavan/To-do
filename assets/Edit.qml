import bb.cascades 1.0
import bb.system 1.0
Sheet {
    id: editSheet

    // Custom properties
    property alias title: addBar.title
    property alias hintText: itemText.hintText
    property alias text: itemText.text

    // A custom signal is triggered when the acceptAction is triggered.
    signal saveItem(string text)
    Page {
        id: addPage
        titleBar: TitleBar {
            id: addBar
            title: qsTr("Add") + Retranslate.onLanguageChanged
            visibility: ChromeVisibility.Visible

            dismissAction: ActionItem {
                title: qsTr("Cancel") + Retranslate.onLanguageChanged
                onTriggered: {
                    // Hide the Sheet.
                    editSheet.close()
                }
            }

            acceptAction: ActionItem {
                title: qsTr("Save") + Retranslate.onLanguageChanged
                onTriggered: {
                    if (text.length == 0) {
                        nullToast.show()
                    } else {
                        // Hide the Sheet and emit signal that the item should be saved.
                    editSheet.close();
                    editSheet.saveItem(itemText.text);
                    }
                }
            }
            attachedObjects: [
                SystemToast {
                    id: nullToast
                    body: "empty data"
                    position: SystemUiPosition.BottomCenter
                }
            ]
        }
        Container {
            id: editPane
            property real margins: 40
            background: Color.create("#f8f8f8")
            topPadding: editPane.margins
            leftPadding: editPane.margins
            rightPadding: editPane.margins

            layout: DockLayout {
            }

            attachedObjects: [
                TextStyleDefinition {
                    id: editTextStyle
                    base: SystemDefaults.TextStyles.TitleText
                }
            ]
            Container {
                TextArea {
                    id: itemText
                    hintText: qsTr("New item on the list") + Retranslate.onLanguageChanged
                    topMargin: editPane.margins
                    bottomMargin: topMargin
                    preferredHeight: 450
                    maxHeight: 450
                    horizontalAlignment: HorizontalAlignment.Fill
                    

                    //textFilter: SingleLineTextFilter {

                //}
                    
                }
            } // Text Area Container
        } // Edit pane Container
    } // Page

    onOpened: {
        itemText.requestFocus()
    }

}// Sheet