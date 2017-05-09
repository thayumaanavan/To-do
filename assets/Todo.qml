import bb.cascades 1.0
import com.vikky.list 1.0

Page {
	id:page
	property alias myListModel : myListModel
	property alias add : add

    shortcuts: [
        SystemShortcut {
        	//create new shortcut
            type: SystemShortcuts.CreateNew
            onTriggered: {
                addNew.open();
                addNew.text = "";
            }
        },
        SystemShortcut {
            //jump to top shortcut
            type: SystemShortcuts.JumpToTop
            onTriggered: {
                content.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.None);
            }
        },
        SystemShortcut {
            //jump to bottom shortcut
            type: SystemShortcuts.JumpToBottom
            onTriggered: {
                content.scrollToPosition(ScrollPosition.End, ScrollAnimation.None);
            }
        }
    ]

    actions: [

        ActionItem {
            id:add
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Add")
            onTriggered: {
                addNew.open();
                addNew.text = "";
            }
            imageSource: "asset:///images/ic_add.png"
            
        },
        ActionItem {
        	
            title: "Top"
            onTriggered: {
                content.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.None);
            }
            imageSource: "asset:///images/ic_to_top.png"
        },
        ActionItem {

            title: "Bottom"
            onTriggered: {
                content.scrollToPosition(ScrollPosition.End, ScrollAnimation.None);
            }
            imageSource: "asset:///images/ic_to_bottom.png"
        }
    ]

    titleBar: TitleBar {
        id:titleBar
        title:"To Do"
    }
    Container {

        // The ListView is a separate QML component kept in Content.qml
        Content {
            id: content
            attachedObjects: [
                
                MyListModel {
                    id: myListModel

                    // The path to the JSON file with initial data, this file will be moved to
                    // the data folder on the first launch of the application (in order to
                    // be able to get write access).
                    jsonAssetPath: "app/native/assets/data.json"

                    // The filtering is initially set to "todo" to show items which has not
                    // been checked off the list so far.
                     filter: "todo"
                }
            ]

        }
    }
    
        
    
    attachedObjects: [
        
        Edit {
            // A sheet is used to add new items to the list, which is the same sheet used to edit items
            id: addNew

            onSaveItem: {
               
                myListModel.addItem(text);
                content.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Default);
                
            }
            
        },
        ComponentDefinition {
            // A Component definition of the Page used to display more details on the item.
            id: detailsPage
            source: "Details.qml"
        }
    ]
    onCreationCompleted: {
        // this slot is called when declarative scene is created
        // write post creation initialization here
        console.log("TabbedPane - onCreationCompleted()")
        Application.thumbnail.connect(onThumbnail)
        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
        
        //titleBar.title= main.tab_title

    }
    function onThumbnail() {
        	if(myListModel.filter=="todo"){
            var indexPath = new Array();
            indexPath[0] = 0;
            var item1 = myListModel.data(indexPath);
           
            indexPath[0] = 1;
            var item2 = myListModel.data(indexPath);
           
            indexPath[0] = 2;
            var item3 = myListModel.data(indexPath);
           
            	if(item1 && item2 && item3){
            			 activeFrame.update(item1.title,item2.title,item3.title);
            	} else {
                	activeFrame.update("", "", "");
                }
            }else{
            	activeFrame.update("", "", "");
        }
        
        //console.log(content.dataModel.data(indexPath).title)
    }

}