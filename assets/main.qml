// Tabbed Pane project template
import bb.cascades 1.0
import bb.system 1.0
import com.vikky.list 1.0

TabbedPane {
    Menu.definition: MenuDefinition {
        // Add a Help action
        helpAction: HelpActionItem {
            onTriggered: {
                var page = helpPage.createObject();
                nav.push(page);
            }
        }
        actions:[
           ActionItem {
                id: about
                title: qsTr("About ")
                imageSource:"asset:///images/ic_info.png"
                onTriggered:{
                    var page = aboutUs.createObject();
                    nav.push(page);
                }
            }
               
        
         ]
        
    }

    activePane: NavigationPane {
        			id: nav
        			Todo {
        					 id:toDo
        		}
    }
    
    showTabsOnActionBar: false
    Tab {

        title: qsTr("To Do")
        onTriggered: {
            toDo.titleBar.title="To Do";
            toDo.add.enabled = true;
            toDo.add.ActionBar.placement= ActionBarPlacement.OnBar
            toDo.myListModel.filter = "todo";
        }
        imageSource: "asset:///images/todo.png"
    }
    Tab {
        title: qsTr("Incomplete")
        onTriggered: {
            toDo.titleBar.title = "Incomplete";
            toDo.add.enabled=false;
            toDo.add.ActionBar.placement = ActionBarPlacement.InOverflow
            
            toDo.myListModel.filter = "incomplete";
        }
        imageSource: "asset:///images/incomp.png"

    }
    Tab {
        title: qsTr("Completed")
        onTriggered: {
            toDo.titleBar.title = "Completed";
            
            toDo.myListModel.filter = "completed";
            toDo.add.enabled = false;
            toDo.add.ActionBar.placement=ActionBarPlacement.InOverflow

        }
        imageSource: "asset:///images/com.png"

    }
    attachedObjects:[

        ComponentDefinition {
           
            id: helpPage
            source: "Help.qml"
        },
        ComponentDefinition{
            id:aboutUs
            source: "About.qml"
        }

    ]   

    onCreationCompleted: {
        // this slot is called when declarative scene is created
        // write post creation initialization here
        console.log("TabbedPane - onCreationCompleted()")
        
        // enable layout to adapt to the device rotation
        // don't forget to enable screen rotation in bar-bescriptor.xml (Application->Orientation->Auto-orient)
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
        
    }
   

}
 