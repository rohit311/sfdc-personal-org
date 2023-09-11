({
	getUploadedAttachments : function(component){
        var action = component.get("c.getAttachments");
        var po = component.get("v.po");
        var pId ;
        if(po != 'undefined' && po != null){
            pId  = po.Id;
        }
        
        action.setParams({ 
            "poId" : pId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var attachments = response.getReturnValue();
                component.set("v.uploadedAttachments", attachments);
                if(attachments.length > 0){
                    $A.util.removeClass(component.find("uploadedDocs"),"slds-hide");
                }
                else{
                    $A.util.addClass(component.find("uploadedDocs"),"slds-hide");
                } 
            }
        });
        $A.enqueueAction(action);
  
        //var po = component.get("v.po");           // bug 17214 -code present above 
        var offer = component.get("v.offer");
        //console.log('Po Id'+ po.Id + " PO : "+ JSON.stringify(po)); 		
       //var poId = po ? po.Id : ""; 	             //bug 17214 - commented
       var poId = pId ? pId : "";  					//bug 17214 -used pId instead of po.Id
       
        //component.
        
        //helper.showHideDiv(component,"verificationmodal",true);
        
        if(poId){ 								// bug 17214 -changed from po.Id to poId
            var disableFlag = !offer.converted;
        	console.log("disableFlag"+disableFlag+' '+offer.converted);
            $A.createComponent(
                "c:VerificationImageUpload",
                {
                    "aura:id": "verificationPopUp",
                    "loanApplicationId": poId,
                    "parentObj": "PO",
                    "showSubmitButtonFlag" : disableFlag?"true":"false"
                },
                function(msgBox){                
                    if (component.isValid()) {
                        var verificationCmp = component.find('verificationDiv');
                        var body =[];// verificationCmp.get("v.body");
                        body.push(msgBox);
                        verificationCmp.set("v.body", body); 
                    }
                }
            ); 
        
        }
        //
        
        
     },
     creteCpvCompnent : function(component){
    //creating CPV Comp Dynamically
    setTimeout(function(){ 
        var po = component.get("v.po");
        console.log('Po Id'+ po.Id + " PO : "+ JSON.stringify(po));
        var poId = po ? po.Id : "";
        //component.
        
        //helper.showHideDiv(component,"verificationmodal",true);
        
        if(po.Id){ 
            console.log('PO id inside creation '+po.Id);
            $A.createComponent(
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
        }
        //
         }, 6000);
	}
    ,
    
    deleteAttachment : function(component, attachId) {
        var action = component.get("c.removeAttachment");
        action.setParams({
            "attachId" : attachId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                this.getUploadedAttachments(component);
            }
        });
        $A.enqueueAction(action);
    },
    //PSL changes : Nikhil Bugfix #11766
    /*
     * @author	: Nikhil S
     * @date	: 03/14/2017 
     * @desc	: This method sets the offer converted flag true
     * 
     */
    setOfferConverted : function(component){
        var offer = component.get('v.offer');
        offer.converted = true;
        component.set('v.offer',offer);
    },
    showHideDiv: function(component, divId, show){
        if(divId !== "nextButtonId"){
            $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        }
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    showHideSection: function(component,iconId,sectionId){
    

        console.log('icon : '+ iconId+' '+sectionId);
        var x = document.getElementById(iconId).innerHTML;
        component.set("v.po",component.get("v.po"));
        console.log(x);
        
        
        
        if(x =="[-]"){
            document.getElementById(iconId).innerHTML = "[+]";                   
         //	$A.util.toggleClass(component.find(sectionId), 'slds-hide'); 
          this.showHideDiv(component, sectionId, false);
            
        }
        else{
            document.getElementById(iconId).innerHTML = "[-]"; 
         // $A.util.addClass(component.find(sectionId), 'slds-hide');
          this.showHideDiv(component, sectionId, true);
           
        }
        
       
    }
})