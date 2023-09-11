({
    doInit : function(component, event, helper){
        var applicantList = component.get('v.applicantList');
        console.log('in table view doint');
        console.log(component.get('v.bankAccount.Id'));
        var applicantNameList = [];
        if(applicantList != null){
        for (var i = 0; i < applicantList.length; i++) {
            applicantNameList.push(applicantList[i].ContactName__c);    
        }
        }
        component.set("v.applicantNameList",applicantNameList);
    },
    deleteRecord : function(component, event, helper){
        var bankList = component.get("v.bankAccountList");
        //console.log('posListTU'+posListTU);
        if(bankList.length > 1)
        	bankList.pop();     
        component.set("v.bankAccountList",bankList);
    },
    validatebank : function(component, event, helper){
    	var isValid = true;
        var appName = component.find("applicantNameId");
        if ($A.util.isArray(appName)) {
            appName.forEach(cmp => {
                console.log('cmp'+cmp);
                if($A.util.isEmpty(cmp) || !cmp.get("v.validity").valid){
                    cmp.showHelpMessageIfInvalid();
                    isValid = false;
                } 
            })
        } else {
            if($A.util.isEmpty(appName) || !appName.get("v.validity").valid){
                appName.showHelpMessageIfInvalid();
                isValid = false;
            } 
        }
        console.log('isInvalid'+appName);
        var bankName = component.find("bankNameList");
        if ($A.util.isArray(bankName)) {
            bankName.forEach(cmp => {
                console.log('cmp'+cmp);
                if($A.util.isEmpty(cmp) || !cmp.get("v.validity").valid){
                    cmp.showHelpMessageIfInvalid();
                    isValid = false;
                } 
            })
        } else {
            if($A.util.isEmpty(bankName) || !bankName.get("v.validity").valid){
                bankName.showHelpMessageIfInvalid();
                isValid = false;
            } 
        }
        console.log('isInvalid1'+bankName);
        var bankNo = component.find("bankAccNo");
        if ($A.util.isArray(bankNo)) {
            bankNo.forEach(cmp => {
                console.log('cmp'+cmp);
                if($A.util.isEmpty(cmp) || !cmp.get("v.validity").valid){
                    cmp.showHelpMessageIfInvalid();
                    isValid = false;
                } 
            })
        } else {
            console.log('bankNo'+bankNo);
            if($A.util.isEmpty(bankNo) || !bankNo.get("v.validity").valid){
                bankNo.showHelpMessageIfInvalid();
                isValid = false;
            } 
        }
                console.log('bankNo'+bankNo);
       
        return isValid;
    },
    updateNameList : function(component, event, helper){
        var applicantList = event.getParam("appList");
        console.log('in table view doint');
        var applicantNameList = [];
        if(applicantList != null){
            component.set("v.isFinancialApplicant",false);
            for (var i = 0; i < applicantList.length; i++) {
                applicantNameList.push(applicantList[i].ContactName__c);  
                console.log('applicantList[i].Applicant_Type__c'+applicantList[i].Applicant_Type__c);
                if(applicantList[i] != null && applicantList[i].Applicant_Type__c == 'Financial Co-Applicant')
                {
                    component.set("v.isFinancialApplicant",true);
                }
            }
        }
        component.set("v.applicantNameList",applicantNameList);
        component.set("v.applicantList",applicantList);
        
    },
    uploadStatement : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        helper.uploadBankSt(component,event);
        
    	
    },
    viewDetails : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        helper.viewBankDetails(component,event);
        
    	
    },
    onApplicantListChange : function(component, event, helper){
        console.log('onApplicantListChange');
        helper.onApplicantListChange(component, event);     
    },
    toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
    dateUpdate : function(component, event, helper) {
        return helper.dateUpdate(component,event);
    },
                
})