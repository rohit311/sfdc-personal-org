({
	handleRadioGroupChange : function(component, event, helper) {
		var prod = event.getSource().get("v.label");
        var premium = component.get("v.premium"); //= component.get("v.premLst")[0];
        //component.set("v.premium",premium);
        console.log('premium '+prod);
        if(prod != 'Premium Amount'){
            console.log('inside prod');
        	component.set("v.selectedProd",prod);
        }
        var totalAmt = 0;
        if(component.get("v.selectedProd") == 'CPP'){
            premium = component.find("PremId").get("v.value");
        	component.set("v.premium",premium);
            component.set("v.totalAmt",component.get("v.premium"));
        }
        else if(component.get("v.selectedProd") == 'FFR'){
            component.set("v.totalAmt",component.get("v.FFRAmt"));           
        }
        else if(component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
             console.log('inside combo');
             premium = component.find("PremId").get("v.value");
            
        	component.set("v.premium",premium);
            component.set("v.totalAmt",parseInt(component.get("v.FFRAmt"))+parseInt(component.get("v.premium")));
        }
       
        console.log(component.get("v.totalAmt"));
	},
    generateOTP : function(component, event, helper) {
        document.getElementById("otpLink").className = "disabled";
        component.set("v.Spinner",true);
        component.set("v.userConsent",true);
        helper.fetchOTP(component, event);
    },
    initCibil : function(component, event, helper) {
        var lead = component.get("v.leadObj");
        
        if(lead.One_Time_Password__c != component.get("v.otpStr")){
            helper.displayToastMessage(component,event,'Error','Incorrect OTP , Please enter correct OTP!','error');  
            document.getElementById("otpLink").classList.remove("disabled");
        }
        else{
            component.find("CibilBtnId").set("v.disabled",true);
            helper.triggerCibil(component, event);
        }
    },
    submitAndMakePaymt : function(component, event, helper) {
        
        component.find("paymentButtonId").set("v.disabled",true);
        component.set("v.ispayBtnPressed",true);
        helper.insertRecs(component, event);
        
    },
    callcibilReset : function(component, event, helper) {
        /*
        if(component.find("CibilBtnId")){           
            component.find("CibilBtnId").set("v.disabled",true);
        } commented for testing*/ 
        component.set("v.otpStr","");
        component.find("paymentButtonId").set("v.disabled",true);
        component.set("v.isCibildone",false);
        
        if(document.getElementById("otpLink"))
        	document.getElementById("otpLink").className = "";
    }, 
    resetCmp : function(component, event, helper) {
        var products = component.get("v.products");  
        
         for(var i=0;i<products.length;i++){
             products[i].status = false;
         }
        component.set("v.products",products);
        component.set("v.otpStr","");
        //component.find("paymentButtonId").set("v.disabled",true);
        component.set("v.isCibildone",false);
        component.set("v.selectedProd","Combo(CPP+FFR)");
        component.set("v.showThankyou",false);
        component.set("v.ispayBtnPressed",false);
    }
})