({
    MAX_FILE_SIZE: 4500000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 4250000, /* Use a multiple of 4 */
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
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
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    ResetForm: function(component)
    {
    		component.find("productId").set("v.value","--None--");
            component.find("itemId").set("v.value","--None--");
            component.find("subjectId").set("v.value","");
            component.find("descId").set("v.value","");
            //component.find("file-upload-input").set("v.value","");
            component.find("file-name").set("v.value","No file chosen");
	} ,
    saveTicket: function(component,fileContents, btn,filename)
    {
        console.log('inside save');
         this.executeApex(component,"saveTicket", {
            
            "Product" : component.find("productId").get("v.value"),
            "Item" : component.find("itemId").get("v.value"),
            "Subject" : component.find("subjectId").get("v.value"),
            "Description" : component.find("descId").get("v.value"),
             //"fileContent" : fileContents!=null? encodeURIComponent(fileContents):null,
             "fileContent" : fileContents,
             "filename":filename
        },function(error, result) {
            if(!error && result) {
                console.log('result : '+ result);  
                var res = result;//.split(";");
                
                if(res!='' || res!= null)
                {
                    if(res=='error')
                   	{
                        //component.set("v.errormsg", 'Request Failed. Please try again later');
                        var customToastE = component.find("customToastError");
                		$A.util.removeClass(customToastE,"slds-hide");
                    }
                    else
                    {
                        //component.set("v.taskid", res[0]);    
                        component.set("v.zoho_logid", res);
                        var customToasts = component.find("customToastSuccess");
               			$A.util.removeClass(customToasts,"slds-hide");
                        this.ResetForm(component);
                       
                      
                        
                    }
                }
                
                
                //alert('Request created successfully. Please note Task Id:' +result+' for your reference.');
            } else if(error) {   
                component.set("v.errormsg", error);
                var customToastE = component.find("customToastError");
                $A.util.removeClass(customToastE,"slds-hide");
                console.log('Error : '+ error);
            }
            btn.set("v.disabled",false);
        });
    },    
    
    getFile:function(component)
    {       
        var fileInput = component.find("file-upload-input").getElement();
        console.log('fileInput==>'+fileInput);
    	var file = fileInput.files[0];
        console.log('file==>'+file);
   		/*if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    		  'Selected file size: ' + file.size);
    	    return null;
        }*/
        return file;        
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    closeToast: function(component){
        this.showHideDiv(component, "customToastSuccess", false);
        this.showHideDiv(component, "customToastError", false);
    },
    ValidateForm: function(component, event){
        //alert(event.getSource());
        var cmpId= event.getSource().getLocalId();
        var isEmpty, isValid = true;
        if(cmpId=='submitBtn'){
            var prod= component.find("productId").get("v.value");
            var Item=component.find("itemId").get("v.value");
            var Sub=component.find("subjectId").get("v.value");
            var Desc= component.find("descId").get("v.value");
            
            var lst = [
                {value: prod, auraId: "productId", message: "Please select a Product"},
                {value: Item, auraId: "itemId", message: "Please select an Item"},
                {value: Sub, auraId: "subjectId", message: "Please enter Subject"},
                {value: Desc, auraId: "descId", message: "Please enter Description"},
            ];         
        }else{ 
                var Val= component.find(cmpId).get("v.value");
                var lst = [
                {value: Val, auraId: cmpId, message: "Please select a Value"}];
        }
        for(var i = 0; i < lst.length; i++){ 
            isEmpty = this.isEmpty(lst[i].value);
            isValid = isValid && !isEmpty;
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
        }
        return isValid;
    },
    addRemoveInputError: function(component, key, message){
        component.find(key).set("v.errors", [{message: message ? (message) : ""}]);
    },
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    
})