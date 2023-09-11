({
	getUploadedAttachments : function(component){
        console.log('inside method getuploadattach');
        var action = component.get("c.getAttachments");
        var loan = component.get("v.loan");
        var loanId = component.get("v.loanId");;
       // if(loan != 'undefined' && loan != null){
      //      loanId  = loan.Id;
      //  }
        component.set("v.spinnerFlag","true");
        console.log('loanId'+loanId);
        action.setParams({ 
            "poId" : loanId
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var attachments = response.getReturnValue();
                console.log('attachements');
                console.log(attachments);
                component.set("v.uploadedAttachments", attachments);
                console.log('inside get uploaded documents');
                if(attachments.length > 0){
                    $A.util.removeClass(component.find("uploadedDocs"),"slds-hide");
                }
                else{
                    $A.util.addClass(component.find("uploadedDocs"),"slds-hide");
                } 
            }
        });
        $A.enqueueAction(action);
	},
    
    deleteAttachment : function(component, attachId) {
       component.set("v.spinnerFlag","true");
        var action = component.get("c.removeAttachment");
        action.setParams({
            "attachId" : attachId
        });
        action.setCallback(this, function(response) {
            //component.set("v.spinnerFlag","false");
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                this.getUploadedAttachments(component);
            }
        });
        $A.enqueueAction(action);
    },
    
   getDocumentList : function(component){
       if( component.get("v.Flow") === "LAN"){
           this.executeApex(component, "LANcallDocumentAPI", {"oppId" : component.get("v.loanId")}, function(error, result) {
                if(!error && result) {
                     this.setSelectOptions(component, result, "Document Type", "Documents");
                    component.set("v.Filename", "Select Document Type");
                    
                }
           });
       }else{
           console.log('component.get("v.loanId")'+component.get("v.loanId"));
          // var poID = component.get("v.loanId");
            this.executeApex(component, "POcallDocumentAPI", {"oppId" : component.get("v.loanId")}, function(error, result) {
                if(!error && result) {
                     this.setSelectOptions(component, result, "Document Type", "Documents");
                    component.set("v.Filename", "Select Document Type");
                    
                }
           });
       }
   },
   executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        component.set("v.spinnerFlag","true");
        action.setCallback(this, function(response) {
            component.set("v.spinnerFlag","false");
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                this.ShowToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    setSelectOptions: function(component, data, label, cmpId){
        var data1 = data.sort();
        var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
        for(var i=0; i < data1.length; i++){
            opts.push({"class": "optionClass", label: ''+data1[i], value: data1[i]});
        }
        component.find(cmpId).set("v.options", opts);
    },
    
    ShowToast : function(component, title, message, type){
        var ShowToastEvent = $A.get("e.c:ShowToastEvent");
        ShowToastEvent.setParams({
            "title": title,
            "message":message,
            "type":type,
        });
        ShowToastEvent.fire();
    },
 
})