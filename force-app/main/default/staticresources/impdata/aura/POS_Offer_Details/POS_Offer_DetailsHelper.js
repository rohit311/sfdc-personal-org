({
    setLoanNumber: function(component, event){
     //   alert('event.getParam(loanNumber) ----->> '+event.getParam('loanNumber'));
        component.set("v.loanNumber", event.getParam('loanNumber'));
        component.set("v.loanId", event.getParam('loanId'));
        if(component.get("v.loanNumber")!= null && component.get("v.loanNumber")!=''){
            component.set("v.IsCheckProcess", true)		
            component.set("v.iscreditReadOnly",true);// Bug 22425 CC Code changes SME added condition
            component.set("v.docDisableFlag",true);// User Story 2357 Starts
        }
       
       // component.find("uploadId").set("v.disabled", true);//Bug 2357 fix
        component.find("stpButton").set("v.disabled", true);
        
        this.showHideDiv(component, "loanNumberField", true);
         
    },
    setOfferDetails: function(component, event){
        /*var cibilScore = event.getParam('cibilScore') || '';
        var offerAmount = event.getParam('offerAmount') || '';
        var segmentation = event.getParam('segmentation') || '';
        var LAN = event.getParam('LAN') || '';*/
        var offer = event.getParam('offer') || {};
        var poObj = event.getParam('poObj') || {};
        var Lead = event.getParam('Lead') || {};
         // Bug 22425 CC Code changes SME S 
        var MCPResult = event.getParam('MCPResult') || {};
        var SegmentMatched = event.getParam('SegmentMatched')||{};
            if(!this.isEmpty(event.getParam('MCPResult')) || event.getParam('MCPResult') != null){ 
                 component.set("v.MCPFailed",MCPResult)
            }
			if(!this.isEmpty(SegmentMatched)){
                 component.set("v.isSegmentMatched",SegmentMatched)
            }            
           
        // Bug 22425 CC Code changes SME E

        /*if(!this.isEmpty(poObj) && !this.isEmpty(Lead) &&
           (!this.isEmpty(offerAmount) || !this.isEmpty(segmentation) || !this.isEmpty(LAN) || !this.isEmpty(cibilScore))){
            component.set("v.offerAmount", offerAmount);
            component.set("v.segmentation", segmentation);
            component.set("v.cibilScore", cibilScore);
            component.set("v.LAN", LAN);
            component.set("v.PO", poObj);
            component.set("v.Lead", Lead);
            console.log('details'+ poObj);
            this.showHideDiv(component, "offerDetails", true);
           
        }*/
        if(!this.isEmpty(poObj) && !this.isEmpty(Lead) &&
           (!this.isEmpty(offer.offerAmount) || !this.isEmpty(offer.segmentation) || !this.isEmpty(offer.loanNumber) || !this.isEmpty(offer.cibilScore))){
            component.set("v.offer", offer);
            component.set("v.Lead", Lead);
            component.set("v.PO",poObj);           
           	//Bug 23801 S
            component.set("v.poRef",poObj.Ref__c);  
            //Bug 23801 E          
            component.set("v.offerROI", offer.Offer_ROI);
            component.set("v.offerPF", offer.Offer_PF);
            component.set("v.offerTenor", offer.Offer_Tenor);
            component.set("v.offerInsurance", offer.Offer_Insurance);
            component.set("v.offerProcessMaster", offer.Offer_ProcessMaster);
            component.set("v.loanNumber", offer.loanNumber);
        
            if(component.get("v.offer.converted") == true){
                console.log('inside checking2');
                component.set("v.IsCheckProcess", true); 
            }
               
            
            this.showHideDiv(component, "offerDetails", true);
         	this.fetchSOlPolicies(component);  
        }
        
    },// Bug 15855 S 
    navigateToCPV : function(component, event){
        console.log('Navigated to Loan'); 
        var oppId = component.get("v.loanId");
		
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": oppId,
          "slideDevName": "related"
        });
        navEvt.fire();
        
    },
    
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
   
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value));
    },

    ToggleCollapseHandler : function(component, event) {  
        var existingText = component.get("v.collpaseText"); 
        var container = component.find("containerCollapsable") ;
      //  var expandText = component.find("expand");
       // var collapseText = component.find("collapse");
     
        if(existingText === "-"){
             component.set("v.collpaseText","+");
            $A.util.addClass(container, 'slds-hide');
        //    $A.util.addClass(collapseText,'hide');
        //    $A.util.removeClass(expandText,'hide');
            $("#containerCollapsable").slideUp("slow");
         
        }else{
            component.set("v.collpaseText","-");
            $A.util.toggleClass(container, 'slds-hide');
		//	$A.util.addClass(expandText,'hide');
         //   $A.util.removeClass(collapseText,'hide');
            $("#containerCollapsable").slideDown("slow");
        }  
	},
    
    callSTPBREIntegration : function(component, divId, show){
        //alert('calling callSTPBREIntegration...');
        if(component.isValid()){
            this.executeApex(component, "BRESTPCall", {"poId" : component.get("v.PO.Id")}, function(error, result){
                if(!error && result){
                    result = JSON.parse(result);
                    if(result.status === "Success"){
                         this.showToast(component, "Success!",result.message, "success");
                         component.set("v.offerProcessMaster",result.product)
                         //this.fetchSOlPolicies(component); Priyanka
                         var event = $A.get("e.c:UpdateAlldata");
                         event.fire();
                                                    
                    }else if(result.status === "FAILED")
                    {
                        this.showToast(component, "Info!",result.message, "info");
                        this.executeApex(component, "DummyPolicyCreate", {"poId" : component.get("v.PO.Id"),"reason" : result.message}, function(error, result){
                            if(!error && result){            
                                component.set("v.offerProcessMaster","NON_STP_B")
                                //this.fetchSOlPolicies(component);
                                 var event = $A.get("e.c:UpdateAlldata");
                                 event.fire();
                                                    
                                }
                    
                            
                        });
                    }
                }
            });
        }
   
    },
    
    fetchSOlPolicies : function(component){
    	this.executeApex(component, "FetchSolPolicy", {"poId" : component.get("v.PO.Id")}, function(error, result){
            if(!error && result)
            {
                component.set("v.SolPolicy", result.SOL_Policys__r);
                component.set("v.offerProcessMaster",result.Process_Master__c);
                var stpNonStpVar = 'STP';
                if(component.get("v.SolPolicy"))
                {
                    if(component.get("v.SolPolicy").length > 0)
                    	stpNonStpVar = 'Non-STP';
                }
                //POS YK s
                var stpNonStpEvent = $A.get("e.c:POS_StpNonStpFlow");
                if(stpNonStpEvent != undefined)
                {
                    stpNonStpEvent.setParams({ "flowName" : stpNonStpVar });
                    stpNonStpEvent.fire();
                }
                //POS YK e
            }
        });
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
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    
    closeToast: function(component){
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    
    setSTPData :function(component){
        this.fetchSOlPolicies(component);
    },
     showHideDiv: function(component, divId, show){
        if(divId !== "nextButtonId"){
            $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        }
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
   
})