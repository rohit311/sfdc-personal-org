({
	validate :function(component, event, helper) {
        //debugger
        //housekeeping stuff for Processing
        component.set("v.showSpinner", true);
        component.set("v.isDisabled", true);
       
		var repayObj = component.get("v.rObj");
        var validateRO = component.get("c.validateRepayObj");
        
        validateRO.setParams({ sRepay : JSON.stringify(repayObj) });
        //validateRO.setParams({ sRepay : repayObj });
        
        validateRO.setParams({ sRepay : JSON.stringify(repayObj) });
        validateRO.setCallback(this, function(response) {
            debugger;
            if (response.getState() === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('resp : '+resp);
                if(resp == 'SUCCESS'){  
                    console.log('generate bitly server call...!!!');
                    helper.generateBitlyCall(component,event,helper); // Bug:19726 - Call to generate Bitly
                }
                else{
                    //This means Repayment validation failed.
                   // alert(resp);
                     this.showToast(component,"Error",resp,"error")
                    //housekeeping stuff for Processing
                    component.set("v.showSpinner", false);
                    component.set("v.isDisabled", false);
                }
            }
            
            
        });
        $A.enqueueAction(validateRO);

	},
    
    //Bug:19726(Start) Server call to generate bitly
    generateBitlyCall : function(component, event, helper)
    {
        var rId =  component.get("v.rObj").Id;
        var id = component.get("v.id");
        debugger;
        console.log('in bitly generation server call :' + rId);
        if(rId){
            console.log('preparing for mandate server call');
            var bitlyGenerationAction = component.get("c.generateBitlyFunction");
            bitlyGenerationAction.setParams({ oId: id, repayId: rId });
            var bitlyResponse = this.executeAction(component, bitlyGenerationAction);

            bitlyResponse.then(
                $A.getCallback(function(result){
                    var bitlyResponseURL = result;
                    if(bitlyResponseURL){
                        if(bitlyResponseURL.includes("SUCCESS"))
                        {
                            var bitlyGenerated = bitlyResponseURL.split(';')[1];
                        }
                    }
                    helper.mandateServerCall(component, event, helper,bitlyGenerated);
                }),
                $A.getCallback(function(error){
                    console.log('Error :::'  +  error);
                     this.showToast(component,"Error","An error while creating bitly","error")
                    //alert('An error while creating bitly : ');
                })
         	);
        }
    }, //Bug:19726(End)
    
    mandateServerCall : function(component, event, helper,bitlyGenerated)// Bug:19726 Added bitlyGenerated to argument
    {
        var rId =  component.get("v.rObj").Id;
        var id = component.get("v.id");
        // alert('in mandate server call :' + rId);
        if(rId){
            console.log('preparing for mandate server call');
            var mandateServerCall = component.get("c.MandateInitiation");
            mandateServerCall.setParams({ oId: id, repayId: rId , generatedBitly: bitlyGenerated }); // Bug:19726 Added bitlyGenerated to argument
            mandateServerCall.setCallback(this, function (response) {
                console.log('response for mandate server call' + response.getReturnValue() );
                if (response.getState() === "SUCCESS") 
                {
                    console.log("Server call completed for E-Mandate!");
                    if(response.getReturnValue() == "SUCCESS")
                    {
                         
                        component.set("v.mandateProcessStage","In Progress");
                        this.showToast(component,"Success","Sent an SMS to the customer for mandate initiation!","success")
                       // alert('Sent an SMS to the customer for mandate initiation!');
                        //housekeeping stuff for Processing
                        component.set("v.showSpinner", false);
                        component.set("v.isDisabled", false);
                    }
                    else{
                        //housekeeping stuff for Processing
                        component.set("v.showSpinner", false);
                        component.set("v.isDisabled", false);
                        this.showToast(component,"Error","Something went wrong.","error")
                        //alert('Something went wrong.  ');
                    }
                }                
            });
            $A.enqueueAction(mandateServerCall);
        }
        else{
            this.showToast(component,"Error","Something went wrong. Please contact your administrator.","error")
            //alert('Something went wrong. Please contact your administrator. ');
        }
    },
    showToast : function(component, title, message, type){
        /*
         * Method Name:	 	showToast
         * Functionality: 	To peform show Toast Message activity
         * @param: 			component, title, message, type
         * @return:			NA
         * From requirement number: Bug 20391 - Ops 2.0 Lightning
         * Invoked from: 	SAL20_DiscrepancyUpdate Controller
         * Invoking:		NA
        */
       
        var self = this;
        console.log(self);
        var toastEvent = $A.get("e.force:showToast");
       
        if(toastEvent && !$A.get("$Browser.isIPhone")){ //Standard toast message : if supports standard toast message !$A.get("$Browser.isIPhone")
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
              
        }else { //Custom toast message : if doesn not support standard toast message
            var customToast = component.find('customToast');
            $A.util.removeClass(customToast, 'slds-hide');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme,"slds-theme--error");
            $A.util.removeClass(toastTheme,"slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme,"slds-theme--error");
            }
            else if(type == 'success'){
                $A.util.addClass(toastTheme,"slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            
            setTimeout($A.getCallback(() => this.closeToast(component)), 3000); //Auto close custom toast message
        }
    },
    closeToast : function(component){ 
        /*
         * Method Name:	 	showToast
         * Functionality: 	To peform close activity on Custom Toast Message
         * @param: 			component, title, message, type
         * @return:			NA
         * From requirement number: Bug 20391 - Ops 2.0 Lightning
         * Invoked from: 	SAL20_DiscrepancyUpdate Controller and helper
         * Invoking:		NA
        */
        
        var customToast = component.find("customToast");
        $A.util.addClass(customToast,"slds-hide");
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme,"slds-theme--error");
        $A.util.removeClass(toastTheme,"slds-theme--success");
    }, 
    //Bug:19726(Start) - Promise function so that emandate call is executed only after we receive bitly
    executeAction: function(cmp, action, callback) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
        $A.enqueueAction(action);
        });
	}, //Bug:19726(End)
    
    
    // Added for bugId 21623
    getRepaymentObject : function (component, event, helper){
    var id = component.get("v.id");
        console.log('id in component :::' + id);
        if (!id) {
            alert('Opportunity Id is either null or empty!');
            return;
        }
        debugger
        var fetchRepayObject = component.get("c.getRepayObject");
        
        fetchRepayObject.setParams({"oppId" : id });
        fetchRepayObject.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp){
                    component.set("v.rObj", JSON.parse(resp) );
                    component.set("v.renderButton", true );
                    var oRepayObject = component.get("v.rObj");
                    if(oRepayObject.UMRN__c){
                       component.set("v.isDisabled", true );
                    }
                    console.log('Test:::' + JSON.stringify(oRepayObject ));
                }
                this.validate(component, event, helper);
            }
        });
        $A.enqueueAction(fetchRepayObject);
     },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    
})