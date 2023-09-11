({
    doInit : function(component, event, helper) {
        var products = [{value:"SAL", label: "SAL"},{value:"SPL", label: "SPL"},{value:"PSBL", label: "PSBL"},{value:"SHOL", label: "SHOL"},{value:"PRO", label: "PRO"},{value:"DOCTORS", label: "DOCTORS"}];
        console.log('rohit '+products[0].value);
        var td=new Date();
        var dd = td.getDate();
        var mm = td.getMonth()+1;
        console.log(mm);
        if(dd < 10){
            dd = '0' + dd;
        }
        if(mm < 10){
            mm = '0' + mm;
        }
        component.set("v.maxDate",td.getFullYear()+'-'+mm+'-'+dd);
        helper.init(component, event);
    },
    onSubmit : function(component, event, helper){
        var isNotValid = helper.validateFields(component, event, helper);
        
        if(!isNotValid){
            helper.genReport(component, event);
        }
    },
    addMinDate : function(component, event, helper){
        component.set("v.minDate", component.get("v.startDate"));
    },
    onDetailSubmit : function(component, event, helper){
        if($A.util.isEmpty(component.get("v.LAN"))){
        	var isNotValid = helper.validateFields(component, event, helper);
        	if(!isNotValid)
            	helper.generateCsv(component, event);
        }
        else{
            helper.generateCsv(component, event);
        }
    },
    keyCheck : function(component, event, helper){
        if(!$A.util.isEmpty(component.get("v.LAN"))){
            component.find("submitBtn").set("v.disabled", true);
            component.find("selectProd").set("v.disabled", true);
            component.find("stDateId").set("v.disabled", true);
            component.find("enDateId").set("v.disabled", true);
            component.find("smsType").set("v.disabled", true);
        }
        else{
            component.find("submitBtn").set("v.disabled", false);
            component.find("selectProd").set("v.disabled", false);
            component.find("stDateId").set("v.disabled", false);
            component.find("enDateId").set("v.disabled", false);
            component.find("smsType").set("v.disabled", false);
        } 
    },
    // this function is automatically called by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 	// this function is automatically called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
})