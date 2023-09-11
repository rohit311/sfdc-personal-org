({
	 doInit  : function(component, event, helper) {
         console.log('Comp  doInit');
          /* CR 22307 s */
        if(component.get("v.stageName") != 'Post Approval Sales'){
            component.set("v.displayReadOnly",true);
        } /* CR 22307 e */
         var checkMap = [];
         //added for bug id 21851 start
        var action = component.get("c.getHideAadhaarSection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               		component.set('v.hideAadhaarSection',response.getReturnValue());  ;  
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
         checkMap.push({
             name: 'Customer consent on e-Agreement',
             toggle: 'false',
             type : 'CustomerConsent',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         checkMap.push({
             name: 'Customer consent on Application Form',
             toggle: 'false',
             type : 'AppForm',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         
         /*checkMap.push({
              name: 'KYC',
              toggle: 'false',
              type : 'eKyc',
              showUpload : 'true',
              showDocUploader : 'true'
          }); */
         checkMap.push({
             name: 'Perfios Response Recieved',
             toggle: 'false',
             type : 'Perfios',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         
         checkMap.push({
             name: 'E-Mandate and Repayment fields status',
             toggle: 'false',
             type : 'eMandate',
             showUpload : 'true',
             showDocUploader : 'true'
             
         });
         checkMap.push({
             name: 'SPDC Applicability',
             toggle: 'false',
             type : 'SPDC',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         checkMap.push({
             name: 'IMPS and Disbursement fields status',
             toggle: 'false',
             type : 'IMPS',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         checkMap.push({
             name: 'De-dupe linking completed',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'Insurance details captured',
             toggle: 'false',
             type : 'Insurance',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         checkMap.push({
             name: 'Sanction Condition/Discrepancy status',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'Repayment and Disbursal Match',//22017
             toggle: 'false',
             type : 'BankCheck',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         checkMap.push({
             name: 'Bank Verification status',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'Current Address Verification status',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'Permanent Address Verification status',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'Office Verification status',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'Geo Tagging',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         /*22624 s*/
         checkMap.push({
             name: 'Rate Approval',
             toggle: 'false',
             type : '',
             showUpload : 'true',
             showDocUploader : 'true'
         });
         /*22624 e*/
         /*24673 s*/
        // console.log('in push::'+component.get('v.oppObj'));
        // console.log('in push::'+component.get('v.oppObj').Product__c);
         if(component.get('v.oppObj').Product__c == 'RDPL'){
             console.log('checking rdpl');
             checkMap.push({
                 name: 'Rental Agreement',
                 toggle: 'false',
                 type : 'RentalAgreement',
                 showUpload : 'true',
                 showDocUploader : 'true'
             });
         }
         /*24673 e*/
		  //23578 Start
          checkMap.push({
             name: 'C-KYC',
             toggle: 'false',
             toggle_img: 'false',
             type : '',
             showUpload : 'true',
             showUpload_img : 'true',
             showDocUploader : 'true'
         });
         //23578 Stop
        // console.log('length og checklist'+checkMap.length);
        component.set("v.checklistMap",checkMap);
        helper.getDashboardDetails(component,event);

    },
    
    selectOpsCreditOfficer : function(component, event, helper) {
        /*US 5331 s*/      
        
      if(!component.get("v.CentralisedSOL") || component.get("v.CentralisedSOL.Remarks__c") != 'Complete' ){
          
            helper.displayToastMessage(component,event,'Error','Please click on mark complete','error');
            return;
        } 
         
        /*US 5331 e*/
        helper.selectOpsCreditOfficerHelper(component, event);
    },
    showComments : function(component, event, helper) {
    var allowToSendBack = component.get("v.allowToSendBack"); //24315
		if(allowToSendBack== false )
        {helper.displayToastMessage(component,event,'Error','Required bank account not matching. Case needs to be sent back by uploading bank statement','error');
        helper.showhidespinner(component,event,false);}//24315
        else
         component.set("v.showComments",true);
    },
    sendBack : function(component, event, helper) {
        helper.sendBackHelper(component, event);
    },
    sendbackCancel : function(component, event, helper) {
        component.set("v.showComments",false);
    },
    
    finalSubmitBranchOps : function(component, event, helper){
        if(component.get("v.selectedCreditOfficer") == '-- None --')
            {
                helper.displayToastMessage(component,event,'Error','Select a credit officer','error');
            }
        else{
            helper.confirmSubmitToBranchOps(component,event);
        }
    },
    		
        
    submit : function(component,event,helper){
        // user story 978 s
        var updateidentifier =  $A.get("e.c:Update_identifier");
        updateidentifier.setParams({
            "eventName": 'Pricing Dashboard',
            "oppId":component.get("v.oppObj").Id
        });
        updateidentifier.fire();
        // user story 978 e
        
          /*US 5331 s*/      
        if(!component.get("v.CentralisedSOL") || component.get("v.CentralisedSOL.Remarks__c") == 'Required' ){
            helper.displayToastMessage(component,event,'Error','Please click on mark complete','error');
            return;
        }  
        var centralisedSampling=component.get("v.centralisedSampling"); 
        
        //alert('__'+centralisedSampling+'__');
        if(centralisedSampling != 'true'){
            helper.displayToastMessage(component,event,'Error',centralisedSampling,'error');
            return;
        }
         /*US 5331 e*/
         /*US_5574 S*/
        if(component.get("v.rcuFlag")){
             helper.displayToastMessage(component,event,'Error','Verification status is either Negative or Fraud','error');
            return;
        } 
        /*US_5574 E*/
       helper.sendToFinnOne(component,event);
       
    },
        
    
    documentUploaded : function(component, event, helper) {
     	
        if(	event.getParam("fileName").includes('Customer consent on e-Agreement')){
            console.log('inside HHH ');
            //component.find('Customer consent on e-Agreement-toggle').set("v.checked",true);
            helper.executeApex(component, 'acceptOffer', {
            "oppId": component.get("v.oppId")  
        	}, function(error, result){
        		//code to fetch upload details
        		if(!error)
                {
                	console.log("updated successfully");
                }
                else{
                    console.log('error');
                }
            });
        }
        console.log('in event of doc upload');
        var filename = event.getParam("fileName");
        var checkMap = component.get("v.checklistMap");
        for(var j=0;j<checkMap.length;j++){
            if(checkMap[j].name == filename){
                checkMap[j].toggle = 'true';
                checkMap[j].upload = 'true';
            }
        }
        helper.uploadVerification(component,event);   
        component.set("v.checklistMap",checkMap);
         
    },
    
    callSubmitToBranchOps : function(component, event, helper) {
     
        helper.sendToBranchOps(component, event);
        var cmpTarget = component.find('overrideModalbox');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
        
	},
    
   
      onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    
        closeModal : function(component,event){    
        var cmpTarget = component.find('overrideModalbox');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    },
    /*24673 s*/
    checkAggStatus : function(component,event,helper){   
    	helper.checkAggStatusHelper(component,event);
    },
    /*24673 e*/
    //24668 start
    onAppChange : function(component, event, helper) {
        if(component.get("v.appType") == 'Financial Co-Applicant'){
            component.set("v.curAppId",component.get("v.finAppl").Id);  
            helper.populateApplData(component, event);
        }
        else{           
            component.set("v.curAppId",component.get("v.primaryapplicant").Id); 
        }
    },
	//24668 stop
/*added by swapnil for  Centralized Sampling changes Epic Id User Story ID 5331 s*/
    chk1 : function(component, event, helper) {
        //helper.showhidespinner(component,event,true);
        helper.chk2(component, event);
    },
    /*added by swapnil for  Centralized Sampling changes Epic Id User Story ID 5331 s*/
    
})