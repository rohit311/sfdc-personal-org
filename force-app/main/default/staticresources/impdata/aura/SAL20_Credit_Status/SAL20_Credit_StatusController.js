({
    onInit : function(component, event, helper) 
    {    
        component.set("v.isProcessing", true);
		var utility = component.find("toastCmp");
        
        try
        {
            var action = component.get("c.fetchPrimaryApplicant");
            action.setParams({oID: component.get("v.oId")} );
            action.setCallback(this, function( res){
                if ('FAILURE' != res.getReturnValue())
                {
                    var response = JSON.parse(res.getReturnValue() );
                    
                    component.set("v.appRecordId", response.Primary_App_Id);
                    var optsNoteCode = JSON.parse(response.NoteCode);        
                    var optsPayType =  JSON.parse(response.PayType);

                    var optsNC = [];    optsNC.push({label:'--None--', value: null});
                    var optsPT = [];    optsPT.push({ label: '--None--', value: null });
                    if (optsNoteCode)
                    {
                        for(var i =0; i< optsNoteCode.length; i++)
                        {
                            if (optsNoteCode[i])
                            {
                                console.log(optsNoteCode[i]);
                                optsNC.push({
                                    label : optsNoteCode[i],
                                    value : optsNoteCode[i]
                                });
                            }
                        }
                    }

                    if (optsPayType) 
                    {
                        for (var i = 0; i < optsPayType.length; i++) 
                        {
                            if (optsPayType[i]) 
                            {
                                optsPT.push({
                                    label: optsPayType[i],
                                    value: optsPayType[i]
                                });
                            }
                        }
                    }
                    //since we have updated the record id, we need to reload the record
                    component.find("recordHandler").reloadRecord($A.getCallback(function (saveResult) {
                        
                    }));

                    component.set("v.optionsNC" ,   optsNC);
                    component.set("v.optionsPT",    optsPT);
                }
                else
                {
                    utility.showToast('Error!', 'Something went wrong! Please check with your administrator!' , 'error');
                }
                component.set("v.isProcessing",     false);
            });
            $A.enqueueAction(action);
        }catch(err){
            component.set("v.isProcessing", false);
        }
	},
    
    handleSaveRecord : function(component, event, helper){

        component.set("v.isProcessing", true );

        try{
            component.find("recordHandler").saveRecord($A.getCallback(function (saveResult) {
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    // handle component related logic in event handler
                    var utility = component.find("toastCmp");
                    utility.showToast('Success!', 'Record Saved Successfully!', 'success');                    
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }

                component.set("v.isProcessing", false);
            }));
        }
        catch(err){
            component.set("v.isProcessing", false);
        }
        
    },

})