({
    handleRequiredField : function(component,event,helper) {
        var fieldDispValue = component.find("fieldDisposition").get("v.value");
        if(!$A.util.isEmpty(fieldDispValue) && !$A.util.isUndefined(fieldDispValue)){
            $A.util.addClass(component.find("dispStatus"), "customRequired");
        }
        else{
            $A.util.removeClass(component.find("dispStatus"), "customRequired");
            
        }
    },
    handleSubmitFunc : function(component,event,helper) {
        component.set("v.spinnerFlag","true");
        var emptyFields = '';
        var fieldDispValue = component.find("fieldDisposition").get("v.value");
        if($A.util.isEmpty(fieldDispValue) || $A.util.isUndefined(fieldDispValue)){
           this.showtoast(component,event,'Error',"Please Select Disposition Fields First!",'error');   
           component.set("v.spinnerFlag","false"); 
           component.set("v.FieldDisposition1Error",true);
           event.preventDefault(); 
        }
        else{
            component.set("v.FieldDisposition1Error",false);
        }
        if(component.find("dispStatus")){
            var dispStatus = component.find("dispStatus").get("v.value");
            if((!$A.util.isEmpty(fieldDispValue) && !$A.util.isUndefined(fieldDispValue)) && ($A.util.isEmpty(dispStatus) || $A.util.isUndefined(dispStatus))){
                emptyFields = 'Disposition Status';
                component.set("v.FieldDispositionError",true);
            }
            else{
                component.set("v.FieldDispositionError",false);
            }
        }
        
        if(component.find("followDate")){
            var followDate = component.find("followDate").get("v.value");
            if($A.util.isEmpty(followDate) || $A.util.isUndefined(followDate)){
                if(emptyFields == ''){
                    emptyFields = 'FollowUp Date';
                }else{
                    emptyFields = emptyFields + ' and '+ 'FollowUp Date';
                }
                component.set("v.followDateError",true);
                
            }
            else{
                component.set("v.followDateError",false);
            }
        }
        if(emptyFields !=''){
            this.showtoast(component,event,'Error',"Please Select "+emptyFields+" !",'error');   
            event.preventDefault();
            component.set("v.spinnerFlag","false"); 
        }
        
        
    },
	handleSuccessFunc : function(component,event,helper) {
		this.showtoast(component,event,'Success',"Disposition details saved successfully !",'success');
       	var dispEvent = $A.get("e.c:DispositionPicklistEvent");
		dispEvent.fire();
        component.set("v.spinnerFlag","false");
        component.set('v.isOpen',false);
	},
    handleErrorFunc : function(component,event,helper) {
		var err = event.getParam("error");
        console.log('error is'+JSON.stringify(err));
       // var errmsg = event.detail;
        var errorMsg = event.getParam("detail");
        this.showtoast(component,event,'Error',errorMsg +"!",'error');
		component.set("v.spinnerFlag","false");
        
        var error = event.getParams();        
        // Get the error message
        var errorMessage = event.getParam("message");
        console.log('error msg'+errorMessage);
	},
     showtoast:function(component,event, title, message, type){
        var self = this;
        console.log('self',self);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){ //Standard toast message : if supports standard toast message
        // alert('Inside standard toast');
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });
            try{
                 toastEvent.fire();
             //   alert('after fire');
            }
            catch(e){
           //     alert('exception'+e);
            }
           
        }else{//Custom toast message : if doesn not support standard toast message
            //alert('inside displayToastMessage'+message+type);
            var showhideevent =  $A.get("e.c:ShowCustomToast");
            console.log('showhideevent--> '+showhideevent);
            showhideevent.setParams({
                "title": title,
                "message":message,
                "type":type
            });
            showhideevent.fire();     
        }
    }
    
})