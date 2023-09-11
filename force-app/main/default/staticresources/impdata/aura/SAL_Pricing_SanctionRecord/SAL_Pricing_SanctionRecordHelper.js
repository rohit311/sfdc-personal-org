({
    loadDiscrepancyDetails : function(component,event) {
        var discrepancySelectList = ["OTPDiscrepancyCategory__c","OTPDiscrepancyDocuments__c","Status__c"];
        var selectListNameMap = {};
        selectListNameMap["Discrepancy__c"] = discrepancySelectList;
        this.executeApex(component, 'getDiscrepancyDetailsMethod', {
            "myid" :component.get("v.loanid"),'objectFieldJSON':JSON.stringify(selectListNameMap),
            "controllingField" :'OTPDiscrepancyCategory__c','dependentField':'OTPDiscrepancyDocuments__c'
        },
                         function (error, result) {
                             if (!error && result) {
                                 var data = JSON.parse(result);
                                 var picklistFields = data.picklistData;
                                 var discrepancyPickFlds = picklistFields["Discrepancy__c"];
                               
                                 component.set("v.Status__c",discrepancyPickFlds["Status__c"]); 
                                 
                             }
                             console.log('inside loaddata');
                              this.getSubPicklist(component,event);
                             console.log('before spinner method call');
                              this.showhidespinner(component,event,false);
								console.log('after spinner method call');
                         });
        
        
        
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        console.log('calling method' + method);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                console.log('error');
                console.log(response.getError());
                
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                console.log('calling method failed ' + method);
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
     getSubPicklist: function(component, event) {
       
        var Categoty=component.find('category').get('v.value');
        console.log("inside depenedent pk"+Categoty);
        var selectDependentOptions = [];
        if($A.util.isEmpty(Categoty)){
            console.log("inside depenedent pk1"+Categoty);
           component.find("documents").set("v.disabled", true); 
          component.set("v.OTPDiscrepancyDocumentlist",null);
        }
        else{
        if(Categoty == 'Document')
        {
            selectDependentOptions.push({ value:"Residence address proof", label:"Residence address proof" });
			selectDependentOptions.push({ value:"House ownership proof", label:"House ownership proof" });
			selectDependentOptions.push({ value:"Permanent address proof", label:"Permanent address proof" });
            selectDependentOptions.push({ value:"Updated banking", label:"Updated banking" });
            selectDependentOptions.push({ value:"Non Sal Bank A/C Statement", label:"Non Sal Bank A/C Statement" });
            selectDependentOptions.push({ value:"Salary Slip", label:"Salary Slip" });
            selectDependentOptions.push({ value:"CTC Letter/Increment Letter/Salary Certificate", label:"CTC Letter/Increment Letter/Salary Certificate" });
            selectDependentOptions.push({ value:"Office ID card", label:"Office ID card" });
            selectDependentOptions.push({ value:"Proof of Total Work Experience", label:"Proof of Total Work Experience" });
            selectDependentOptions.push({ value:"HR confirmation", label:"HR confirmation" });
            selectDependentOptions.push({ value:"Transfer Letter", label:"Transfer Letter" });
            selectDependentOptions.push({ value:"Retirement proof", label:"Retirement proof" });
            selectDependentOptions.push({ value:"Rental income proof", label:"Rental income proof" });
            selectDependentOptions.push({ value:"Repayment Track/SOA/Receipt", label:"Repayment Track/SOA/Receipt" });
            selectDependentOptions.push({ value:"Foreclosure letter", label:"Foreclosure letter" });
            selectDependentOptions.push({ value:"Credit card statement", label:"Credit card statement" });
            selectDependentOptions.push({ value:"Sanction Letter", label:"Sanction Letter" });
            selectDependentOptions.push({ value:"Date of possession proof - under construction", label:"Date of possession proof - under construction" });
        }
        else if(Categoty == 'Banking')
        {
            selectDependentOptions.push({ value:"Updated banking", label:"Updated banking" });
            selectDependentOptions.push({ value:"Non Sal Bank A/C Statement", label:"Non Sal Bank A/C Statement" });
          
        }
        else if(Categoty == 'Eligibility')
        {
            selectDependentOptions.push({ value:"Addition of Non Financial Co Applicant", label:"Addition of Non Financial Co Applicant"});
            selectDependentOptions.push({ value:"Addition of new Co-applicant", label:"Addition of new Co-applicant" });
            selectDependentOptions.push({ value:"Rental income proof", label:"Rental income proof" });
           
        }
        else if(Categoty == 'Employment')
        {
            selectDependentOptions.push({ value:"Salary Slip", label:"Salary Slip" });
            selectDependentOptions.push({ value:"CTC Letter/Increment Letter/Salary Certificate", label:"CTC Letter/Increment Letter/Salary Certificate" });
            selectDependentOptions.push({ value:"Office ID card", label:"Office ID card" });
            selectDependentOptions.push({ value:"Office Email Confirmation", label:"Office Email Confirmation" });
            selectDependentOptions.push({ value:"Proof of Total Work Experience", label:"Proof of Total Work Experience" });
            selectDependentOptions.push({ value:"HR confirmation", label:"HR confirmation" });
            selectDependentOptions.push({ value:"Transfer Letter", label:"Transfer Letter" });
            selectDependentOptions.push({ value:"Retirement proof", label:"Retirement proof" });
			
        }
        else if(Categoty == 'Policy')
        {
            selectDependentOptions.push({ value:"Date of possession proof - under construction", label:"Date of possession proof - under construction" });
            selectDependentOptions.push({ value:"Cross linking of existing LAN", label:"Cross linking of existing LAN" });
            selectDependentOptions.push({ value:"EMI date to be 2nd", label:"EMI date to be 2nd" });
            selectDependentOptions.push({ value:"EMI date to be 5th", label:"EMI date to be 5th" });
			selectDependentOptions.push({ value:"EMI date to be 10th", label:"EMI date to be 10th" });
        }
        else if(Categoty == 'Verification')
        {
            selectDependentOptions.push({ value:"Residence Verification", label:"Residence Verification" });
            selectDependentOptions.push({ value:"Office Verification", label:"Office Verification" });
            selectDependentOptions.push({ value:"Bank Statement verification", label:"Bank Statement verification" });
            selectDependentOptions.push({ value:"Office TVR", label:"Office TVR" });
            selectDependentOptions.push({ value:"FCU report", label:"FCU report" });
            selectDependentOptions.push({ value:"Physical PD", label:"Physical PD" });
            selectDependentOptions.push({ value:"Pan check", label:"Pan check" });
            selectDependentOptions.push({ value:"Providend Fund Check", label:"Providend Fund Check" });
            selectDependentOptions.push({ value:"Permanent Address Verification", label:"Permanent Address Verification" });
           
        }
		else if(Categoty == 'Loan/Track Documents')
        {
            selectDependentOptions.push({ value:"Repayment Track/SOA/Reciept", label:"Repayment Track/SOA/Reciept" });
            selectDependentOptions.push({ value:"Foreclosure letter", label:"Foreclosure letter" });
            selectDependentOptions.push({ value:"Credit card statement", label:"Credit card statement" });
            selectDependentOptions.push({ value:"Sanction Letter", label:"Sanction Letter" });
			selectDependentOptions.push({ value:"External Cibil check", label:"External Cibil check" });
        }
		component.set("v.OTPDiscrepancyDocumentlist",selectDependentOptions);
        component.find("documents").set("v.disabled", false);   
        }
        this.showhidespinner(component,event,false);

    },
})