({
    generateOTP : function(component, event, helper) {
        /*var hashCodeEvt = $A.get("e.c:shareAadhaarHashCode");
        if(hashCodeEvt){
            console.log('Inside HashCode Event');
            hashCodeEvt.setParams({ "hashCode" : "Wow Communication between Lightning out and Visualforce is successful." });
            hashCodeEvt.fire();
        }*/
       
		console.log('here '+component.get('v.isDSS'));      
        //console.log('aadhar product>>'+component.get('v.Product'));
       // document.getElementById('userAcceptDiv').style.display = "none"; //added by shilpa for bug id 16111
                               
        console.log('robin3 '+event.getSource().getLocalId());	
         //Rohit 16111 start for cancel button     
         if(component.get("v.ekycDone") != 'true') 
         {   
             if(event.getSource().getLocalId() == "CancelPopUpCo" || event.getSource().getLocalId() == "regenerateOTPCo" )
             {
                 helper.getOTP(component,true);
                 //Rohit bug 16463
                 document.getElementById('VaultSuccessCo').style.display = 'none';
             }
            else
            {   
                console.log('else cond');
                //document.getElementById('VaultSuccessCo').style.display = 'none';
                helper.getOTP(component,false);        
            }
        }
        else
        {
             alert('Ekyc already done !!');
        }
        //Rohit 16111 stop for cancel button
    },
    /*Bug 16111 Krish s*/
    cancelDetails : function(component, event, helper) {
        helper.cancelDetails(component);
    },
    /*Bug 16111 Krish e*/
    submitOTP : function(component, event, helper){
        
        helper.submitOTP(component);
        
    },
    disableForm: function(component, event, helper){
        helper.disableForm(component);
    },
    //Rohit ekyc 16111 start
    copyToConsent:function(component, event, helper){

       var num = component.find("aadharNumberCo").get("v.value");
       var v = num.replace(/\s+/g, '').replace(/[^0-9]/gi, '')
       var matches = v.match(/\d{4,16}/g);
  	   var match = matches && matches[0] || ''
  	   var parts = [];
  		for (i=0, len=match.length; i<len; i+=4) {         
    		parts.push(match.substring(i, i+4));
            
  		}
  		if (parts.length) {
   			parts.join(' ')
 		 } else;
        component.find("conAadhar").set("v.value",parts[0]+'-'+parts[1]+'-'+parts[2]);
        console.log('test');
    },
    validateButton:function(component, event, helper){
        console.log('hello');
/*        if(event.getSource().get('v.value')){
       		 component.find("generateOTPCo").set("v.disabled", false);
        }
        else
        {
             component.find("generateOTPCo").set("v.disabled", true);
        }*/
         if(component.get("v.AgreeFlag")){
             component.find("generateOTPCo").set("v.disabled", false);
        }
        else
        {
             component.find("generateOTPCo").set("v.disabled", true);
        }
    },   
    doInit: function(component, event, helper) {
        if(component.find("generateOTPCo") != undefined)
         component.find("generateOTPCo").set("v.disabled", true);             
        //console.log(typeof chkbox);
         window.onclick = function(event) {
           					if (event.target == document.getElementById('myModalCo')) {
                            document.getElementById('myModalCo').style.display = "none";
                        	}
       					} 
        
        var btn = document.getElementById("termsAndConditions");
       //added for bug id 21851 start
        helper.getHideAadhaarSectionHelper(component);
       
        //added for 21851 end
        
    },
    hideModal: function(component, event, helper){
        document.getElementById('myModalDetailsCo').style.display = "none"; 
        document.getElementById('myModalCo').style.display = "none";
        document.getElementById('consentDivCo').style.display = "none";
	},
    displayTC: function(){
        document.getElementById("termsAndConditions").onclick = function(event) {
                        document.getElementById('consentDivCo').style.display = "block";
                    }
    },
    saveEKYC:function(component, event, helper){
        helper.saveEKYC(component, event);
        
    }
    
    //Rohit ekyc 16111 stop
   
})