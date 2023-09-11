({
	/*getCardData : function(component,event) {
		var action = component.get("c.getCardData");
        action.setParams({"oppId": component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var responseStr = JSON.parse(response.getReturnValue());
                console.log('...inside success...'+response.getReturnValue());
                component.set("v.theme", responseStr.theme);
                component.set("v.profileName", responseStr.myProflieName);
                component.set("v.oppObj", responseStr.opp);
                component.set("v.accObj", responseStr.accObj);
                component.set("v.priAppObj", responseStr.applicantPrimary);
                component.set("v.priConObj", responseStr.objCon);
                console.log('opp'+responseStr.opp.Id+' app'+responseStr.applicantPrimary.Id+' Acc'+responseStr.accObj.Id+' con'+ responseStr.objCon.Id)
                console.log('theme-->'+component.get("v.theme"));
                if(component.get("v.theme") == 'Theme4d')
                {
                    var cmpTarget = component.find('boxBorder');
                    $A.util.addClass(cmpTarget, 'slds-box slds-box_x-small');
                      
                }
                var oppStage = responseStr.opp.StageName;
                if(oppStage != null)
                {
                    if(oppStage == 'DSA/PSF Login')
                    {
                        component.set("v.stageCompletion","20%") ;
                    }
                    else if(oppStage == 'Underwriting')
                    {
                        component.set("v.stageCompletion","40%");
                    }
                    else if(oppStage == 'Post Approval Sales')
                    {
                        component.set("v.stageCompletion","60%");
                    }
                    else if(oppStage == 'Branch Ops')
                    {
                        component.set("v.stageCompletion","80%");
                    }
                    else if(oppStage == 'Moved To Finnone')
                    {
                        component.set("v.stageCompletion","100%");
                        $A.util.addClass(component.find("progressSpan"),"slds-progress-bar__value_success");
                    }    
                }
            }
            component.set("v.openTab",true);
        });
        $A.enqueueAction(action);  
	},
    */
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
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