import bb.cascades 1.0
import com.vikky.list  1.0


NavigationPane {
    backButtonsVisible: false
    peekEnabled: true
   
    Page {
        titleBar: TitleBar {
            title: qsTr("Add Item")
            
            attachedObjects:[
                Todo{
                    id:toDo
                }
            ]
            acceptAction: ActionItem {
                title: qsTr("Share")
                onTriggered: {
                     toDo.myListModel.addItem(_app.data);
                    _app.cardDone(qsTr("Content Shared."));
                }
            }
            dismissAction: ActionItem {
                title: qsTr("Cancel")
                onTriggered: {
                    _app.cardDone(qsTr("Dont feel like sharing today?"));
                }
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            Header {
                title: qsTr("Share via To Do")
            }
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                TextArea {
                    horizontalAlignment: HorizontalAlignment.Center
                    preferredHeight: 400
                    text: _app.data
                    onCreationCompleted: {
                        requestFocus();
                    }
                }
            }
        }
    }
}
//! [0]
