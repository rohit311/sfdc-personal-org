({
	 doInit  : function(component, event, helper) {
         console.log('Comp  doInit');
         var checkMap = [];
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
         /*commented for bug id 21851 start
         checkMap.push({
              name: 'KYC',
              toggle: 'false',
              type : 'eKyc',
              showUpload : 'true',
              showDocUploader : 'true'
          }); commented for bug id 21851 stop*/
         checkMap.push({
             name: 'Perfios Response Recieved',
             toggle: 'false',
             type : 'Perfios',
             showUpload : 'true',
             showDocUploader : 'false'
         });
         checkMap.push({
             name: 'SPDC Applicability',
             toggle: 'false',
             type : 'SPDC',
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
        // console.log('length og checklist'+checkMap.length);
        component.set("v.checklistMap",checkMap);
        helper.getDashboardDetails(component,event);

    },
    
    selectOpsCreditOfficer : function(component, event, helper) {
       
        helper.selectOpsCreditOfficerHelper(component, event);
    },
    showComments : function(component, event, helper) {
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
       //helper.sendToFinnOne(component,event);
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
        //var cmpBack = component.find('Modalbackdrop');
        //$A.util.removeClass(cmpBack,'slds-backdrop--open');
        //$A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
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
    
})