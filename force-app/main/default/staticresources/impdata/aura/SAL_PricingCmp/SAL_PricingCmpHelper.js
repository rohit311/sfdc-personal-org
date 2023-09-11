({
     //added for bug id 22047 start  
    getHideAadhaarSectionHelper:function(component)
    {

        var action = component.get("c.getHideAadhaarSection");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar>>>'+response.getReturnValue());
               		component.set('v.hideAadhaarSection',response.getReturnValue());   
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
    },
    //added for bug id 22047 stop
    onLoadPricingData:function(component, event){
        var surogateselectList = ["Line_opted__c"];
        var purposeOfLoan  = ["Purpose_of_Facility__c","Preffered_Mode_to_Connect__c"];
        var verSelectList = ["Status__c","Sales_Status__c","Credit_Status__c"];
        var solSelectList =["Landlord_Gender__c","Agreement_Type__c","Deposit_By__c"]; //24673
        var discrepancySelectList = ["OTPDiscrepancyCategory__c","OTPDiscrepancyDocuments__c","Status__c"];
        var accountValidate = ["IMPS_Account_Validate__c"]; //22018
        var selectListNameMap = {};
        selectListNameMap["Discrepancy__c"] = discrepancySelectList;
        selectListNameMap["SurrogateCAM__c"] = surogateselectList;
        selectListNameMap["Account"] = purposeOfLoan;
        selectListNameMap["Verification__c"] = verSelectList;
        selectListNameMap["SOL_Policy__c"]= solSelectList; //24673
        selectListNameMap["Current_Disbursal_Details__c"] = accountValidate; //22018
        console.log('record id is'+component.get("v.recordId"));
        if(component.get("v.recordId") != null && component.get("v.recordId") != ''){
            component.set("v.oppId",component.get("v.recordId"));
        }
        var oppId = component.get("v.oppId");
        this.showhidespinner(component,event,true);
        this.executeApex(component, 'fetchData', {
            "loanAppId": oppId,
            "objectFieldJSON" : JSON.stringify(selectListNameMap)
        }, function(error, result){
            console.log('in success>>>'+result);
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {
                    var dataObj = JSON.parse(result);
                    console.log('theme is'+dataObj.theme)
                    component.set("v.theme",dataObj.theme);
                    component.set("v.iscommunityUser",dataObj.isCommunityUsr);
                    component.set("v.loan",dataObj.opp);
                    console.log('data is::'+component.get("v.loan"));
                    component.set("v.addOnSolList",dataObj.addOnSolList);//Bug 24667
                    component.set("v.NoOfAddCards",dataObj.noAddonCards);//Bug 24667
                    /* CR 22307 s*/
                    if(!$A.util.isEmpty(dataObj.opp) && !$A.util.isEmpty(dataObj.opp.StageName))
                        component.set("v.stageName", dataObj.opp.StageName); /* CR 22307 e*/
                    component.set("v.EMI",dataObj.opp.EMI_CAM__c);
                    component.set("v.approvedRate",dataObj.opp.Approved_Rate__c);
                   // alert('onhomepage '+dataObj.opp.Approved_Rate__c);
                    component.set("v.approvedPF",dataObj.opp.Processing_Fees__c);
                    component.set("v.maxLoanAmt",dataObj.opp.Approved_Loan_Amount__c);/*SAL 2.0 CR's s*/
                    component.set("v.scam",dataObj.srcamObj);
                    component.set("v.applicantObj",dataObj.applicantPrimary);
                    //1652 changes later

         if(!$A.util.isEmpty(component.get('v.applicantObj')) &&!$A.util.isEmpty(component.get('v.applicantObj.PFApproveStatus__c')) )             
            {
                if(component.get('v.applicantObj.PFApproveStatus__c').includes('Approved'))
                {
                        component.set("v.disableApproveButton",true);
                    console.log('disableApproveButton is tru');
                }
            
            }//1652
                    console.log('flexi check'+dataObj.applicantPrimary.Drop_Line_Flexi_Period__c+'---'+dataObj.applicantPrimary.Pure_Flexi_Period__c);
                    component.set("v.sanctionList",dataObj.sanctionList);
                    component.set("v.existingDisList",dataObj.existingDisList);
                    component.set("v.disbList",dataObj.disburement);
                    component.set("v.acc",dataObj.accObj);
                    if(dataObj.objCon)
                    component.set("v.StampDuty", dataObj.objCon.Stamp_Duty__c);                  
					if(!$A.util.isEmpty(dataObj.maxLimitROI)) //sprint 5C 22624    
                    	component.set("v.maxLimitROI",dataObj.maxLimitROI); //sprint 5C 22624      
                                        	console.log('TIITI'+dataObj.maxLimitROI); //sprint 5C 22624                  
                    component.set("v.repayList",dataObj.repayList);
                    
                    //1652 start
                     component.set("v.locationCategory",dataObj.BranchLocation);
                    //1652 stop
                    
                    
                    //US 5374 start
                    if(component.get('v.repayList')){
                        for(var j=0;j<component.get('v.repayList').length;j++){
                            
                            if(component.get('v.repayList')[j].Mandate_Process_Stage__c == 'Finished' && (component.get('v.repayList')[j].UMRN__c == null || component.get('v.repayList')[j].UMRN__c == '')){
                                component.set("v.showUMRNBtn",true);
                                break;
                                
                            }
                        }
                        
                    }
                    //US 5374 stop
                    
                    var a=component.get('v.repayList');
                      console.log('Date we get '+JSON.stringify(a[0]));
                    component.set("v.TatTime", dataObj.TatTime);
					console.log('existingDisList'+dataObj.existingDisList.length);
                    console.log('sanctionList'+dataObj.sanctionList.length+dataObj.accObj);
                    var picklistFields = dataObj.picklistData;
                    var discrepancyPickFlds = picklistFields["Discrepancy__c"];
                    component.set("v.Status__c",discrepancyPickFlds["Status__c"]); 
                    if (!$A.util.isEmpty(picklistFields["Verification__c"]))
                    {
                        var verPickFlds = picklistFields["Verification__c"];
                        console.log('veri status'+verPickFlds["Status__c"]);
                        component.set("v.credStatus", verPickFlds["Status__c"]);
                        component.set("v.salesStatus", verPickFlds["Sales_Status__c"]);
                        component.set("v.creditStatusVer", verPickFlds["Credit_Status__c"]);
                    }
                    console.log('My List->'+picklistFields["Account"]["Purpose_of_Facility__c"]);
                    if (!$A.util.isEmpty(picklistFields["Account"]))
                    {
                        component.set("v.proposedLoan",picklistFields["Account"]["Purpose_of_Facility__c"]);
                        component.set("v.preferredMode",picklistFields["Account"]["Preffered_Mode_to_Connect__c"]);
                    }
                    /*24673 s*/
                    if (!$A.util.isEmpty(picklistFields["SOL_Policy__c"])) 
                    {
                        component.set("v.landlordGenderList",picklistFields["SOL_Policy__c"]["Landlord_Gender__c"]);
                        component.set("v.landlordAgreementTypeList",picklistFields["SOL_Policy__c"]["Agreement_Type__c"]);
                        component.set("v.landlordDepositByList",picklistFields["SOL_Policy__c"]["Deposit_By__c"]);
                    } /*24673 e*/
                    if (!$A.util.isEmpty(picklistFields["SurrogateCAM__c"]))
                    {
                        component.set("v.lineoptedList",picklistFields["SurrogateCAM__c"]["Line_opted__c"]);
                    }
                    //alert(JSON.stringify(picklistFields["IMPS_Account_Validate__c"]));
                    if (!$A.util.isEmpty(picklistFields["Current_Disbursal_Details__c"])) //22018
                    {
                	component.set('v.accntValidateList',picklistFields["Current_Disbursal_Details__c"]["IMPS_Account_Validate__c"]);
                    }
                    if(component.get("v.theme") == 'Theme4d')
                    {
                        var cmpTarget = component.find('boxBorder');
                        $A.util.addClass(cmpTarget, 'slds-box slds-box_x-small');
                        
                    }
                    /*24673 s*/
                    console.log('dataObj.solpolicyLandLord'+dataObj.solpolicyLandLord);
                    console.log('String:'+JSON.stringify(dataObj.solpolicyLandLord));
                    console.log('in parent bank::'+ dataObj.solpolicyLandLord.Bank_Name__c);
                    console.log('in parent property::'+dataObj.solpolicyLandLord.Property__c);
                    console.log('in parent accessories::'+dataObj.solpolicyLandLord.Accessories__c);
                    if(dataObj.solpolicyLandLord!=null) 
                    {
                       component.set("v.solObjLandLord",dataObj.solpolicyLandLord);
                        component.set("v.bankSearchKeyword", dataObj.solpolicyLandLord.Bank_Name__c);
                    }/*24673 e*/
                    //priyanka added for EKYC--> start
                    if(dataObj.poobj!=null)
                    {
                        if(!$A.util.isEmpty(dataObj.poobj.Customer_ID1__r))
                        {
                            component.set("v.custId",dataObj.poobj.Customer_ID1__r.Id);
                            
                        }
                    }
                    else{ component.set("v.custId",'') }
                    
                    
                    
                    component.set("v.isPreapproved" ,dataObj.isPreapproved);
                    console.log('theme-->'+component.get("v.isPreapproved"));
                    
                    if(dataObj.ekycobj != null && dataObj.ekycobj != undefined){
                        component.set("v.kyc",dataObj.ekycobj);
                        component.set("v.isEkycDone",true);
                        console.log('in ekyc parent '+JSON.stringify(dataObj.ekycobj));
                    }    
                    
                    //priyanka added for EKYC --> end
                    //22017 start
                    //  if (!$A.util.isEmpty(dataObj.eliteCardoptions))
                    {   
                        var eliteoptions = [];
                        for(var key in dataObj.eliteCardoptions){
                        eliteoptions.push({value:key, label:dataObj.eliteCardoptions[key]});
                         }
                        component.set("v.elitecardoption",eliteoptions)
                    }
                    if (!$A.util.isEmpty(dataObj.emiCardoptions))
                    {   
                        var emioptions = [];
                        for(var key in dataObj.emiCardoptions){
                        emioptions.push({value:key, label:dataObj.emiCardoptions[key]});
                         }
                        component.set("v.emicardoption",emioptions)
                    }
                    //22017 end
                    var opp = component.get("v.loan");
                    var oppStage = opp.StageName;
                    if(oppStage != null)
                    {
                        if(oppStage == 'DSA/PSF Login')
                        {
                            component.set("v.stageCompletion","20%") ;
                            component.set("v.displayReadOnly",true);
                        }
                        else if(oppStage == 'Underwriting')
                        {
                            component.set("v.stageCompletion","40%");
                            component.set("v.displayReadOnly",true);
                        }
                            else if(oppStage == 'Post Approval Sales')
                            {
                                component.set("v.stageCompletion","60%");
                            }
                                else if(oppStage == 'Branch Ops')
                                {
                                    component.set("v.stageCompletion","80%");
                                }
                                    else if(oppStage == 'Moved To Finnone')
                                    {
                                        component.set("v.stageCompletion","100%");
                                        $A.util.addClass(component.find("progressSpan"),"slds-progress-bar__value_success");
                                    }    
                    }
                    else{
                        component.set("v.stageCompletion","0%");
                    }
                   component.find("commercialconsent").updatelastemi();//22017
                }
                 
            }
           
            this.showhidespinner(component,event,false);
        });
        
    },
   
    executeApex: function(component, method, params,callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
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
    backToStdRecordPage: function(component, event,oppId){
        if(component.get('v.theme') =='Theme3' || component.get('v.theme') =='Theme2'){
            if(component.get('v.iscommunityUser'))
                window.location.href = '/Partner/'+oppId;
            else
            { //Added if/else condition for Bug 17698
                if(component.get("v.oppId") != null)
                    window.location.href = '/'+oppId;
                else
                    window.location.href = '/lightning/r/Product_Offerings__c/'+oppId+'/view';
            }
            this.showhidespinner(component,event,false);
        }
        else if(component.get('v.theme') == 'Theme4d')
        {
        	if(component.get("v.oppId") != null)
                window.location.href = '/'+oppId;
            else
                window.location.href = '/lightning/r/Opportunity/'+oppId+'/view';
        }
        else if(component.get('v.theme') == 'Theme4t')
            this.navigateToRecordForLEX(component, event,oppId);
    },
    navigateToRecordForLEX : function (component, event,oppId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        console.log('oppId inside navigateToRecordForLEX : '+oppId);
        navEvt.setParams({
            "recordId": oppId
        });
        navEvt.fire();
        this.showhidespinner(component,event,false);
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
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
})