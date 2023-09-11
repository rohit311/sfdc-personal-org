({
    doinit: function (component, event, helper) {
       // component.set("v.showfinaloffer",false);//performance issue
        helper.showhidespinner(component,event,true);
        //component.set("v.showfinaloffer",false)
        helper.getHideAadhaarSectionHelper(component); //  added for bug id 22047
        var sPageURL = decodeURIComponent(window.location.href);
        console.log('doinit>>' + sPageURL);
        var oppId = component.get("v.recordId");
        console.log('oppId>>' + oppId);
        if(!$A.util.isEmpty(oppId)) {
            component.set('v.oppId', component.get("v.recordId"));
            // helper.showhidespinner(component,event,true);
            helper.getloggedinuserprofile(component,event,true); //added for bug 23064
            var action = component.get("c.checkRedirectionValidity");
            action.setParams({
                "oppId": oppId,
                "flowName": 'creditFlow',
                "version" :'Mobility V2'
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    console.log('...inside success...');
                    var wrapperObj = response.getReturnValue();
                    
                    console.log('wrapperObj.errorMessageString--->> '+wrapperObj.errorMessageString);
                    if(wrapperObj.errorMessageString != 'NO_ERROR')
                    {
                        helper.showhidespinner(component,event,false);
                        component.set("v.cmpLoadMsg", wrapperObj.errorMessageString);
                    } 
                    else
                        helper.getoppDetails(component, event);
                }
            });
            $A.enqueueAction(action); 
        }
    },
    fireFinalOff : function(component, event, helper){
        var appEvent = $A.get("e.c:fireDynOffer");
        if(appEvent){
            appEvent.fire();
        }    
    },
    loadDashboard : function(component, event, helper){
        var navToDash = $A.get("e.c:navigateToDashboard");
        navToDash.setParams({
            "display" : true
        });
        if(navToDash){
            navToDash.fire();
        }  
        var evt1 = $A.get("e.c:DestroyDashboardChild");
        
        evt1.fire();
        /*var appEvent = $A.get("e.c:loadCreditDashboard");
        if(appEvent){
            appEvent.fire();
        }    */  
    },
    callaccordianmethod : function(component, event, helper){
        // alert(component.find("accordion").get('v.activeSectionName'));
        //    // user story 978 s
        var stage = component.get("v.stageName");
        var updateidentifier =  $A.get("e.c:Update_identifier");
        updateidentifier.setParams({
            "eventName": 'UW-Credit View Detais',
            "oppId":component.get("v.loan").Id
        });
        updateidentifier.fire();
         // user story 978 e
        /* CR 22307 */
        var stage = component.get("v.stageName");
        if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor'){
       
        var accordinaname = component.find("accordion").get('v.activeSectionName');
        if(accordinaname == 'Final_Offer')
        {
            var appEvent = $A.get("e.c:fireDynOffer");
            if(appEvent){
                appEvent.fire();
                console.log('inside');
            }     
        }
        else if(accordinaname == 'DemographicDetails')
        {
            console.log('pan bre fire');
            var appEvent = $A.get("e.c:firePanBreCheck");
            if(appEvent){
                appEvent.fire();
            }     
        }
        }
    },
    setConAcc:function(component, event, helper){//23466 prod issue
    
       var conObj =  event.getParam("conObj");
       var accObj =  event.getParam("accObj");
       if(!$A.util.isEmpty(conObj)) 
       		component.set("v.conObj",conObj);
       if(!$A.util.isEmpty(accObj)) 
       		component.set("v.accObj",accObj);
    }
    
})