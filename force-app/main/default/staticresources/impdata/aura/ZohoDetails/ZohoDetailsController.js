({
       clickCreate: function(component, event, helper) {
        if(helper.ValidateForm(component,event)){        
        var btn = event.getSource();
		btn.set("v.disabled",true);
        
            var file= helper.getFile(component);
            
        if(file!=null)
        {
            var fr = new FileReader();
 
        //var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length; 
            //fileContents = fileContents.substring(dataStart);
    	    helper.saveTicket(component, fileContents, btn, file.name);
            console.log('fileContents==>'+fileContents);
         };
        fr.readAsBinaryString(file);
        //fr.readAsDataURL(file);
        //fr.readAsText(file);
            
        }
            else
            {
                 helper.saveTicket(component,null, btn,null);
            }
        }},
    
    handleUploadFinished: function (component, event,helper) {
        // Get the list of uploaded files
        //var uploadedFiles = event.getParam("fileContent");
        //alert("uploadedFiles -->" + event.getSource().get("v.files"));
        var file= helper.getFile(component);
        
        if(file.name != undefined){
                var fileName = file.name;
                component.find("file-name").set("v.value", fileName);
            }
        
        var fr = new FileReader();
 
        //var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length; 
            //fileContents = fileContents.substring(dataStart);
    	    //helper.saveTicket(component, fileContents, btn, file.name);
           // console.log('fileContents==>'+fileContents);
         };
        fr.readAsBinaryString(file);
        //fr.readAsDataURL(file);
        
    },  
      
    closeCustomToast : function(component, event, helper){
        helper.closeToast(component);
    },
    ValidateCmp: function(component, event, helper)
    {
        helper.ValidateForm(component,event);
    }
    
    

})