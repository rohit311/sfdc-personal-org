({   
    doinit : function(component, event, helper) {
      // alert(component.get("v.isDetailsAvailable")+'  '+component.get("v.availeLater"));
        console.log('@@swapnil Opp Id is '+component.get("v.oppId"));
        if(component.get("v.oppId") == null){
            component.set("v.isUWCheck",true);
        }
        helper.showhidespinner(component, event,true);
        helper.getoppDetails(component, event);
        helper.getFeesList(component,event);
        //helper.callFeesAndCharges(component,event);
        
        console.log('Applicant whole obj '+JSON.stringify(component.get("v.applicantObj")));
        
        
    },
    handlEvent :  function(component, event, helper) {
		 component.set("v.isUWCheck",true);
        var message = event.getParam("Id");
     
        component.set("v.oppId",message);
       

        helper.showhidespinner(component, event,true);
        helper.getoppDetails(component, event);
        helper.getFeesList(component,event);
        //helper.callFeesAndCharges(component,event);
      
        //window.location.reload();
    },
   
    
     pinChangeHelper : function(component) {
        component.set("v.areaSearchKeyword",'');
        self.areaCheck = false;
    },
     areaKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.ValidAreaLocality",false);
        helper.startSearch(component, 'area');
    },
    selectArea: function (component, event, helper) {
                 component.set("v.ValidAreaLocality",true);
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.areaList")[index];
        console.log(selectedArea);
        var keyword = selectedArea.Name;
        
        console.log('keyword>>' + selectedArea);
        component.set("v.selectedArea", selectedArea);
        component.set("v.areaSearchKeyword", keyword);
         var account = component.get("v.account");
        account.Area_Locality__c=selectedArea.Id;
        console.log('insdide selectpk'+component.get("v.account.Area_Locality__c"));
        account.Current_Residence_Address1__c = selectedArea.Name;
         component.set("v.account",account);
		//component.set("v.account.Area_Locality__r.Name", selectedArea.Name);
        //console.log('Area loc master'+component.get("v.account").Area_Locality__r.Name) ;
        helper.openCloseSearchResults(component, "area", false);
        component.find("areaName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    },
    modifyData :function(component, event, helper) {
        component.set('v.Message','In case of details modification , you will need to connect with telecaller. Would you like to continue ?');
        console.log('v.Message' +  component.get('v.Message'));
        component.set("v.bttnModify",true);
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpBack, 'slds-backdrop_open');
        
    },
    confirmModify :function(component, event, helper) {
        
        if(component.get("v.bttnModify")==true){
            component.set('v.isEditBank',false);  
            component.set('v.isEditDemo',false);
            component.set("v.isEdit", false);
            component.set("v.isUWCheck",false);
          
        }else if(component.get("v.isConfirm")){
             component.set('v.isEditBank',true);  
             component.set('v.isEditDemo',true);
             component.set("v.isUWCheck",true);
             helper.hideConfirmation(component, event);
        }else{
            component.set("v.isExit",true);
        }
        helper.hideConfirmation(component, event);
        
    },
    
    saveBankingDetails  :function(component, event, helper) {
         var fieldList=["BankaAccountNo","BankName","BankaAccountHolder"];
        var valid=true;
        for(var i=0;i<fieldList.length;i++){
            if(!component.find(fieldList[i]).get("v.validity").valid){
                {
                    component.find(fieldList[i]).showHelpMessageIfInvalid();
                    valid=false;
                }	 
            }
        }
       if(helper.isValidData(component, event,fieldList))
        {
            helper.saveLoanDetails(component, event,"Bank Details");
        } 
        
    },
    saveDemographicDetails  :function(component, event, helper) {
       var fieldList=["currentAddress","City","State","pincode"];
        var valid=true;
        for(var i=0;i<fieldList.length;i++){
            if(!component.find(fieldList[i]).get("v.validity").valid){
                {
                    component.find(fieldList[i]).showHelpMessageIfInvalid();
                    valid=false;
                }	 
            }
        }
        if(helper.isValidData(component, event,fieldList))
        {
            helper.saveLoanDetails(component, event,"Demographic Details");
        }
    },
    
    cancelModify : function(component, event, helper) {
        component.set("v.isUWCheck",true);
        helper.hideConfirmation(component, event);
        
    },
    confirmLoanApplication: function(component, event, helper) {
        var fieldList1=["currentAddress","City","State","pincode"];
        var fieldList2=["BankaAccountNo","BankName","BankaAccountHolder"];
        if(component.get("v.callCharges") == false)
        {
          //  helper.callFeesAndCharges(component,event);
        }
         component.set("v.isUWCheck",false);
         component.set("v.isConfirm",true);
         var cmp=component.find("ckycCMP");
         component.set("v.isEditDemo",false);
         component.set("v.isEditBank",false);
        if(cmp.validateCKYC() && helper.isValidData(component, event,fieldList1) && helper.isValidData(component, event,fieldList2)){
        	 helper.saveLoanDetails(component, event,"Confirm EmployeeLA");
        	//alert('ok');
        }else{
           component.set("v.Message","Please contact help section for missing data. In case of details modification , you will need to connect with telecaller");
             var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpBack, 'slds-backdrop_open');
        }
    },
    hideConfirmation : function(component, event, helper) {
        helper.hideConfirmation(component, event);
    },
    nextPage: function(component, event,helper) {
      // alert(component.get("v.applicantObj.Employee_Modified__c"));
        
        if(component.get("v.applicantObj.Employee_Modified__c")==true){
             console.log('Modified flag is '+component.get("v.applicantObj.Employee_Modified__c"));
            var loanNum=component.get("v.loan.Loan_Application_Number__c");
            var msg='Your application '+loanNum+' is pending for verification . Our representative will contact you soon .';
            component.set('v.Message',msg);
            helper.executeApex(component,'uploadForModify',{
            "oppId": component.get("v.oppId")
        		},function(error, result){
            if(!error && result){
                var data = JSON.parse(result);
                console.log('Data is '+JSON.stringify(data));
                console.log('risk segment '+data.showRiskSegmentationError);
                console.log('KYC segment '+data.showKYCError);
                console.log('send to where '+ data.sentToWhere);
                if(!$A.util.isEmpty(data.sentToWhere) && data.sentToWhere=='Exit'){
                    component.set("v.isExit",true);  
                    console.log(component.get("v.isExit"));
                }
                else{
                    component.set("v.isExit",false);
                     if(data.showRiskSegmentationError == 'true' && data.showKYCError != 'true')
            			helper.displayToastMessage(component,event,'Error','Please upload Post-Dated cheques(3) in document uploader to proceed','error');
           			 else if(data.showRiskSegmentationError != 'true' && data.showKYCError == 'true'){
                		helper.displayToastMessage(component,event,'Error','Please upload KYC Document in document uploader to proceed','error');
            			}
                	 else if(data.showRiskSegmentationError == 'true' && data.showKYCError == 'true'){
                    	helper.displayToastMessage(component,event,'Error','Please upload KYC,Post-Dated Cheques(3) in document uploader to proceed','error');
                		}
                         else{
                             console.log('In else part');
                         }
                }
            }else{
                console.log('error found '+error);
            }
            helper.showhidespinner(component,event,false);
        	});
        }        helper.showhidespinner(component,event,false);

        if(component.get("v.exit")){
        component.set("v.bttnModify",false);
        var cmpTarget = component.find('overrideModalbox');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpBack, 'slds-backdrop_open');
        }
        else{
           
        }
        
    },
})