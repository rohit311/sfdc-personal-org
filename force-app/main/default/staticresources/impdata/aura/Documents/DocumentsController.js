({
    doInit : function(component, event, helper){
        helper.getUploadedAttachments(component);
    },
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("spinner"),"slds-hide");
    },
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("spinner"),"slds-hide");
    },
   	getDetails : function(component, event, helper){ 
    	var kyc = event.getParam("kyc");
        var po = event.getParam("po");
        //PSL changes : Nikhil Bugfix #11766
        var offer = event.getParam("offer");
        component.set("v.kyc", kyc);
        component.set("v.po", po);
        //PSL changes : Nikhil Bugfix #11766
        component.set("v.offer", offer);
        if($A.util.isEmpty(kyc.Id)){
            var kycSection = component.find("kycSection");
            $A.util.addClass(kycSection,"slds-hide");
        }
        helper.getUploadedAttachments(component);
    },
    viewEkyc : function(component, event, helper){ 
        var ekyc = component.get("v.kyc");
        var navEvt = $A.get("e.force:navigateToSObject");
        if(navEvt){
            navEvt.setParams({
                "recordId": ekyc.Id,
                "slideDevName": "detail"
            });
            navEvt.fire();
        }
        else{
            window.open('/'+ekyc.Id);
        }
    },
    deleteAttachment : function(component, event, helper){
        //PSL changes : Nikhil Bugfix #11766
        if(!component.get("v.offer").converted){
            var id = event.getSource().get("v.value");
            helper.deleteAttachment(component, id);
        }else{
            alert('Offer already converted. Can\'t delete documents.')
        }
    },
    viewAttachment : function(component, event, helper){
        var id = event.getSource().get("v.value");
        alert(id);
    },
    showUploadedDocs : function(component, event, helper){
        helper.getUploadedAttachments(component);
    },
     toggletab : function(component, event, helper) {
        helper.showHideSection(component,"cpvIcon","cpvContent");//cpvContent
    },
    //PSL changes : Nikhil Bugfix #11766
    /*
     * @author	: Nikhil S
     * @date	: 03/14/2017 
     * @desc	: This method call the set offer converted method of helper
     * 
     */
    setOfferConverted : function(component, event, helper){
        helper.setOfferConverted(component);
    }, 
	// Bug 15855 s - Hemant Keni - For Opening Pop-Up on-click on CPV Link
    navigateToCPV : function(component, event, helper){
		component.set("v.showCPV", "true");  
        console.log('Navigated to CPV');
        var po = component.get("v.po");
        console.log('Po Id'+ po.Id + " PO : "+ JSON.stringify(po));
        var poId = po ? po.Id : "";
        //component.
        
        //helper.showHideDiv(component,"verificationmodal",true);
	/*	$A.createComponent(
            "c:VerificationImageUpload",
            {
                "aura:id": "verificationPopUp",
                "loanApplicationId": poId,
                "parentObj": "PO"
            },
            function(msgBox){                
                if (component.isValid()) {
                    var verificationCmp = component.find('verificationDiv');
                    var body = verificationCmp.get("v.body");
                    body.push(msgBox);
                    verificationCmp.set("v.body", body); 
                }
            }
        ); 
        //component.get('v.po')*/
    },
    previous : function(component, event, helper){
        
        console.log('Back to documents');
        var verificationCmp = component.find('verificationPopUp');
        if(verificationCmp)
        	verificationCmp.destroy();
        component.set("v.showCPV", "false");
    }
	// Bug 15855 E
})