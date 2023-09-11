({
	doInit : function(component, event, helper) {
	 	
	},
    fileSelected : function(component, event, helper) {
        try{
            if(event.target.id == 'None'){
                helper.showtoast(component,event,'Error','Please select file name first !','error');
                return;
            }
            component.set("v.spinnerFlag","true");
            var fileInput = event.target;
            var file = fileInput.files[0];
            var fName = file.name;
            var fileName = event.currentTarget.dataset.filename + fName.substring(fName.lastIndexOf("."), fName.length).toLowerCase();
            console.log("complete file name"+fileName);
            //   alert("file type is "+file.type);
            // alert('test'+file.type.indexOf("image/"));
            component.set("v.fileName",fileName);
            helper.save(component,event,fileInput);
        }
        catch(err){
           // alert('error'+err.msg);
        }
        
	},
    openDocumentModal: function(component,event,helper) {
        component.set('v.isOpen',true);
        //  alert('test before2');
        //   helper.getGeolocation(component,helper);
        helper.setDocumentConfiguration(component);
        component.set("v.spinnerFlag","true");
        var DocEvent = component.getEvent("CreditCard_Document");
        DocEvent.setParams({
            "openDocument": "true"
        });
        DocEvent.fire();
        
    },
    closeDocumentModel: function(component,event,helper) {
        component.set('v.isOpen',false);
        var activesectionList = ['Upload Documents'];
        component.set("v.activeSections",activesectionList);
        var DocEvent = component.getEvent("CreditCard_Document");
        DocEvent.setParams({
            "openDocument": "false"
        });
        DocEvent.fire();
    },
    openImagePreview: function(component,event,helper) {
        component.set("v.spinnerFlag","true");
        
        // $A.get('e.lightning:openFiles').fire({
        //   recordIds: event.getSource().get("v.title")
        //});
        var doctitle = event.getSource().get("v.label");
        var docType = doctitle.split(".");
        if(docType[1] == 'pdf' || docType[1] == 'PDF'){
            helper.showtoast(component,event,'Info','PDF files cannot be previewed !','info');
            component.set("v.spinnerFlag","false");
            return;
        }
        component.set("v.CurrentPreviewId",event.getSource().get("v.title"));
        component.set('v.isFileModalOpen',true);
        component.set("v.spinnerFlag","false");
    },
    closeFileModel: function(component,event,helper) {
        component.set('v.isFileModalOpen',false);
    },
      handlecollapsible: function(component,event,helper) {
          var list = [];
        component.set('v.activeSections',list);
    },
     deleteAttachment : function(component, event, helper){
         	component.set("v.spinnerFlag","true");
            var id = event.getSource().get("v.value");
            helper.deleteAttachment(component, id);
       
    },
  /*   setFileSelected : function(component, event, helper){
            var currentPicklist = event.getSource();//.get("v.value")
         	var valueSelected = event.getSource().get("v.value");
         	currentPicklist.set("v.value",valueSelected);
 
       
    },*/
})