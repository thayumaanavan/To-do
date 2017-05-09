import bb.cascades 1.0
import bb.system 1.0
import com.vikky.list 1.0
ListView {
    id: listView
    objectName: "listView"

    dataModel: myListModel 
    property int activeItem: -1

    

    // Override default GroupDataModel::itemType() behaviour, which is to return item type "header"
    listItemComponents: [
        // define delegates for different item types here
        ListItemComponent {
            type: "todo"
            // StandardListItem is a convivience component for lists with default cascades look and feel
            StandardListItem {
                id: listItem
                title: ListItemData.title
                imageSpaceReserved: false

                contextActions: [
                    ActionSet {
                    	title: listItem.ListItem.view.dataModel.filter
                        attachedObjects: [
                            SystemToast {
                                id: todo
                                body: "Moved to Todo"
                                position:SystemUiPosition.BottomCenter
                            },
                            SystemToast {
                                id: incomplete
                                body: "Moved to Incomplete"
                                position: SystemUiPosition.BottomCenter

                            },
                            SystemToast {
                                id: completed
                                body: "Moved to completed"
                                position: SystemUiPosition.BottomCenter
                            
                            },
                            SystemToast {
                                id: deleteToast
                                body: qsTr("Item deleted") + Retranslate.onLanguageChanged
                               // icon: "asset:///images/position_to_be_deleted_small.png"
                                position: SystemUiPosition.BottomCenter
                                //label:"asda"
                                //sbutton.label: qsTr("Undo")
                                //button.enabled: true
                                
                            }

                        ]

                          

            ActionItem {
                title: qsTr("Todo") + Retranslate.onLanguageChanged
                enabled: listItem.ListItem.view.dataModel.filter == "todo" ? false : true
                imageSource: "asset:///images/todo.png"

                            onTriggered: {
                    if (enabled) {
                        listItem.ListItem.view.dataModel.setStatus(listItem.ListItem.indexPath, "todo");
                        
                        todo.show()
                    }
                }
          }              
            ActionItem {
                title: qsTr("Incomplete") + Retranslate.onLanguageChanged
                enabled: listItem.ListItem.view.dataModel.filter == "incomplete" ? false : true
                imageSource: "asset:///images/incomp.png"

                            onTriggered: {
                    if (enabled) {
                        listItem.ListItem.view.dataModel.setStatus(listItem.ListItem.indexPath, "incomplete");
                        incomplete.show()
                    }
                }
                            
            }
            ActionItem {
                title: qsTr("Completed") + Retranslate.onLanguageChanged
                enabled: listItem.ListItem.view.dataModel.filter == "completed" ? false : true
                imageSource: "asset:///images/com.png"

                            onTriggered: {
                    if (enabled) {
                        listItem.ListItem.view.dataModel.setStatus(listItem.ListItem.indexPath, "completed");
                        completed.show()
                    }
                }
                            
            }
            InvokeActionItem {
                    //ActionBar.placement: ActionBarPlacement.OnBar
                    title: "Share"
                    query {
                        mimeType: "text/plain"
                        invokeActionId: "bb.action.SHARE"
                    }
                    onTriggered: {
                        if(listItem.ListItem.view.dataModel.filter=="incomplete")
                        	data="Doing : "+listItem.title
                        else
                        	data = listItem.ListItem.view.dataModel.filter+" : "+ listItem.title;
                                //console.log(data);
                    }
            }
            
            DeleteActionItem {
                title: qsTr("Delete") + Retranslate.onLanguageChanged

                onTriggered: {
                    listItem.ListItem.view.dataModel.deleteItems(listItem.ListItem.indexPath);
                    deleteToast.show()
                }
           }

            MultiSelectActionItem {
                multiSelectHandler: listItem.ListItem.view.multiSelectHandler

                onTriggered: {
                    multiSelectHandler.active;
                }
            }
        }
        		]

            }
        }
    ]

    // The multi-select handler of the ListView, which will add an additional multi-select item to the list-items
    // context menu (accessed by long-pressing an item). In the multi-select session, it is possible to select
    // several items in the list and perform a collective action on them (like e.g. deleting many items at once).
    multiSelectHandler {
        status: qsTr("None selected") + Retranslate.onLanguageChanged

        attachedObjects: [
            SystemToast {
                id: todoMulti
                body: qsTr("Moved to Todo") + Retranslate.onLanguageChanged
                position: SystemUiPosition.BottomCenter
            },
            SystemToast {
                id: incompleteMulti
                body: qsTr("Moved to Incomplete") + Retranslate.onLanguageChanged
                position: SystemUiPosition.BottomCenter

            },
            SystemToast {
                id: completedMulti
                body: qsTr("Moved to completed") + Retranslate.onLanguageChanged
                position: SystemUiPosition.BottomCenter

            },
            SystemToast {
                id: deleteToastMulti
                body: qsTr("Items deleted") + Retranslate.onLanguageChanged
                // icon: "asset:///images/position_to_be_deleted_small.png"
                position: SystemUiPosition.BottomCenter
                //label:"asda"
                //sbutton.label: qsTr("Undo")
                //button.enabled: true

            }

        ]
        // The actions that can be performed in a multi-select sessions are set up in the actions list.
        actions: [
            ActionItem {
                title: qsTr("Todo") + Retranslate.onLanguageChanged

                // Since it is only possible to change the state from one state to another,
                // ActionItems are disabled if they do not result in a state change.
                // For example, todo -> completed is allowed but todo -> todo is not.
                enabled: myListModel.filter == "todo" ? false : true
                imageSource: "asset:///images/todo.png"

                onTriggered: {
                    if (enabled) {
                        // Change the status of the selected items to "todo", clear selection before
                        // performing the action, since otherwise the ListItem will not be in the correct
                        // state when it is recycled by the list view (it will blink)
                        var selectionList = listView.selectionList();
                        listView.clearSelection();
                        myListModel.setStatus(selectionList, "todo");
                        todoMulti.show()
                       
                    }
                }
            },
            ActionItem {
                title: qsTr("Incomplete") + Retranslate.onLanguageChanged
                enabled: myListModel.filter == "incomplete" ? false : true
                imageSource: "asset:///images/incomp.png"

                onTriggered: {
                    if (enabled) {
                        // Change the status of the selected items to "Incomplete". Clear selection before items are manipulated to avoid blink.
                        var selectionList = listView.selectionList();
                        listView.clearSelection();
                        myListModel.setStatus(selectionList, "incomplete");
                        incompleteMulti.show()
                        
                    }
                }
            },
            ActionItem {
                title: qsTr("Completed") + Retranslate.onLanguageChanged
                enabled: myListModel.filter == "completed" ? false : true
                imageSource: "asset:///images/com.png"

                onTriggered: {
                    if (enabled) {
                        // Change the status of the selected items to "completed". Clear selection before items are manipulated to avoid blink.
                        var selectionList = listView.selectionList();
                        listView.clearSelection();
                        myListModel.setStatus(selectionList, "completed");
                        completedMulti.show()
                       
                    }
                }
            },
            // Since the delete action has a reserved space at the bottom of the list in the
            // context menu it needs to be defined as a special DeleteActionItem to be shown in the
            // correct place.
            DeleteActionItem {
                title: qsTr("Delete") + Retranslate.onLanguageChanged

                onTriggered: {
                    // Delete the selected items. Clear selection before items are manipulated to avoid blink.
                    var selectionList = listView.selectionList();
                    listView.clearSelection();
                    myListModel.deleteItems(selectionList);
                    deleteToastMulti.show()
                }
            }
        ]
    }
   onTriggered: {
        // When an item is triggered, a navigation takes place to a detailed
        // view of the item where the user can edit the item. The page is created
        // via the ComponentDefinition from the attached objects in the NavigationPane.
      
        var chosenItem = dataModel.data(indexPath);
        var page = detailsPage.createObject();

        // Set the Page properties and push the Page to the NavigationPane.
        page.item = chosenItem;
        page.myListModel = myListModel;
        var option = myListModel.filter;
        page.title = option;
        nav.push(page);
    }
    onSelectionChanged: {
        // Call a function to update the number of selected items in the multi-select view.
        updateMultiStatus();
    }
    function itemType(data, indexPath) {
        // There is only have one type of item in the list, so "todo" is always returned.
        return "todo";
    }
    function updateMultiStatus() {

        // The status text of the multi-select handler is updated to show how
        // many items are currently selected.
        if (selectionList().length > 1) {
            multiSelectHandler.status = selectionList().length + qsTr(" items selected");
        } else if (selectionList().length == 1) {
            multiSelectHandler.status = qsTr("1 item selected");
        } else {
            multiSelectHandler.status = qsTr("None selected");
        }
    }

    layoutProperties: StackLayoutProperties {
        spaceQuota: 1.0
    }
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill

}