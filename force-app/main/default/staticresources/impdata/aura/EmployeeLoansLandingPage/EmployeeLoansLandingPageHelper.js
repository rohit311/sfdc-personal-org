({
    getOffer : function(component, event) {
        this.showhidespinner(component,event,true);
        var loanSelectList = ["Approved_Tenor__c","Loan_Type__c"];
        var selectListNameMap = {};
        selectListNameMap["Performance_reports__c"] = loanSelectList;
        var employeeId=component.get("v.EmployeeId");
        this.executeApex(component, "getEmployeeOffer", {
            'EmployeeId': employeeId, "objectFieldJSON":JSON.stringify(selectListNameMap)
        }, function (error, result) {
             
            if (!error && result) {
                var data=JSON.parse(result);
                console.log('Result in landing page '+JSON.stringify(data));//stageOfLoan
               console.log('hrushikesh signal '+data.stageOfLoan);
                if(data.stageOfLoan=='DSA/PSF Login')
                {
                   component.set('v.currentStageIsMydetails',false);    
                }
                else
                   component.set('v.currentStageIsMydetails',true);    
                
                component.set('v.performance_report',data.perList);
                console.log('data.isNonDisbursed  '+data.isNonDisbursed);
                console.log("v.performance_report.Loan_Application_Number__c.Offer_converted__c"+component.get("v.performance_report.Offer_converted__c"));
                if(data.isLAOpen==true && data.isNonDisbursed==true){
                    console.log('All disbursed false');
                    component.set("v.OppId",component.get("v.performance_report.Loan_Application_Number__c"));
                    if(component.get('v.performance_report.Offer_converted__c')==true){
                         component.set('v.ApplicantObj',data.primaryApplicant);
                         component.set("v.isOfferAvailabel",false);
                        if(component.get("v.performance_report.Loan_Type__c")=='Hybrid Loan'){
                            if(component.get("v.performance_report.Availed_Tenor__c") != null){
                                var tenor = component.get("v.performance_report.Approved_Tenor__c") - component.get('v.performance_report.Availed_Tenor__c');
                            	console.log('tenor landing page'+tenor);
                                component.set("v.loanTenor",tenor);
                                console.log('After setting '+component.get("v.loanTenor"));
                            }
                            
                        }
                        
                        if(component.get('v.performance_report.Loan_Application_Number__r.StageName')=='DSA/PSF Login'){
                            component.set("v.isDetailsAvailable",true);
                            component.set("v.availedTenor",component.get('v.performance_report.Availed_Tenor__c'));
                            component.set("v.selTabId","tab2");    
                        }else if(component.get('v.performance_report.Loan_Application_Number__r.StageName')=='Post Approval Sales' || component.get('v.Performance_report.Loan_Application_Number__r.StageName')=='Branch Ops'){
                            component.set("v.isDetailsAvailable",false);
                            component.set("v.isVASAvailable",true);
                            component.set("v.availedTenor",component.get('v.performance_report.Availed_Tenor__c'));
                            component.set("v.selTabId","tab3");   
                        }if(component.get('v.performance_report.Loan_Application_Number__r.StageName')=='Moved To Finnone'){
                            component.set("v.selTabId","tab4");   
                            component.set("v.availedTenor",component.get('v.performance_report.Availed_Tenor__c'));
                        }
                    }else{
                        component.set("v.modalHeader","Open application found");
                        var cmpTarget = component.find('overrideModalbox');
                        var cmpBack = component.find('Modalbackdrop');
                        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
                        $A.util.removeClass(cmpTarget, 'slds-hide');
                        $A.util.addClass(cmpTarget, 'slds-show');
                        $A.util.addClass(cmpBack, 'slds-backdrop_open');
                    }
                }else if (data.isNonDisbursed == false && component.get("v.performance_report.Offer_converted__c") == true){
                          console.log('All disbursed true');
                           component.set('v.noOfferAvailable',true);
                }
                var picklistFields = data.picklistData;
                var oppPickFlds = picklistFields["Performance_reports__c"];
                component.set("v.loanTenorList", oppPickFlds["Approved_Tenor__c"]);
                component.set("v.loanTypeList", oppPickFlds["Loan_Type__c"]);
                component.set("v.loanTenor",component.get("v.performance_report.Approved_Tenor__c"));
                component.set("v.hybridFullTenor",component.get("v.performance_report.Approved_Tenor__c"));
				console.log('in landing');
               //  alert(component.get('v.hybridFullTenor'));

                component.set("v.loanTenorInitial",component.get("v.performance_report.Approved_Tenor__c"));                 
                component.set("v.Rate",data.rate);
                component.set("v.Fees",data.processingFee);
                component.set("v.availedAmount",component.get("v.performance_report.Approved_Amt__c"));
                component.set("v.InitialAmount",component.get("v.performance_report.Approved_Amt__c"));
                
                console.log('component.set'+ component.get('v.performance_report.Approved_Tenor__c') );
                component.set('v.dataLoaded',true);
                component.set('v.OppId',component.get('v.performance_report.Loan_Application_Number__c'));
               console.log('try'+component.get('v.performance_report.Loan_Application_Number__c'));
                if(component.get("v.performance_report.Loan_Type__c")=="Term Loan"){
                     component.set('v.EMILabel','EMI');
                     component.set('v.TenorLabel','Tenor');
                }else if(component.get("v.performance_report.Loan_Type__c")=="Flexi Term Loan"){
                     component.set("v.EMILabel","EMI for Flexi Term Loan Duration");
                     component.set("v.TenorLabel","Flexi Term Loan Tenor");
                }
                
                var tenorList = component.get("v.loanTenorList");
                var approvedTenor = component.get("v.performance_report.Approved_Tenor__c");
                var newTenorList = [];
                component.set("v.Fees",data.processingFee);
                tenorList.forEach(function(listObj) {
                    if(parseInt(listObj, 10) <= parseInt(approvedTenor,10)){
                        newTenorList.push(listObj);
                    }
				});
                console.log('newTenorList is '+newTenorList);
                component.set("v.loanTenorList",newTenorList);
                
                this.showhidespinner(component,event,false);
            }
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
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
     getDecryptEmployeeId : function(component,event) {
        var empid=component.get("v.EncryptedEmployeeId");
        var action = component.get("c.decryptEmpId"); //this is method
         console.log('HI'+component.get("v.EncryptedEmployeeId"));
        action.setParams({
            "EmployeeID": empid,
            
        });
        action.setCallback(this, function(response) {
             
            if(response.getReturnValue() != "NO DATA"){
                //  var staticLabel = $A.get("$Label.c.BflsiteuserURL");
                console.log("on landing page= "+response.getReturnValue());
               // window.location.href = staticLabel+'/EmployeeLoansLanding_VF?EmployeeId='+response.getReturnValue();
                component.set("v.EmployeeId",response.getReturnValue());
                        this.getOffer(component, event);

            }
        });
        
        $A.enqueueAction(action);
    },
    firePassInsuranceEvent : function(component, insuranceList){
        // console.log("VALIDATIONS EVT FIRED");
        var compEvents = $A.get("e.c:InsuranceCMPValidations");
        // console.log('firePassInsuranceEvent ===>> ',compEvents);
        compEvents.setParams({ "insuranceList" : insuranceList });
        compEvents.fire();
    }
})