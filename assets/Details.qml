
import bb.cascades 1.0



Page {
    id: detailsPage
    property variant item
    property variant myListModel
    property alias title: titleBar.title

    titleBar: TitleBar {
        id: titleBar
        visibility: ChromeVisibility.Visible
    }

    shortcuts: [
        SystemShortcut {
            // The edit short cut shows the edit sheet.
            type: SystemShortcuts.Edit
            onTriggered: {
                editSheet.open();
                editSheet.text = listText.text;
            }
        }
    ]
    actions: [
        InvokeActionItem {
            //ActionBar.placement: ActionBarPlacement.OnBar
            title: "Share"
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
            }
            onTriggered: {
                if (titleBar.title == "incomplete") 
                	data = "Doing : " + listText.text;
                else data = titleBar.title + " : " + listText.text;
                //console.log(data);
            }
        } ,
        ActionItem {
            title: qsTr("Edit") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/ic_edit.png"
            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                editSheet.open();
                editSheet.text = listText.text;
            }
        }
    ]
    Container {
        layout: DockLayout {
        }

        Container {
            leftPadding: 22
            rightPadding: leftPadding
            horizontalAlignment: HorizontalAlignment.Left

            Label {
                id: listText
                multiline: true
                text: item.title
                textStyle.base: SystemDefaults.TextStyles.TitleText
            }
        }
    }

    

    

    attachedObjects: [
        Edit {
            id: editSheet
            title: qsTr("Edit") + Retranslate.onLanguageChanged
            hintText: "Update item description"

            onSaveItem: {
                // Call the function to update the item data.
                myListModel.editItem(detailsPage.item, text);

                // Update the current item property data used in this Page to do this
                // one has to copy all values to 'tempItem'.
                var tempItem = item
                // Update the item property
                tempItem.title = text
               
                item = tempItem
            }
        }
    ]
}
