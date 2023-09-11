({
    doInit : function(component, event, helper) {
        console.log('in controller'+component.get("v.dataSource"));
        
        var acc= component.get("v.account");
        component.set("v.account",acc);
        //helper.getUserIDfromApex(component,event);
        helper.getOpportunityData(component,event);
        //var pancmp = component.find("pancheck");//21328
        //pancmp.disableFields();//21328
        // alert(component.find("sourceName").get("v.value"));
        //component.set("v.ValidReferral",true);
    },
    
    initiateKYCForm : function(component, event, helper){ 
        //console.log('kyc landing'+event.getParam("kyc").eKYC_First_Name__c);
        component.set("v.kyc", event.getParam("kyc"));
        /*Bug 18516 Start*/
        if (!$A.util.isEmpty(component.get("v.kyc")) && !$A.util.isEmpty(component.get("v.kyc.eKYC_First_Name__c")))
            component.set('v.disableAadhaar',false);
        else 
            component.set('v.disableAadhaar',true);
        /*Bug 18516 End*/
    },
    saveOpportunity :function(component, event, helper) {
        helper.saveLoanApplicationHelper(component,event);
          //23578 start
        /*console.log('robin333 '+component.get("v.account").PAN_Check_Status__c);
        console.log(component.get("v.loan").Id);
        var panCheckCmp = component.find("pancheck");
        if(panCheckCmp && component.get("v.account") && !component.get("v.account").PAN_Check_Status__c ){
            console.log('inside pancheck');
            panCheckCmp.callPanCheck('Landing');
        }
        else{
            console.log('in else');
            helper.saveLoanApplicationHelper(component,event);
        }*/
        //23578 stop

    },
    sourceKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.ValidSourceChannel",false);
        helper.startSearch(component, 'source');
    },
    selectSource: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedSource = component.get("v.sourceList")[index];
        console.log(selectedSource);
        var keyword = selectedSource.Name;
        var branchtype =selectedSource.Branch__c;
        component.set("v.loan.Branch_Name__c",branchtype);
        if(!$A.util.isEmpty(selectedSource.Branch__r) && !$A.util.isEmpty(selectedSource.Branch__r.Name))
            component.set("v.loan.Branch__c",selectedSource.Branch__r.Name);
       
        if(!$A.util.isEmpty(selectedSource.sourcing_channel_user__r))
            component.set("v.loan.Relationship_Manager__c",selectedSource.sourcing_channel_user__r.Id);
        else if(!$A.util.isEmpty(selectedSource.Reporting_Manager__r))
              component.set("v.loan.Relationship_Manager__c",selectedSource.Reporting_Manager__r.id);
        if(!$A.util.isEmpty(selectedSource.Reporting_Manager__r)){
            component.set("v.loan.ASM_email_id__c",selectedSource.Reporting_Manager__r.Email);
            //component.set("v.loan.Relationship_Manager__c",selectedSource.Reporting_Manager__r.id);
        }
       // console.log('branchtype -->'+selectedSource.Branch__r.SAL_Branch_Type__c);
        if(!$A.util.isEmpty(selectedSource.Branch__r) && selectedSource.Branch__r.SAL_Branch_Type__c == 'Tier III')
            component.set("v.isSpecialProfile", true);
        
        component.set("v.ValidSourceChannel",true);
        component.set("v.selectedSource", selectedSource);
        component.set("v.sourceSearchKeyword", keyword);
        component.set("v.loan.Sourcing_Channel__c", selectedSource.Id);
        helper.openCloseSearchResults(component, "source", false);
        component.find("sourceName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    },
    referralKeyPressController: function (component, event, helper) {
        console.log('inreferralkey'+component.find('referralName'));
        if(!$A.util.isEmpty(component.find('referralName').get('v.value')))
            component.set("v.ValidReferral",false);
       else
       {
           component.set("v.ValidReferral",true);
           component.set("v.loan.Referral__c",'');
       }
           helper.startSearch(component, 'referral');
    },
    selectReferral: function (component, event, helper) {
        component.set("v.ValidReferral",true);
        var index = event.currentTarget.dataset.record;
        var selectedReferral = component.get("v.referralList")[index];
        console.log(selectedReferral);
        var keyword = selectedReferral.Name;
        console.log('keyword Referral>>' + keyword);
        component.set("v.selectedReferral", selectedReferral);
        console.log('keyword Referral1>>' + keyword);
        component.set("v.referralSearchKeyword", keyword);
        console.log('keyword Referral2>>' + component.get("v.loan"));
        component.set("v.loan.Referral__c", selectedReferral.Id);
        console.log('keyword Referral3>>' + keyword);
        helper.openCloseSearchResults(component, "referral", false);
        component.find("referralName").set("v.errors", [{
            message: ""
        }
                                                       ]);
    },
    salesRejectcomp : function(component,event,helper)
    {       var multislect = component.find("mymultiselect");
     var mySelectedvalues = multislect.bindData();
     component.set("v.mySelectedvalues",mySelectedvalues);
     if(!$A.util.isEmpty(mySelectedvalues))
     {
         helper.showhidespinner(component,event,true);
         helper.salesRejectHelper(component,event);
     }
     else
     {   // $A.util.addClass(component.find("multiselectdiv"), "slds-show");
         helper.displayToastMessage(component,event,'Error','Please select reject reason ','error');
     }
     
    },
    handleSelectChangeEvent: function(component, event, helper) {
        var items = event.getParam("values");
        console.log(items[0]);
        component.set("v.mySelectedItems", items);
        console.log(component.get("v.mySelectedItems"));
    },
    doEmploymentCheck: function(component, event, helper){
        var pancmp = component.find("pancheck");
        var isEmptyEmailId = pancmp.checkOfficeEmailId();
        if(isEmptyEmailId==true)
        {
            helper.doEmpCheck(component);
        }
        else
        {
            helper.displayToastMessage(component,event,'Error','Please Enter Office Email ID','error');
        }
    },
    doEPFOCheck: function(component, event, helper){
        
        helper.doEPFO(component);
        
    },
    callPANBre: function(component, event, helper){
        helper.callPANBre(component);
    },
    
    //Rohit sales reject start
    showSalesReject : function(component, event, helper){
        component.set("v.showMulti",true);
        $A.util.removeClass(component.find("pickListDiv"), "slds-hide");
        $A.util.removeClass(component.find("rejectButtonDiv"), "slds-hide");
        $A.util.removeClass(component.find("salesRejectDiv"), "slds-hide");
        
        
        $A.util.addClass(component.find("pickListDiv"), "slds-show");
        $A.util.addClass(component.find("rejectButtonDiv"), "slds-show");
        $A.util.removeClass(component.find("salesRejectDiv"), "slds-show");
        var loan = component.get("v.loan");
        var reasonval = loan.Reject_Reason__c;
        console.log('reasonval'+ reasonval);
        var multislect = component.find("mymultiselect");
        multislect.setRejectReason(reasonval);
        if (!$A.util.isEmpty(loan.Reject_Reason__c)){
            component.find("RejectButtonId").set("v.disabled",true)
        }
        component.find("enableReject").set("v.disabled",true);
        
    },
    //Rohit sales reject stop
	 //23578 start
   
    toggletab : function(component, event, helper){
        var targetId= event.target.getAttribute('id');
        console.log(targetId);
        /*if(targetId=="subname4" || targetId=="subicon4" || targetId=="subsection4"){
            var x = document.getElementById(targetId).innerHTML;
            console.log(x);
            if(x =="[-]"){
                    document.getElementById(targetId).innerHTML = "[+]";
                $A.util.addClass(component.find('subsection4Content'), 'slds-hide');
                $A.util.removeClass(component.find('subsection4Content'), 'slds-show');
            }
            else{
                	$A.util.addClass(component.find('subsection4Content'), 'slds-show');
                $A.util.removeClass(component.find('subsection4Content'), 'slds-hide');
                    document.getElementById(targetId).innerHTML = "[-]"; 
            }
            
        }*/
        helper.toggleTabUtil(component, event , targetId);
        
    },
     setCkyc : function(component, event, helper){
    	helper.setCkycFields(component, event);
         helper.toggleTabUtil(component, event , "subicon4");// collapse ckyc tab 
	},
    //US21328s
    /*toggleTab : function(component, event, helper){
         
         helper.displayToastMessage(component,event,'Error','toggleTab ','error');
         document.getElementById('subicon4').innerHTML = "[+]";               
                $A.util.addClass(component.find('subsection4Content'), 'slds-hide');
                $A.util.removeClass(component.find('subsection4Content'), 'slds-show');
	},*/
    //US21328e
    
    callSaveAfterPANChk : function(component, event, helper){
        helper.saveLoanApplicationHelper(component,event);
    },
    setCKYCfieldsParent : function(component, event, helper){
       	//helper.changeCKYCfields(component,false);
       	var pancmp = component.find("pancheck");
        pancmp.setCKYCfields();
      },
    //23578 stop
     onChangeProduct : function(component, event, helper){
         console.log('in productchange::');
         //console.log('in productchange::');//+$A.get("$Label.CkycProducts"));
          //var a =component.find("ProductType").value;
          //console.log('in productchange1::'+a);
	}
})