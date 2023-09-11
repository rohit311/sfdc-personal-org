({
    onApplicantListChange: function(component, event) {        
        var applicantList = component.get("v.applicantList");
        var bankAccount = component.get('v.bankAccount.Applicant__r.ContactName__c');
        for (var i = 0; i < applicantList.length; i++) {
            if (applicantList[i].ContactName__c == bankAccount) {
                component.set("v.bankAccount.Applicant__c",applicantList[i].Applicant_Type__c);
                console.log('applicant -->'+applicantList[i]);
                console.log('bankaccount Applicant -->'+component.get("v.bankAccount.Applicant__c"));
                component.set("v.bankAccount.Applicant__r.Applicant_Type__c",applicantList[i].Applicant_Type__c);
                component.set("v.bankAccount.Applicant__c",applicantList[i].Id);
                
            }
        }
    },
    toggleAssVersion : function(component, event) {
        console.log(event.target);
        //var whichOne = event.getSource().getLocalId();
        //console.log(whichOne);
        //var Val = event.target.value;
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        console.log('in cls-->'+cls);
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
            
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    uploadBankSt:function(component, event){
        var bankAcc = component.get("v.bankAccount");
        var recordid = bankAcc.Id;
        //added by prashant for bug id start
        var fromDate ='';
        if(!$A.util.isEmpty(component.get("v.bankAccount.Perfios_Start_date__c")))
            fromDate =component.get("v.bankAccount.Perfios_Start_date__c"); 
        var endDate ='';
        if(!$A.util.isEmpty(component.get("v.bankAccount.Perfios_end_date__c")))
            endDate =component.get("v.bankAccount.Perfios_end_date__c");
        //added by prashant for bug id start
        var appName = component.find("applicantNameId");
        var isValid = true;
        if($A.util.isEmpty(appName) || !appName.get("v.validity").valid){
            appName.showHelpMessageIfInvalid();
            isValid = false;
        } 
        var bankName = component.find("bankNameList");
        
        if($A.util.isEmpty(bankName) || !bankName.get("v.validity").valid){
            bankName.showHelpMessageIfInvalid();
            isValid = false;
        } 
        
        var bankNo = component.find("bankAccNo");
        var isvaliddate= this.dateUpdate(component,event);
        if($A.util.isEmpty(bankNo) || !bankNo.get("v.validity").valid){
            bankNo.showHelpMessageIfInvalid();
            isValid = false;
        } 
        console.log('pk'+isvaliddate);
        if(!isValid){
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please enter all required data','error');
        }
        else if(!isvaliddate)
        {
            isValid = isvaliddate && isValid;
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please enter valid date','error');
        }
            else if($A.util.isEmpty(recordid)){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Please initiate perfios','error');
                }
        else{
            
            var bankList = [];
            bankList.push(bankAcc);
            
            this.executeApex(component, "upsertPerfiosBankAccount", {"loanId":component.get("v.loan.Id"), "JSONBankAccountLst" :JSON.stringify(bankList)}, function(error, result){
                if(!error && result){
                    var data = JSON.parse(result);
                    if (!$A.util.isEmpty(data) &&  !$A.util.isEmpty(data.bankList)) {
                        window.open('http://partial-bflloans.cs72.force.com/perfios?id='+recordid+'&fromDate='+fromDate+'&toDate='+endDate+'&destination=statement','_blank');        
                    }
                    this.showhidespinner(component,event,false);
                }
                else{
                    this.showhidespinner(component,event,false);
                }
            });
        }                 
    },
    viewBankDetails:function(component, event){
        var bankAcc = component.get("v.bankAccount");
        var recordid = bankAcc.Id;
        var theme = component.get("v.theme");
        // alert(bankAccount);
        if(theme =='Theme3' || theme =='Theme2'){
            if(component.get('v.iscommunityUser'))
                window.open('/Partner/' + recordid);
            else
                window.open('/' + recordid);
        }else if(theme == 'Theme4d')
            window.open('/lightning/r/Opportunity/' + recordid + '/view');
            else if(theme == 'Theme4t')
                this.navigateToPerfiosSF1(component, event, recordid);
        window.open('http://bflhts.my.salesforce.com/'+recordid);     
        this.showhidespinner(component,event,false);
    },
    navigateToPerfiosSF1 : function(component, event, bankAccountId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": bankAccountId,
            "slideDevName": "related"
        });
        navEvt.fire();
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
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state '+state );
            if(state === "SUCCESS"){
                //console.log('response.getReturnValue()'+response.getReturnValue());
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    dateUpdate : function(component, event) {
        console.log('inside dateupdate');
        var isvaliddate = true;
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        
        if(component.get("v.bankAccount.Perfios_Start_date__c") != '' && component.get("v.bankAccount.Perfios_Start_date__c") > todayFormattedDate){
            component.set("v.dateValidationError1" , true);
            isvaliddate = false;
            console.log('inside dateupdate'+isvaliddate);
            component.set("v.datevalidationmsg1","Start date must be in present or in Past");
        }else{
            component.set("v.dateValidationError1" , false);
            component.set("v.datevalidationmsg1","");
        }
        if(component.get("v.bankAccount.Perfios_end_date__c") != '' && component.get("v.bankAccount.Perfios_end_date__c") > todayFormattedDate){
            component.set("v.dateValidationError2" , true);
            isvaliddate = false;
            component.set("v.datevalidationmsg2","End date must be in present or in Past");
        }else{
            component.set("v.dateValidationError2" , false);
            component.set("v.datevalidationmsg2", "");
        }
        if(isvaliddate && component.get("v.bankAccount.Perfios_Start_date__c") != '' && component.get("v.bankAccount.Perfios_end_date__c") != '' && component.get("v.bankAccount.Perfios_Start_date__c") > component.get("v.bankAccount.Perfios_end_date__c")){
            component.set("v.dateValidationError1" , true);
            component.set("v.dateValidationError2" , true);
            isvaliddate = false;
            console.log('inside dateupdate'+isvaliddate);
            component.set("v.datevalidationmsg1","Start date must be less than End date");
            component.set("v.datevalidationmsg2","End date must be greater than Start date");
        }
         if(isvaliddate){
            component.set("v.dateValidationError1" , false);
            component.set("v.dateValidationError2" , false);
            component.set("v.datevalidationmsg1","");
            component.set("v.datevalidationmsg2","");
        }
        if(isvaliddate && !$A.util.isEmpty(component.get("v.bankAccount.Perfios_Start_date__c")) && !$A.util.isEmpty(component.get("v.bankAccount.Perfios_end_date__c"))){
                var noofmonth= $A.get("$Label.c.NoOfMonthsPerfios");
                console.log('pk'+noofmonth);
                var end_date = new Date(component.get("v.bankAccount.Perfios_end_date__c"));
                var start_date = new Date(component.get("v.bankAccount.Perfios_Start_date__c"));
                var diff =(end_date.getTime() - start_date.getTime()) / 1000;
                diff /= (60 * 60 * 24 * 7 * 4);
                var diffmonth = Math.abs(Math.round(diff));
                if(diffmonth >  noofmonth)
                {
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Months difference must be equal to '+noofmonth+'.','error');
                    isValid = false;
                }
            }
       
        return isvaliddate;
    },
})