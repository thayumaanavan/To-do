import bb.cascades 1.0

Container {
	
    background: Color.Black
    
   
     
    Header {
        id:head
        title: qsTr("To Do")
        scaleX: 1.0  
    }
    
	
    

    Label {
    	objectName:"label1"
    	//text:"khkj"
       

        //textStyle.color: Color.create("#ebebeb")
        // textFormat: TextFormat.Html
    }
    
    Label {
        objectName: "label2"
    	//text:""
        
        
    }
    Label {
        objectName: "label3"
        //text: ""
       
        //textStyle.color: Color.create("#ebebeb")

    }
    Label {
        objectName: "label4"
        //text:"asdasdas"

    }
    ImageView{
        id: image
        imageSource: "asset:///images/icon.png"
        horizontalAlignment: HorizontalAlignment.Center
    }
   
}


