({
    checkAllSolPolicies: function(component,event)
    {
        
        console.log('inside checkall pk'+component.get('v.isdiablebutton'));
        var verSelectList = ["Status__c","Sales_Status__c","Credit_Status__c"];
        var checkSelectList = ["Status__c","Sales_Status__c"];
        var selectListNameMap = {};
        selectListNameMap["Verification__c"] = verSelectList;
        selectListNameMap["Checklist__c"] = checkSelectList;
        this.executeApex(component, "checkAllSolPoliciesMethod", {
            'oppId': component.get("v.Oppobj").Id,'objectFieldJSON':JSON.stringify(selectListNameMap)
        }, function (error, result) {
            //return is in Boolean, so Converted into String
            console.log('result is check'+JSON.parse(result));
            if (!error && result) {
                var resultStr = JSON.parse(result);
                console.log('inside checkall pk2');
                component.set("v.isValidIM_Products",resultStr.isValidIM_Products); //22018 RSL mobility
                debugger;
                var picklistFields = resultStr.picklistData;
                var verPickFlds = picklistFields["Verification__c"];
                console.log('veri status'+verPickFlds["Credit_Status__c"]);
                component.set("v.credStatus", verPickFlds["Status__c"]);
                component.set("v.creditStatusVer", verPickFlds["Credit_Status__c"]);
                /*Retrigger 20939 s*/
                // alert(resultStr.NoOfSolPolicyWithBreFlagTrue);       
                       //  alert('scorecard is '+component.get("v.primaryApp.Score_card__c"));
				 
                if(!$A.util.isEmpty(resultStr) && resultStr.NoOfSolPolicyWithBreFlagTrue > 0){
                    component.set("v.showRetrigger",true);  
                }
                /*20939 IM s*/
                else if(!$A.util.isEmpty(component.get("v.Oppobj").Product__c) && component.get("v.Oppobj").Product__c != 'RSL' && (resultStr.reTriggerIM || component.get("v.primaryApp.Score_card__c")==undefined || ($A.util.isEmpty(component.get("v.primaryApp.Score_card__c"))) && component.get("v.isValidIM_Products" ))){ //22018 //US 899
                    component.set("v.showIM",true)
                }	
                    else{
                       
                        component.set("v.showApproveRej",true)
                    }
                if(resultStr.reTriggerIM || $A.util.isEmpty(component.get("v.primaryApp.Score_card__c"))){ //added condition 20939 IM
                    component.set("v.reTriggerIM",true);
                }
                /*20939 IM e*/
                /*Retrigger 20939 e*/
                /*20939 IM e*/
                /*Retrigger 20939 e*/
                console.log('here @@@@ '+resultStr.reTriggerIM);
                component.set("v.salesStatus", verPickFlds["Sales_Status__c"]);
                var chkPickFlds = picklistFields["Checklist__c"];
                component.set("v.creditStatus", chkPickFlds["Status__c"]);
                component.set("v.saleStatus", chkPickFlds["Sales_Status__c"]);
                component.set("v.iscommunityUser",resultStr.isCommunityUsr);
                   // alert(resultStr.isValidIM_Products);
                if(resultStr.status =='false')
                {
                    console.log('hiiiiiiiiii');    
                    component.set("v.readyForSendToCredit", true);
                }  
                else
                    component.set("v.readyForSendToCredit", false);
                this.showhidespinner(component,event,false);
            }
            else{
                console.log('inside checkall pk3');
                this.showhidespinner(component,event,false);
            }
        });
    },
    /*20939 RCU s*/
    checkIMHelper: function(component, event) {
        var loanId = component.get('v.oppId');
        this.showhidespinner(component,event,true);
        this.executeApex(component, "callIM",{"loanId":loanId},function(error, result){
            if(!error && result){
                var resultStr = JSON.parse(result);
                if(!$A.util.isEmpty(resultStr.applicantPrimary) && !$A.util.isEmpty(resultStr.applicantPrimary.Score_card__c)){
                    component.set("v.showApproveRej",true); 
                    component.set("v.showIM",false);
                    this.displayToastMessage(component,event,'Success','Invisible Monitoring called successfully','success');	
                }
                else{
                    this.displayToastMessage(component,event,'Error','Failure in calling Invisible Monitoring','error');
                }
                
            }
            else{
                this.displayToastMessage(component,event,'Error','Failure in calling Invisible Monitoring','error');
            }
            this.showhidespinner(component,event,false);
        });
        
    },
    /*20939 RCU e*/
    submitForPricing: function(component, event) {
        
        this.showhidespinner(component,event,true);
        this.executeApex(component, "submitForPricingApp", {
            'loanid': component.get("v.oppId"),
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj"))
        }, function (error, result) {
            var data = JSON.parse(result);
            if(!$A.util.isEmpty(data))
            {
                
                this.showhidespinner(component,event,false);
                if(data.status == 'Success')
                {
                       this.updateAcmEvent(component,event,'Post Approval Sales');
                      // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'UW-Submit to Pricing',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
                    component.set("v.isdiablebutton",true);
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                }
                else
                    this.displayToastMessage(component,event,'Error',data.status,'error');	
            }
            else{
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    }, 
    
    applicantRecord: function(component, event) {
        //call apex class method
        
        var loanAppId = component.get('v.oppId'); 
        var primaryAppLicant = component.get('v.primaryApp'); 
        var isSuccessMsg = true;
        var picklistId = component.find("wrapId");
        if(picklistId.get("v.validity").valid)
            console.log(' picklistId'+isSuccessMsg);
        else{
            picklistId.showHelpMessageIfInvalid();
            isSuccessMsg = false;
        }
        console.log('loanAppId'+loanAppId);
        var action = component.get('c.getFetchApplicant');
        action.setParams({
            loanApplicationId : loanAppId, 
            priApp : JSON.stringify(primaryAppLicant),
            StrAppr1 : component.get('v.selectedValue')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS"){
                      // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'Submit To Credit',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
                this.showhidespinner(component,event,false);
                if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                    if(component.get('v.iscommunityUser'))
                        window.location.href = '/Partner/006/o';
                    else
                        window.location.href = '/006/o';
                }else if(component.get('v.nameTheme') == 'Theme4d')
                    window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                    else if(component.get('v.nameTheme') == 'Theme4t')
                        this.onLoadRecordCheckForSF1(component, event);
            }
            else
                this.showhidespinner(component,event,false);
        });
        
        if(isSuccessMsg == true)
        {
            console.log('in success'+component.get('v.iscommunityUser'));
            this.showhidespinner(component,event,true);
            $A.enqueueAction(action);
            
            
        }
        else{
            this.displayToastMessage(component,event,'Error','Please select credit officer','error'); 
            
        }
        
    },
    callPANBre :function(component , event)
    {
        
        this.showhidespinner(component,event,true);
        this.executeApex(component, "callPANBreOnDocument", {
            'oppObj': JSON.stringify(component.get("v.Oppobj")),
            'accObj': JSON.stringify(component.get("v.Accobj")),
            'conObj': JSON.stringify(component.get("v.Conobj")),
            'appObj': JSON.stringify(component.get("v.primaryApp")),
            'loanId': component.get("v.oppId")
        }, function (error, result) {
            console.log('result test: ' + result);
            if (!error && result) {
                console.log('result -->'+result);
                
                var objlst = JSON.parse(result);
                console.log('objlistr -->'+JSON.stringify(objlst));
                
                if(!$A.util.isEmpty(objlst))
                {
                    if(!$A.util.isEmpty(objlst.status))
                    {
                        if(objlst.status == 'PANBRE Done' || objlst.status == 'Success')
                        {
                            this.showhidespinner(component,event,false);
                            //this.displayToastMessage(component,event,'Success','PAN Check has already been done','success'); 
                        }
                        else{
                            this.showhidespinner(component,event,false);
                            this.displayToastMessage(component,event,'Error',objlst.status,'error'); 
                            if(!$A.util.isEmpty(objlst.applicantPrimary))
                            {
                                component.set("v.appObj" , objlst.applicantPrimary);
                            }
                        }
                    }
                    
                    
                }
                
                
                
            }
            else{
                this.showhidespinner(component,event,false);
            }
        });
        
        
    },
    salesSumbit : function(component, event){
        var loanId = component.get('v.oppId');
        // var self = this;
        // this.showParentToastHelper('parentInfoToastCredit','parentInfoMsgCredit','Please wait ...',true);
        this.executeApex(component, "sendToSalesOpp",{"loanId":loanId},function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result) && result =='Success' ){
                      // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'UW – Recommend/Send Back',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                    
                    this.displayToastMessage(component,event,'Success','Saved','message');
                    
                }else{
                    
                    this.displayToastMessage(component,event,'Error','Sales Officer is not available','message');
                }
            }
            else
            {
                
            }
            
        });
        
    },
    loadData: function(component, event) {
        
        var loanAppId = component.get('v.oppId'); 
        console.log('loanAppId'+loanAppId); 
        var action = component.get('c.getCreditOfficerLimit');
        action.setParams({
            loanApplicationId : loanAppId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.wrapperList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
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
    
    showhidespinner:function(component, event, showhide){
        console.log('in show hide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
        console.log('after event fire');
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
    //underwriter screen changes start
    recommend: function(component,event)
    {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "submitForRecommend", {
            'loanid': component.get("v.oppId"),
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj")),
            'SelCreditUser' : component.get('v.selectedValue1')
        }, function (error, result) {
            var data = result;
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'success')
                {
                       this.updateAcmEvent(component,event,'Recommend');
                       // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'UW – Recommend/Send Back',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
                    //component.set("v.isdiablebutton",true); 
                    this.displayToastMessage(component,event,'Success','Loan application is updated successfully','success');
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                    
                }
                else
                    this.displayToastMessage(component,event,'Error',result,'error');	
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to recommend loan application','error');
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    },
    approvedonehelper: function(component,event)
    {
        this.showhidespinner(component,event,true);
        
        this.executeApex(component, "approveloan", {
            'loanid': component.get("v.oppId"),
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj"))
        }, function (error, result) {
            var data = JSON.parse(result); //24316 //US #899	
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(data.msgStatus == 'success')//US #899	
                {
                    component.set("v.Oppobj",data.opp);
                    this.updateAcmEvent(component,event,'Approved');
                    // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'UW – Approve/Reject',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
                    component.set("v.isdiablebutton",true); 
                    this.displayToastMessage(component,event,'Success','Loan application is Approved successfully','success');
                	if(component.get("v.Oppobj.Product__c") == 'RSL')
                    {
                        this.savepdObj(component,event);
                    }
                }
                else
                    this.displayToastMessage(component,event,'Error',data.msgStatus,'error');//US #899	
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to approve loan application','error');
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    },
    holddoneHelper: function(component,event)
    {
        this.showhidespinner(component,event,true);
        var multislect = component.find("mymultiselect");
        var mySelectedvalues = multislect.bindData();
        component.set("v.mySelectedvalues",mySelectedvalues);
        if(!$A.util.isEmpty(mySelectedvalues)){
            var Oppobj =  component.get("v.Oppobj");
            Oppobj.Hold_Reason__c = mySelectedvalues;
            console.log('hold reaon selected'+mySelectedvalues);
            component.set("v.Oppobj",Oppobj);
        }
        this.executeApex(component, "holdloan", {
            'loanid': component.get("v.oppId"),
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj"))
        }, function (error, result) {
            var data = result;
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'success')
                {
                    component.set("v.isdiablebutton",true); 
                    this.updateAcmEvent(component,event,'Hold');
                    this.displayToastMessage(component,event,'Success','Loan application is Hold successfully','success');
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                }
                else
                    this.displayToastMessage(component,event,'Error',result,'error');	
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to hold loan application','error');
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    },
    submitunHoldhelper: function(component,event)
    {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "unholdloan", {
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj"))
        }, function (error, result) {
            var data = result;
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'success')
                {
                     this.updateAcmEvent(component,event,'UnHold');
                    component.set("v.isdiablebutton",true); 
                    this.displayToastMessage(component,event,'Success','Loan application is Un-Hold successfully','success');
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                }
                else
                    this.displayToastMessage(component,event,'Error',result,'error');	
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to Un-hold loan application','error');
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    },
    sendbacktosales: function(component,event)
    {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "sendBackToSales", {
            'loanid': component.get("v.oppId"),
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj"))
        }, function (error, result) {
            var data = result;
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'Success')
                {
                     this.updateAcmEvent(component,event,'Send Back To Sales');
                      // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'UW – Recommend/Send Back',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
					this.updateAccObj(component,event);//user story 985
                    // component.set("v.isdiablebutton",true); 
                    this.displayToastMessage(component,event,'Success','Loan application is updated successfully','success');
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                }
                else
                    this.displayToastMessage(component,event,'Error',result,'error');	
            }
            else{
                this.displayToastMessage(component,event,'Error','Internal Server Error','error');
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    },
	//user story 985 s
    updateAccObj : function(component,event){
        var acc = component.get("v.Accobj");
        acc.Send_Back_Reason__c = component.get("v.SelvalSendback");
       this.executeApex(component, "UpdateSendBack", {
            'jsonaccobj':JSON.stringify(acc)
       }, function (error, result) {
           
       });
        
    },
    //user story 985 e
    updateCamObjHelper : function(component,event) {
        console.log('updateCamObjHelper');
        var cam = component.get("v.camObj");
        cam.Approved_CAM__c = true;
        component.set("v.camObj",cam);
        this.showhidespinner(component,event,true);
        this.executeApex(component, "updateCam", {"camObj": JSON.stringify(component.get("v.camObj"))}, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result)){
                    component.set("v.camObj",result);
                    this.showhidespinner(component,event,false);
                }else{
                    this.showhidespinner(component,event,false);
                }
            }
            else
            {
                this.showhidespinner(component,event,false); 
            }
            
        });
    },
    rejectdonehelper : function(component,event)
    {
        this.showhidespinner(component,event,true);
        var loan = component.get("v.Oppobj");
        loan.Reject_Reason__c = component.get("v.mySelectedvalues");
        component.set("v.Oppobj",loan);
        this.executeApex(component, "rejectloan", {
            'loanid': component.get("v.oppId"),
            'jsonoppobj':JSON.stringify(component.get("v.Oppobj"))
        }, function (error, result) {
            var data = result;
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'success')
                {
                    this.updateAcmEvent(component,event,'Rejected');
                    // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'UW – Approve/Reject',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e
                    component.set("v.isdiablebutton",true);
                    this.displayToastMessage(component,event,'Success','Loan application is Rejected successfully','success');
                    if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                        if(component.get('v.iscommunityUser'))
                            window.location.href = '/Partner/006/o';
                        else
                            window.location.href = '/006/o';
                    }else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                }
                else
                    this.displayToastMessage(component,event,'Error',result,'error');	
            }
            else{
                this.showhidespinner(component,event,false);
                console.log(data);
            }
        });
    },
    onLoadRecordCheckForSF1 : function(component, event) {
        var action = component.get('c.getLoanApplicationListViews');
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "Opportunity"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    //underwriter screen changes end
    /*Retrigger 20939 s*/
    retriggerBRE : function(component,event)
    {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "retriggerBRECalls", {
            'loanid': component.get("v.oppId")
            
        }, function (error, result) {
            // this.checkAllSolPolicies(component,event);
            var data = result;
            console.log('data>>>'+data);
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'success')
                {
                    console.log('flag is'+component.get("v.reTriggerIM"));
                    /*20939 IM s*/
                    //alert('t'+component.get("v.isValidIM_Products"));
                    if(!$A.util.isEmpty(component.get("v.Oppobj").Product__c) && component.get("v.Oppobj").Product__c != 'RSL' &&(component.get("v.reTriggerIM") || $A.util.isEmpty(component.get("v.primaryApp.Score_card__c")))&& component.get("v.isValidIM_Products")) //22018////Story id #899 Product condition added by swapnil 
                        component.set("v.showIM",true); 
                    else
                        component.set("v.showApproveRej",true); 
                    /*20939 IM e*/
                    this.displayToastMessage(component,event,'Success','BRE Retriggered Successfully.','success');
                    
                }
                else
                    this.displayToastMessage(component,event,'Error','Error Occoured!','error');	
            }
            else{
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Error Occoured!','error');
                console.log(data);
            }
        });
    },
    beforeApprove : function(component, event, helper){
        console.log('inside beforeapprove');
        this.showhidespinner(component,event,true);
        var verSelectList = ["Status__c","Sales_Status__c"];
        var checkSelectList = ["Status__c","Sales_Status__c"];
        var selectListNameMap = {};
        selectListNameMap["Verification__c"] = verSelectList;
        selectListNameMap["Checklist__c"] = checkSelectList;
        this.executeApex(component, "checkAllSolPoliciesMethod", {
            'oppId': component.get("v.Oppobj").Id,'objectFieldJSON':JSON.stringify(selectListNameMap)
        }, function (error, result) {
            if (!error && result) {
                var resultStr = JSON.parse(result);
                component.set("v.NoOfSolPolicyWithBreFlagTrue",resultStr.NoOfSolPolicyWithBreFlagTrue);
                if(component.get("v.NoOfSolPolicyWithBreFlagTrue") >0)
                {
                    this.displayToastMessage(component,event,'Message ','Please Retrigger BRE before Approve, Please wait if already done','message');	 
                    this.showhidespinner(component,event,false);
                    
                }
                else{
                    this.updateCamObjHelper(component,event); 
                }
                
                
            }
            else
                this.showhidespinner(component,event,false);
        });       
    },        
    beforeReject : function(component, event, helper){
        this.showhidespinner(component,event,true);
        var verSelectList = ["Status__c","Sales_Status__c"];
        var checkSelectList = ["Status__c","Sales_Status__c"];
        var selectListNameMap = {};
        selectListNameMap["Verification__c"] = verSelectList;
        selectListNameMap["Checklist__c"] = checkSelectList;
        this.executeApex(component, "checkAllSolPoliciesMethod", {
            'oppId': component.get("v.Oppobj").Id,'objectFieldJSON':JSON.stringify(selectListNameMap)
        }, function (error, result) {
            if (!error && result) {
                var resultStr = JSON.parse(result);
                component.set("v.NoOfSolPolicyWithBreFlagTrue",resultStr.NoOfSolPolicyWithBreFlagTrue);
                this.showhidespinner(component,event,false);
                if(component.get("v.NoOfSolPolicyWithBreFlagTrue") >0)
                {
                    this.displayToastMessage(component,event,'Message ','Please Retrigger BRE before Reject, Please wait if already done','message');	 
                    
                }
                else{
                    console.log('inside showapprove');
                    component.set("v.isTextBoxEnabledreject",true);
                    component.set("v.isTextBoxEnabledRecommend",false);
                    component.set("v.isSendBackEnabled",false);
                    component.set("v.isTextBoxEnabled",false);
                    component.find("approvebutton").set("v.disabled",true);
                    var reasonval;
                    var loan = component.get("v.Oppobj");
                    var reasonval = loan.Reject_Reason__c;
                    var multislect = component.find("mymultiselect");
                    multislect.setRejectReason(reasonval);
                }
                
                
            }
        });       
    },         
    /*Retrigger 20939 e*/
    
    // Bug Id : 21804 start
    creditAutoAllocation :function(component){
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'autoQueueAllocation', {
            "opp": component.get('v.oppId')
        },
                         function(error, result) {
                             
                             console.log('error -->', error);
                             var parsedVal = JSON.parse(result);
                             console.log('if -->' + parsedVal);
                             var flag=confirm("Are you sure you want to send to Credit?");
                             var autoallocationCheck=false; // Bug Id : 25285 - Concurrency Issue -unlock p2 fix
                             if ((!error && parsedVal != null && parsedVal != undefined) && flag) {
                                 autoallocationCheck=true;// Bug Id : 25285 - Concurrency Issue -unlock p2 fix
                                 this.SubmitForAutoAllocation(component,parsedVal);
                             }
                             else
                             {
                                 if (flag == false && parsedVal != null && parsedVal != undefined) {  // Bug Id : 25285 - Concurrency Issue start
                                     console.log('clicked cancel to auto allocation --> ');
                                     this.executeApex(component, 'unlockRecord', {"colId": parsedVal},
                                     function(error, result) {});
                                 }  // Bug Id : 25285 - Concurrency Issue end
                                 this.showhidespinner(component,event,false);
                                 if(flag){
                                     console.log('result+aman+'+result);
                                     component.set('v.showCredit',true);
                                     console.log('Hi++'+component.get('v.showCredit'));
                                     component.find("sendToCreditButton").set("v.disabled",true);
                                     //helper.showParentToastHelper('parentSuccessToastCredit','parentsuccessMsgCredit','Success ',false);
                                     this.displayToastMessage(component,event,'Success','Please select credit officer','success');
                                 }
                             }
                             if(autoallocationCheck==true && (error || result === 'false')){// Bug Id : 25285 - Concurrency Issue start -unlock p2 fix
                                this.showToast(component, "Error!", error.join(", "), "error"); 
                                this.executeApex(component, 'unlockRecord', {"colId": component.get("v.autoAllocateduser")},
                                function(error, result) {});
                            }// Bug Id : 25285 - Concurrency Issue end -unlock p2 fix
                         }                        
                        )}, 
    SubmitForAutoAllocation :function(component, approverId){
        this.showhidespinner(component,event,true);
        var loanAppId = component.get('v.oppId'); 
        var primaryAppLicant = component.get('v.primaryApp'); 
        var isSuccessMsg = true;
        //var picklistId = component.find("wrapId");
        // if(picklistId.get("v.validity").valid)
        //     console.log(' picklistId'+isSuccessMsg);
        // else{
        //     picklistId.showHelpMessageIfInvalid();
        //     isSuccessMsg = false;
        //  }
        console.log('loanAppId'+loanAppId);
        
        var action = component.get('c.submitForAutoApproval');
        action.setParams({
            loanApplicationId : loanAppId, 
            priApp : JSON.stringify(primaryAppLicant),
            StrAppr1 : approverId,
            isAutoCredit: true
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS"){
                           // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'Submit To Credit',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e

                this.showhidespinner(component,event,false);
                if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                    if(component.get('v.iscommunityUser'))
                        window.location.href = '/Partner/006/o';
                    else
                        window.location.href = '/006/o';
                }else if(component.get('v.nameTheme') == 'Theme4d')
                    window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                    else if(component.get('v.nameTheme') == 'Theme4t')
                        this.onLoadRecordCheckForSF1(component, event);
            }
            else
                this.showhidespinner(component,event,false);
        });
        
        if(isSuccessMsg == true)
        {
            console.log('in success'+component.get('v.iscommunityUser'));
            this.showhidespinner(component,event,true);
            $A.enqueueAction(action);
            
            
        }
        else{
            this.displayToastMessage(component,event,'Error','Please select credit officer','error'); 
            
        }
    },
    // Bug Id : 21804 end
	/*DMS 24317 s*/
    getDMSDocuments : function(component, event, helper){
        var product=component.get("v.Oppobj.Product__c");
        console.log('DMS Prod '+product);
         this.executeApex(component, "getDMSDocuments", {
             "product":product
        }, function (error, result) {
            if (!error && result) {
               component.set("v.DMSDocmap",result);
               console.log('DMS result '+JSON.stringify(result));
                var cmp = component.find("DocumentsList");
                cmp.getDMSDocs(component.get("v.DMSDocmap"));
            }
            else{
                console.log('DMS invalid file name');
            }
        }); 
        
    },
    /*Doc Uploader s*/
    handleStdUploadHelper: function (component, event) {
        var uploadedFiles = event.getParam("files");
        var docIds = [];
        for(var i=0;i< uploadedFiles.length;i++){
            docIds.push(uploadedFiles[i].documentId);
        }
        console.log('firing');
        this.executeApex(component, "stampFileName", {
            "fileName":component.get("v.DocSelectedName"),
            "docIds":docIds,
            "AppiId":component.get("v.primaryApp").Id
        }, function (error, result) {
            if (!error && result) {
                if(result == 'Success'){
                          // user story 978 s
                        // alert('inside pricing');
                    if(component.get("v.isPricingcmp")){
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        //alert('inside uploadChunk::'+updateidentifier+component.get("v.oppId"));
                        updateidentifier.setParams({
                            "eventName": 'Pricing Document',
                            "oppId":component.get("v.oppId")
                        });
                        console.log('calling1>>> ');
                        
                        updateidentifier.fire();
                          // alert('inside uploadChunk::2'+updateidentifier);
                        }
                        // user story 978 e
                    
                    this.displayToastMessage(component,event,'Success','Files uploaded successfully','success');	
                    component.set("v.standardUploader",true);
                    console.log('firing event');
                    var a = component.get('c.populateList');
                    console.log('firing event'+a);
                    $A.enqueueAction(a);
                    var documentSaveEvent = $A.get("e.c:DocumentUploadEventStd");
                    documentSaveEvent.fire();

                    
                }
                
            }
            else{
                console.log('Error');
            }
        });
    },
    /*Doc Uploader e*/
      updateAcmEvent: function(component,event,actionname)
    {
        this.executeApex(component, "updateACMEvent", {
            'actionName': actionname,
            'oppId': component.get("v.oppId"),
            'appId': component.get("v.primaryApp").Id,
        }, function (error, result) {
            var data = result;
            if (!error && data) {
                
            }
        });
    },
	     /*11806 s*/
    getRules : function(component,event,helper){
        var DataMap = new Map();
        var exLoan = [];
        var obList = component.get("v.obligLst");
        if(!$A.util.isEmpty(obList)){
            obList.forEach((obObj, index) => {
  				exLoan.push(obObj.exObj);
			});
           
        }
        console.log('exLoan is '+exLoan);
        console.log('oblig comp '+component.get("v.obligLst"));
         var oppstr = JSON.stringify(component.get("v.Oppobj"));
        console.log('opp Obj before rule '+JSON.stringify(oppstr));
         var camstr = JSON.stringify(component.get("v.camObj"));
         var appstr = JSON.stringify(component.get("v.primaryApp"));
         var bankstr = JSON.stringify(component.get("v.bankObj"));
        var constr = JSON.stringify(component.get("v.Conobj"));
        console.log('contacts are '+constr);
        var exloanstr = JSON.stringify(exLoan);
        var pdStr = JSON.stringify(component.get("v.pdObj"));
        //DataMap.set("",component.get("v.pdObj"))
        console.log('oblig is '+ exloanstr);
    	this.executeApex(component, "rulesForRural", {
             'oppObjStr' : oppstr,
             'camObjStr' : camstr,
             'appObjStr' : appstr,
             'bankObjStr' : bankstr,
             'conObjStr' : constr,
             'OblListStr' : exloanstr,
             'pdObjStr' : pdStr
        }, function (error, result) {
            debugger;
            console.log('result for ruleMap '+result);
            if (!error && result) {
               var data = JSON.parse(result);
               var ruleMap = data.ruleMap;
               var rules = [];// component.get("v.judgementFields");
                //rules.push('');
               var newRule = [];
                var found = false;
                
                var rulespd = component.get("v.rules");
 				console.log('string rulesPD '+JSON.stringify(rulespd));
                data.keyList.forEach(function(arr){
                    console.log('inside list');
                     found = false;
                     for(var i = 1; i<= 50 ; i++){
                        if(!$A.util.isEmpty(rulespd) && !$A.util.isEmpty(rulespd['Question'+i+'__c'])){
                            var fieldVal =  rulespd['Question'+i+'__c'].split(';');
                            console.log('new val '+fieldVal[1] + ' : ' +arr);
                            if(arr == fieldVal[1]){
                                console.log('match found '+fieldVal.length)
                                if(fieldVal.length == 4)
                                	rules.push({value:fieldVal[0], key:arr, action:fieldVal[2], remarks:fieldVal[3]});
                                else
                                    rules.push({value:fieldVal[0], key:arr, action:fieldVal[2], remarks:""});
                                found = true;
                                break;
                            }
                        }
                    }
                    if(!found)
                        newRule.push(arr);
                });
                newRule.forEach(function(key){
                    rules.push({value:ruleMap[key], key:key, action:"Override", remarks:""});
                });
                console.log("rules "+JSON.stringify(rules));
                component.set("v.judgementFields",rules);
    			//component.set("v.KeyList",data.keyList);
            }
            else{
                console.log('An internal error occured');
            }
        }); 
    },
    checkrules :function(component, event){ 
    	var rulesList = component.get("v.judgementFields");
        console.log('judgement field val is '+ JSON.stringify(rulesList));
        console.log('judgement field Size is '+ rulesList.length);
        var flag = true;
        if(!$A.util.isEmpty(rulesList)){
            console.log('inside for loop');
            for(var i=0;i<rulesList.length;i++){
                console.log('current Rule '+rulesList[i].action+' : '+rulesList[i].remarks);
                if(rulesList[i].action == "Override" && $A.util.isEmpty(rulesList[i].remarks)){
                    console.log('inside return false');
                    flag = false;
                    break;
                }
            }
        }else
            return true;
    	
        if(!flag){
            return false;
        }
        var pdRules = component.get("v.rules");
        console.log('pd rules are '+pdRules);
        for(var i = 1; i<= 50 ; i++){
            var fieldName = 'Question'+i+'__c';
            pdRules[fieldName] = '';
            if(i<=rulesList.length){
                
        		pdRules[fieldName] = rulesList[i-1].value +';'+rulesList[i-1].key+';'+rulesList[i-1].action +';'+ rulesList[i-1].remarks;
            	console.log('rule val is '+ pdRules[fieldName]);
            }
        }
        pdRules.Loan_Application__c = component.get("v.oppId");
        pdRules.Account_Holder_Name__c = 'Rural Rules';
        component.set("v.rules",pdRules);
        console.log('rules saved is '+JSON.stringify(pdRules));
        return true;
    },
    
    savepdObj : function(component,event){
        var pdObj = component.get("v.rules");
        console.log('rules saved before'+JSON.stringify(pdObj));
        var pdObjStr = JSON.stringify(pdObj);
        this.executeApex(component, "saveRules",{
             "pdObj":JSON.stringify(pdObj),
             "oppId":component.get("v.oppId")
        }, function (error, result) {
            if(!error && result){
                if(result == 'Success')
                    console.log('PD record updated successfully');
                else
                    console.log('Error while updating record');
            }else{
                console.log('An error occured while saving rules');
            }
        });
    }
    /*11806 e*/
})