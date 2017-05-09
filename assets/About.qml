import bb.cascades 1.0

Page {
    titleBar: TitleBar {
        title: "About"
    }

    Container {
        Label {

        }
        TextArea {
            editable: false
            text: qsTr("<html><b>TO DO</b>\r\n\r\nSimple To Do app.\r\nIt is still in early stages.send me your feature request.\r\n\r\n\r\n © 2013 CRT</html>")
        }

        

    }
    actions: [
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.invokeActionId: "bb.action.SENDEMAIL"
            query.mimeType: ""
            query.uri: "mailto:thayumaanavan@hotmail.com?subject=ToDo:%20Support/Feature Request"
            query.invokerIncluded: true
            title: "Contact Us"
        }
    ]

}