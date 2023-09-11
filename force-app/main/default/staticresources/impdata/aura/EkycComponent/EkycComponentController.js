({
	doInit : function(component, event, helper) {
		console.log('do init in ekyc'+component.get("v.isPreapproved"));
        helper.fetchData(component, event);
       
	},
    OpenCustomerEyePage : function(component, event, helper){
        
         var url ='/apex/CustomerEyeVF?id='+component.get("v.custId");
         window.open(url,'_blank');
    },
    /*initiateKYCForm: function (component, event) {
        console.log('kyc is'+event.getParam("kyc"));
        component.set("v.kyc", event.getParam("kyc"));
    },*/
    menuItemClick : function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'));
    },
    initiateKYCForm : function(component, event, helper){ 
        console.log('in save set');
       component.set("v.kyc", event.getParam("kyc"));
        if(!$A.util.isEmpty(component.get("v.kyc"))){
            component.set("v.isEkycDone",true);
            if(component.get("v.kyc") != null && component.get("v.kyc").bio_Ekyc__c == true){
                component.set("v.ekycSource",'Bio - metric');    
            }
            else{
                component.set("v.ekycSource",'OTP');
            }
        }
       if(!$A.util.isEmpty(component.get("v.appNew").Id)){
           helper.saveEkyc(component, event);
       }
       		 
       
    },
    redirectToCustomerEye : function (component, event, helper) {

    	//document.getElementById("frame1").src = '/apex/CustomerEyeVF?id='+component.get("v.custId");
		component.set("v.isViewCustomerEyeModal", true);
           
   },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewCustomerEyeModal", false);
    },
	
	

})