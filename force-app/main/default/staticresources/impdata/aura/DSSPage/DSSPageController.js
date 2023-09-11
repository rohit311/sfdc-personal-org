({
    toggletab : function(component, event, helper) {
        console.log('hi'+event.target.id);
        helper.toggleAccordion(component,event);
    },
    disablepage: function(component,event,helper)
    {
        console.log('inside disablepage'+component.get("v.disablepage"));
        if(component.get("v.disablepage"))
            helper.showSpinner(component);           
        //$('.demo-only').css('pointer-events','none');
        else
            helper.hideSpinner(component);
        // $('.demo-only').css('pointer-events','');   
    },
    employerChange : function(component, event, helper) {
        if(event.getParam("value") != null && event.getParam("value").Id != null)
        {
            helper.getCompanyCat(component,event.getParam("value").Id);
            if(event.getParam("value").Name != undefined && ((event.getParam("value").Name).toLowerCase() == 'others' || (event.getParam("value").Name).toLowerCase() == 'other' || (event.getParam("value").Name).toLowerCase() == 'company not listed')){                
                
                component.set("v.isOther",true);
            }
            else{
                component.set("v.isOther",false);
            }
        }
    },
    /*method to fetch data
     
     * */
    
    doInit: function(component, event, helper) {
        //added for bug id 21851 start  
        // helper.getHideAadhaarSectionHelper(component);
         var action = component.get("c.getHideAadhaarSection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar DSS>>>'+response.getReturnValue());
               		component.set('v.hideAadhaarSection',response.getReturnValue()); 
                if(component.get("v.hideAadhaarSection")==false){
                    var tempPathList = ['AadharTab','McpTab','ObligationTab','EligibilityTab','McpOutputTab','CommunicationTab','PerfiosTab'];
                    component.set('v.pathList',tempPathList); 
                     component.set('v.activePath','AadharTab');
                    component.set('v.disablePrev',true);
                    component.set('v.disableNext',false);
                    
                }else if(component.get("v.hideAadhaarSection")==true){
                   var tempPathList =  ['McpTab','ObligationTab','EligibilityTab','McpOutputTab','CommunicationTab','PerfiosTab'];
                	 component.set('v.pathList',tempPathList);  
                    component.set('v.activePath','McpTab');
                    component.set('v.disablePrev',true);
                    if(component.get("v.oppId") != null)
                        	component.set('v.disableNext',false);
                    else
                    	component.set('v.disableNext',true);
                    $A.util.removeClass(component.find("McpTabContent"), "slds-hide");
                    $A.util.addClass(component.find("McpTabContent"), "slds-show");
                    $A.util.removeClass(component.find("McpTab"), "slds-is-incomplete");
                    $A.util.addClass(component.find("McpTab"), "slds-is-current slds-is-active");
                }
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
        //added for 21851 end
      //  alert('doint>>'+screen.width);

        if(component.get("v.oppId") != null){
            console.log('doinit'+component.get("v.oppId"));
            debugger;
            helper.getDssDetails(component, component.get("v.oppId"));
        }
        else{
            helper.getDssDetails(component,"");
            component.find("copyekycaddress").set("v.disabled", true);
        }
        console.log('doint>> end');
        console.log('component.get("v.oppId") ---->> '+component.get("v.oppId"));
    },
    submitDetails : function(component, event, helper){
        /*Validations */
        
        var validmcp = component.find('mcpForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validmcp){
            console.log('Employer'+component.get("v.accObj.Employer__r.Name"));
            if($A.util.isEmpty(component.get("v.accObj.Employer__r.Name")) || $A.util.isEmpty(component.get("v.oppObj.Sourcing_Channel__r.Name"))){
                helper.displayMessage(component, 'ErrorToast1', 'errormsg1', '<b>Error!</b>,Please Enter Employer and Sourcing Channel!');
            }
            //Rohit 16111 CR start
           /*else if(!component.find("copyekycaddress").get("v.value")){
                helper.displayMessage(component, 'ErrorToast1', 'errormsg1', '<b>Error!</b>,Please initiate Ekyc!');
            }*/
             //Rohit 16111 CR end
            else{
                helper.submitMCPDetails(component,  event, helper);
            }
        }
        else{
            helper.displayMessage(component, 'ErrorToast1', 'errormsg1', '<b>Error!</b>,Please fill all mandatory fields!');
        }
        
        
    },
    copyekycaddress: function (component, event) {
        var checkCmp = component.get("v.copyekycaddressflag");
        console.log("checkCmp" + component.get("v.copyekycaddressflag"));
        console.log('addres>>' + component.get("v.resiAddress"));
        //Rohit S
        var oldAcc;
      
        
        if(!$A.util.isEmpty(component.get("v.accObj")))
        {
            if($A.util.isEmpty(component.get("v.prevfirstName")))
           	 component.set("v.prevfirstName",component.get("v.accObj.First_Name__c"));
            if($A.util.isEmpty(component.get("v.prevlastName")))
           	 component.set("v.prevlastName",component.get("v.accObj.Last_Name__c"));
            if($A.util.isEmpty(component.get("v.prevDOB")))
           	 component.set("v.prevDOB",component.get("v.accObj.Date_of_Birth__c"));
            if($A.util.isEmpty(component.get("v.prevGender")))
           	 component.set("v.prevGender",component.get("v.accObj.Gender__c"));
            if($A.util.isEmpty(component.get("v.prevPincode")))
           	 component.set("v.prevPincode",component.get("v.accObj.Current_PinCode__c"));
            if($A.util.isEmpty(component.get("v.prevEmail")) || component.get("v.prevEmail") == undefined)
           	 component.set("v.prevEmail",component.get("v.contObj.Email"));
            if($A.util.isEmpty(component.get("v.prevAddress")))
           	 component.set("v.prevAddress",component.get("v.resiAddress"));
        }
        var accobj12 = component.get("v.prevfirstName");
        console.log('savedaccobj>>');
        console.log(accobj12);
        if (checkCmp === true && !$A.util.isEmpty(component.get("v.kyc.eKYC_Address_details__c"))) {
            console.log("checkCmpinside" + component.get("v.copyekycaddressflag"));
            component.set("v.resiAddress", component.get("v.kyc.eKYC_Address_details__c"));
            
            //Rohit added for details copy S
            var accObj = component.get("v.accObj");
            var ekyc = component.get("v.kyc");
            accObj.First_Name__c = component.get("v.kyc.eKYC_First_Name__c");
            accObj.Last_Name__c = component.get("v.kyc.eKYC_Last_Name__c");
            accObj.Date_of_Birth__c = component.get("v.kyc.eKYC_Date_of_Birth__c");
           // accObj.Gender__c = component.get("v.kyc.eKYC_Gender__c");
            //Rohit added for gender S
            console.log('robin '+component.get("v.kyc.eKYC_Gender__c"));
            if(component.get("v.kyc.eKYC_Gender__c") != undefined && component.get("v.kyc.eKYC_Gender__c") != ''){
                if(component.get("v.kyc.eKYC_Gender__c") == 'F'){
                     accObj.Gender__c = 'Female';
                }
                else if(component.get("v.kyc.eKYC_Gender__c") == 'M'){
                     accObj.Gender__c = 'Male';
                }
                
            }
            //Rohit added for gender E
            accObj.Current_PinCode__c = component.get("v.kyc.eKYC_Pin_Code__c");
             component.set("v.accObj", accObj);
            var contObj = component.get("v.contObj");
            contObj.Email = component.get("v.kyc.eKYC_E_mail__c");
             component.set("v.contObj", contObj);
            console.log('acc '+ekyc.eKYC_Pin_Code__c);
           //Rohit added for details copy E
        } else if(checkCmp === false){
           	 console.log('insideelsefirstname');
             component.set("v.accObj.First_Name__c",component.get("v.prevfirstName"));
            component.set("v.accObj.Last_Name__c",component.get("v.prevlastName"));
            component.set("v.accObj.Date_of_Birth__c",component.get("v.prevDOB"));
            component.set("v.accObj.Gender__c",component.get("v.prevGender"));
            component.set("v.accObj.Current_PinCode__c",component.get("v.prevPincode"));
            component.set("v.contObj.Email",component.get("v.prevEmail"));
            component.set("v.resiAddress",component.get("v.prevAddress"));
        }
    },
    initiateKYCForm: function (component, event) {
        component.set("v.kyc", event.getParam("kyc"));
        console.log("kyc details12345"+event.getParam("kyc"));
        console.log("kyc details" + component.get("v.kyc"));
        if(!$A.util.isEmpty(component.get("v.kyc"))){
            if ( !$A.util.isEmpty(component.get("v.kyc.eKYC_Address_details__c"))) {
                console.log('inside if of initiateKYCForm');
                component.find("copyekycaddress").set("v.disabled", false);
            } else
                component.find("copyekycaddress").set("v.disabled", true);
        }
        else{
            component.find("copyekycaddress").set("v.disabled", true);
        }
        if(component.get("v.oppId") != null){
            console.log('Opp Cmp+'+component.get("v.oppId"));
            //helper.updateeKYCForOpp(component, event);
            var kyc = component.get("v.kyc");
            console.log(kyc);
            if (kyc) {
                kyc.Applicant__c = component.get("v.applicantObj").Id;
                component.set('v.kyc', kyc);
                console.log("KYC : " + kyc.Id);
                if (!$A.util.isEmpty(kyc.Id) && !$A.util.isEmpty(component.get("v.applicantObj").Id) ) {
                    console.log("KYC inside : " + kyc.Id);
                    var kyc = component.get("v.kyc");
                    var action = component.get("c.saveKYCforOpp");
                    var params = {
                        ekycObj : JSON.stringify([component.get("v.kyc")]),
                        appObj : JSON.stringify([component.get("v.applicantObj")])
                    };
                    action.setParams(params);
                    action.setCallback(this, function (response) {
                        var state = response.getState()
                        var result = response.getReturnValue();
                        console.log('ekyc result1'+result);
                        if (state === 'SUCCESS' && result) {
                            component.set("v.kyc", result);
                            console.log(result);  
                        }
                    }); 
                    $A.enqueueAction(action);
                    
                    var appEkycEvent = $A.get("e.c:Sal_Opp_EkycEvent");
                    appEkycEvent.setParams({
                        "eKycObj" : component.get("v.kyc")
                    });
                    appEkycEvent.fire();
                }
            }
        }
    },
    menuItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'),true);
         /*Bug 18669 Start*/
        console.log('aadharValueDss is : '+component.get('v.aadharValueDss'));
        if(component.get('v.aadharValueDss') == 'Biometric'){
        console.log('Random Number inside Menu ItemClick : '+component.get("v.randomNum"));
        helper.getEKYCRecHelper(component,component.get("v.randomNum"));
        
        console.log('KYC Applicant Id : '+component.get('v.kyc.Applicant__c'));
         if(component.get('v.kyc') != null || !$A.util.isEmpty(component.get('v.kyc'))) {
             if(component.get('v.kyc.Applicant__c') != null){
                 component.set('v.applicantObj.eKYC_Processing__c',true);
             }
             if ( !$A.util.isEmpty(component.get("v.kyc.eKYC_Address_details__c"))) {
                     console.log('inside menuitemprev');
                     component.find("copyekycaddress").set("v.disabled", false);
                     console.log('After copyekycAddress :'+component.get('v.kyc.eKYC_Address_details__c'));
             }
         }
        }
       /* Bug 18669 End*/
        if(event.target.getAttribute('id') == 'McpOutputTab')
        {
            var EligibilityTabCmp = component.find("EligibilityTabCmp");
            EligibilityTabCmp.callEligibilityTab();
        }
    },
    prevStage :function(component, event, helper){ 
        var previous ='';
        var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
        for(var i=0; i < pathList.length; i++) {
            if(pathList[i] == activepath){
                component.set("v.disablePrev", false); 
                component.set("v.disableNext", false);
                /*Bug 18669 Start*/
                if(pathList[i-1] == 'AadharTab'){
                    if(component.get('v.aadharValueDss') == 'Biometric'){
                        if(component.get('v.kyc') != null){
                            if(component.get('v.kyc.Applicant__c') != null){
                                component.set('v.applicantObj.eKYC_Processing__c',true);
                            }
                            if ( !$A.util.isEmpty(component.get("v.kyc.eKYC_Address_details__c"))) {
                                console.log('inside prev');
                                component.find("copyekycaddress").set("v.disabled", false);
                                console.log('After copyekycAddress :'+component.get('v.kyc.eKYC_Address_details__c'));
                            }
                    	}
                    }
                }
               /* Bug 18669 End*/
                console.log('i>>>'+i);
                if(i !=0){
                    console.log('i>>>pathList>>>'+pathList);
                    previous = pathList[i-1];
                    helper.activateTab(component,previous,false);
                }
                if(i==1){
                    component.set("v.disablePrev", true); 
                }
                component.set("v.StageNum",i);
            }
        }
        // var items = $(".slds-path__item"); 
        var items = $(".stage_item");
        var scrollContainer = $(".offer-pg-cont");
        var item = helper.fetchItem(component,scrollContainer, items, false);
        if (item){
            var currentleft = scrollContainer.scrollLeft();
            var addleft = item.position().left + scrollContainer.scrollLeft();
            if(addleft < currentleft){
                //alert('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left+'>>item.width()>>'+item.width());
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
            }
        }
    }, 
    nextStage :function(component, event, helper){ 
        var next ='';
        var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
        for(var i=0; i < pathList.length; i++) {
            if(pathList[i] == activepath){
                component.set("v.disablePrev", false); 
                component.set("v.disableNext", false);
                console.log('applicantObj : '+component.get('v.applicantObj.Id'));
                /*Bug 18669 Start*/
                if(component.get('v.aadharValueDss') == 'Biometric'){
                    if(pathList[i+1] == 'McpTab'){
                        console.log('Random Number inside Menu ItemClick : '+component.get("v.randomNum"));
                        helper.getEKYCRecHelper(component,component.get("v.randomNum")); 
                    }
                }
               /* Bug 18669 End*/
                if(i !=6){
                    next = pathList[i+1];
                    helper.activateTab(component,next,false);
                }
                console.log('oppiD>>'+component.get("v.oppId")+'>>i>>'+i);
                if(i==6 || ($A.util.isEmpty(component.get("v.oppId")) && i==0)){ 
                    component.set("v.disableNext", true); 
                }
                component.set("v.StageNum",i+2);    
            }
        }
        var items = $(".stage_item");
        var scrollContainer = $(".offer-pg-cont");
        var item = helper.fetchItem(component,scrollContainer, items, true);
        if (item){
            //scroll to item
            //alert(item.width());
            var currentleft = scrollContainer.scrollLeft();
            var addleft = item.position().left + scrollContainer.scrollLeft();
            //  alert('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
            if(addleft > currentleft){
                // scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400); 
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400); 
                
            }
        }
    },
    closeToastnew: function (component, event, helper) {
        helper.closeToastnew(component, event.target.id);
    },
    closeToastError: function (component, event, helper) {
        helper.closeToastError(component, event.target.id);
    },
    closeModal : function(component,event){    
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },
    continueMCP : function(component,event,helper){ 
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        if(!component.get("v.oppId")){
            var theme = component.get("v.theme");
            if(theme == 'Theme3' || theme == 'Theme2')
            {
                location.replace("SALMobility_Opp_page?recordId="+component.get("v.tempOppId")+'&flow=new'); 
            }
            else{
                console.log('continue start>>'+screen.width);
                component.set("v.oppId",component.get("v.tempOppId"));   
                
                //$A.util.addClass(component.find("PathId"), "offer-pg-cont");
                // $A.util.addClass(component.find("offer-pg"), "offer-pg");
                //helper.activateTab(component,'ObligationTab',false,true);
                console.log('continue end');
                var displayTab = $A.get("e.c:DisplayObligationTab");
                displayTab.setParams({"displayObligation" : true});
                displayTab.fire();
            }
            
        }
        else 
            component.set("v.oppId",component.get("v.tempOppId")); 
        
    },
    DisplayObligationTab : function(component,event,helper){ 
        
        var displayObligation = event.getParam('displayObligation');
        component.set("v.flow", displayObligation);
        helper.activateTab(component,'ObligationTab',false);
    }
})