import bb.cascades 1.0

Container {

   // background: Color.Black
    
   
    // layout: StackLayout {
    //}
    
    Header {
        title: qsTr("To Do")
        scaleX: 1.0
        opacity: 1.0
        

    }
   
    Label {
    	objectName:"label1"
    	//text:"Todo item 1"
        opacity: 1.0
        //textStyle.color: Color.create("#ebebeb")
        // textFormat: TextFormat.Html
    }
    
    Label {
        objectName: "label2"
    	//text:"asdasdas"
        opacity: 1.0
        
    }
    Label {
        objectName: "label3"
        //text: "asdasdas"
        opacity: 1.0
        //textStyle.color: Color.create("#ebebeb")

    }
    ImageView {
        imageSource: "asset:///images/icon.png"
        
        horizontalAlignment: HorizontalAlignment.Center
        //opacity: 0.5

    }

}