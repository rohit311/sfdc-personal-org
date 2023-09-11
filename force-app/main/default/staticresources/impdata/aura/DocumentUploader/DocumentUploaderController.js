({  //22484 s
    doInit : function(component, event, helper){
        //alert(component.get("v.forPricingDashboard"));
     if(component.get("v.forPricingDashboard")=='yes')
                {
                     $A.util.addClass(component.find('file-name'), 'slds-hide'); 
                     $A.util.removeClass(component.find('file-name2'), 'slds-hide'); 

                }
    } ,//22484 e
	fileSelected : function(component, event, helper) {
        //alert('RDL Testing');
       // component.set("v.disablepage",true);
     // alert('start uploading');
     	
        $A.util.removeClass(component.find("previewBlock"), 'slds-hide');
        helper.preview(component,event);
    },
    save : function(component, event, helper) {
        helper.save(component);
    },    
    reset : function(component, event, helper) {
        helper.reset(component);
    },
    disableForm: function(component, event, helper) {
        if(event.getParam("offer").converted == "true"){
            helper.disableForm(component);
        }
    }, 
    disableForm1: function(component, event, helper) {
        if(event.getParam("loanNumber")){
            helper.disableForm(component);
        }
    },  
    waiting: function(component, event, helper) {
    	$A.util.addClass(component.find("uploading").getElement(), "uploading");
    	$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },
    doneWaiting: function(component, event, helper) {
    	$A.util.removeClass(component.find("uploading").getElement(), "uploading");
    	$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    }, 
    closeCustomToast : function(component, event, helper){
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    },
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("waiting"),"slds-hide");
    },
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("waiting"),"slds-hide");
    },
    
    setVerificationId : function(component, event, helper){
        if(component.get("v.forPOSDocument") != "true"){
           
            helper.setVerificationId(component, event);
        }
        	
    },
    /*Bug 17138 s*/
    setCheckId : function(component, event, helper){
        console.log('Inside DocumetnUploader - SetParentId');
        helper.showhidespinner(component,event,true);
        helper.setChecklistId(component, event);
    },
    /*Bug 17138 e*/
   
    
})