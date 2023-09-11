({
	doInit : function(component, event, helper) {
		
        // logic inside init is moved to getRepaymentObject for bugId :21623
        
        /* Added for Emandate 20902 */
        if(component.get("v.posLaFlag")){
            var targetElement = component.find('eMandateButton');           
            targetElement.set("v.variant", "neutral"); 
            component.set("v.eMandateButtonClass", "slds-button slds-button_neutral");    
        }
        else{
            var id = component.get("v.id");
            console.log('id in component :::' + id);
            if (!id) {
                alert('Opportunity Id is either null or empty!');
                return;
            }
            //debugger
            var fetchRepayObject = component.get("c.getRepayObject");
            
            fetchRepayObject.setParams({"oppId" : id });
            fetchRepayObject.setCallback(this, function(response) {
                //debugger;
                console.log('response.getState() --> ' + response.getState());
                console.log(response.getReturnValue());
                if (response.getState() === "SUCCESS") {
                    var resp = response.getReturnValue();
                    if(resp){
                        component.set("v.rObj", JSON.parse(resp) );
                        console.log('pk repay'+JSON.parse(resp));
                        component.set("v.renderButton", true );
                        var oRepayObject = component.get("v.rObj");
                        if(oRepayObject.UMRN__c){
                            component.set("v.isDisabled", true );
                        }
                        console.log('Test:::' + JSON.stringify(oRepayObject ) );
                    }
                }
            });
            $A.enqueueAction(fetchRepayObject);
        }
        //helper.getRepaymentObject(component, event, helper);

	},
    
    onInitiateEmandate:function(component, event, helper) {
        console.log(':::onInitiateEmandate:: '+component.get("v.posLaFlag"));
        // Added for bugId 21623 -- fetch the repayment record again to get updated record 
        if(component.get("v.posLaFlag")){
        	helper.getRepaymentObject(component, event, helper);
        }
        else{
        	helper.validate(component, event, helper);    
        }
        
        // Below commented by harshal for bugId 21623 -- validate call is move inside getRepaymentObject
		//helper.validate(component, event, helper);
    },
 closeCustomToast : function(component, event, helper){
        /*
         * Method Name:	 	closeCustomToast
         * Functionality: 	To peform close activity on Custom Toast Message
         * @param: 			component, event, helper
         * @return:			NA
         * From requirement number: Bug 20391 - Ops 2.0 Lightning
         * Invoked from: 	Custom Toast : Close  button
         * Invoking:		SAL20_DiscrepancyUpdate : helper.closeToast
        */
        
        helper.closeToast(component);
    } 
})