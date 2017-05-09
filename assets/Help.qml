import bb.cascades 1.0

Page {
    titleBar: TitleBar {
    		title: "Help"
    }

    Container {
        Label {
        	
        }
        TextArea {
            editable: false
            text: "<html><b>To-Do:</b> tasks to be done.\n\n<b>Incomplete:</b> tasks currently inprogress.\n\n<b>Completed:</b> tasks that are done.</html>"
        }

    }
    
}
