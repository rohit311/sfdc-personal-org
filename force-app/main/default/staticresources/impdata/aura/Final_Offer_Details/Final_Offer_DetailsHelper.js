({
     
	
         
    CheckPO : function(component) {
        console.log('inside checkpo'+component.get("v.account.Id"));
      console.log('insidecheckcon'+JSON.stringify(component.get("v.contact")));

        this.executeApex(component, "getOfferDetails", {
            'oppObj': JSON.stringify(component.get("v.loan")),
            'accObj': JSON.stringify(component.get("v.account")),
            'appObj': JSON.stringify(component.get("v.applicant")),
            'conObj': JSON.stringify(component.get("v.contact"))
        }, function (error, result) {
            
            if (!error && result) {
                var objlst = JSON.parse(result);
                component.set("v.loan", objlst.opp);
                component.set("v.POobj", objlst.poobj);
                console.log('CAMI IS +' +JSON.stringify("v.camObj"));
                component.set("v.camObj", objlst.camObj);
				//9465 start
                var final_foir = component.get("v.camObj").Secured_FOIR__c + component.get("v.camObj").Unsecured_FOIR__c;
                        final_foir = parseFloat(final_foir).toFixed(2);
                        component.set("v.final_foir",final_foir);
                
                 if(!$A.util.isEmpty(component.get("v.loan").Scheme_Master__r))
           			component.set("v.isHybirdFlexi",component.get("v.loan").Scheme_Master__r.IsHybridFlexi__c);
        	
                console.log('flexi is::'+component.get("v.ishybridflexi"));
                 //9465 stop
               // component.set("v.bankAccount", objlst.bankObj);//bankaccount partial CR
                console.log('Object list is::'+objlst.applicantPrimary);
                console.log('Object list is::'+objlst);
                console.log('objlst.bankObj::'+JSON.stringify(objlst.bankObj));
                //component.set("v.averageSal",averageSal);
                component.set("v.applicant", objlst.applicantPrimary);
                // alert(component.get("objlst.applicantPrimary"));
                component.set("v.contact",objlst.objCon); // <--added by Hrushikesh 
                component.set("v.isPreapproved", objlst.isPreapproved);
                console.log('inside checkpo2'+component.get("v.account.Id"));
                 // user story 978 start
                if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isCredit") == false) {
               var updateidentifier =  $A.get("e.c:Update_identifier");
                updateidentifier.setParams({
                    "eventName": 'Offer',
                    "oppId":component.get("v.loan").Id
                });
                updateidentifier.fire();
                }
                  // user story 978 end 
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Success','Offer fetched successfully','success');//1652
                        console.log('Cibil 2score is'+component.get("v.applicant.CIBIL_Score__c"));
                        

            }
            else{
                this.displayToastMessage(component,event,'Success','Offer fetched successfully','success');//1652
                this.showhidespinner(component,event,false);
            }
        });
    },
    validateSourceData :function (component) {
        var list = ["offerROI","offerTenor","pf","offerEMI"];
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]);
            //console.log(component.find(list[i]));
            //var a =component.find("AppSource");
            // console.log(a);
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        return isvalid;
    },
    saveEligibility: function(component,event ) {
        console.log('saveEligibility');
        this.executeApex(component, "callEligibiltySegmentation", {"oppId": component.get("v.oppId"), "camObj" : JSON.stringify(component.get("v.camObj"))}, function(error, result){
            if(!error && result){
                var appData = JSON.parse(result);
                this.showhidespinner(component,event,false);
                if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.camObj))
                    component.set("v.camObj",appData.camObj);
                    console.log('saveEligibility maxEligiAmtMCP'+appData.maxEligiAmtMCP);
                console.log('saveEligibility maxEligiAmtMCP'+appData.maxEligiAmtMCP);
                if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.maxEligiAmtMCP))
                    component.set("v.amountaspereligibility",appData.maxEligiAmtMCP);
                this.displayToastMessage(component,event,'Success','Eligibility calculated successfully','success');
                
            }
            else if($A.util.isEmpty(result)){
                this.showhidespinner(component,event,false);
            }else{
                this.showhidespinner(component,event,false);
            }
        });
    },
    enhanceOffer :function(component , event) {
        this.showhidespinner(component,event,true);
        var acc = component.get("v.account");
        var cam = component.get("v.camObj");
        console.log('pkinhanced'+component.get("v.account.Id"));
        acc.Offer_Inhanced__c = true;
        //component.set("v.account",acc)
         if(!component.get("v.isPreapproved"))//26795 1652 added
        component.find("loanVariant").set("v.disabled",true);//US 1652
        console.log('in helper'+acc.Id);
        this.executeApex(component, "saveOfferInhanced", {"accJSON": JSON.stringify(component.get("v.account"))}, function(error, result){
            if(!error && result){
                console.log('offer inhanced');
                var appData = JSON.parse(result);
                
                if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.accObj))
                component.set("v.account",appData.accObj);
                //console.log('camobj'+component.get('camObj').Tenor__c+component.get('camObj').ROI__c); 
                this.showhidespinner(component,event,false);
                if(appData.status == 'Success')
                {
                    	component.find("enhanceOfferButton").set("v.disabled",true);
                    cam.Monthly_Reimbursement__c ='';
                    cam.Average_Monthly_Net_Income1__c=''; 
                    component.set("v.camObj",cam);
                this.displayToastMessage(component,event,'Success','Offer enhanced successfully','success');
                }
                    else
                 this.displayToastMessage(component,event,'Error','Failed to offer enhance'+appData.status,'error');
            }
            else{
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Failed to enhance offer','error');
                
            }
            
        });
        
        
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    updateCamObjHelper : function(component,event) {
        console.log('updateCamObjHelper');
        this.showhidespinner(component,event,true);
        this.executeApex(component, "updateCam", {"camObj": JSON.stringify(component.get("v.camObj"))}, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result)){
                    console.log('result'+result.Tenor__c);
                    component.set("v.camObj",result);
                    this.saveEligibility(component,event);
                }else{
                    console.log('fail to save data');
                    this.showhidespinner(component,event,false);
                }
            }
            else
            {
                this.showhidespinner(component,event,false); 
            }
            
        });
    },
    saveCamObjectOnly : function(component,event) {
        console.log('update only cam object'+component.get("v.camObj").Id);
        this.showhidespinner(component,event,true);
        this.executeApex(component, "updateCamAndOpp", {"camObj": JSON.stringify(component.get("v.camObj")),"oppObj": JSON.stringify(component.get("v.loan"))}, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result)){
                    var objlst = JSON.parse(result);
                    console.log('result of updateCamAndOpp '+objlst);
                    component.set("v.camObj",objlst.camObj);
                   component.set("v.loan",objlst.opp);
                   this.showhidespinner(component,event,false);
                   this.displayToastMessage(component,event,'Success','Data saved successfully','success');
                }else{
                    console.log('fail to save data');
                    this.showhidespinner(component,event,false);
                }
            }
            else
            {
                this.showhidespinner(component,event,false); 
            }
            
        });
    },
    
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
     saveBankRecordcntrl : function(component,event) {
         var bankobj = component.get("v.bankAccount");
         bankobj.Loan_Application__c =component.get("v.loan").Id ;
         if(component.get("v.primaryApp").Id)
         bankobj.Applicant__c = component.get("v.primaryApp").Id ;
         else
         bankobj.Applicant__c = component.get("v.applicant").Id ; 
        this.executeApex(component, "saveBankRecord", {"bankRec": JSON.stringify(bankobj)}, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result)){
                    var dssData = JSON.parse(result);
                    component.set("v.bankAccount",dssData.bankObj);
                     this.showhidespinner(component,event,false);
                }else{
                    console.log('fail to save data');
                    this.showhidespinner(component,event,false);
                }
            }
            else
            {
                this.showhidespinner(component,event,false); 
            }
            
        });
    },
})