({
    getPODetails: function(component, poId){        
        var poSelectList = ["TeleCalling_Desposition_Status__c","Tele_Calling_Sub_disposition__c","Lead_Source__c","Field_Disposition_1__c","Field_Desposition_Status__c","Resi_Pick_City__c","Resi_Pick_State__c"];//5881 added "city and state fields"
        var selectListNameMap = {};
        selectListNameMap["Product_Offerings__c"] = poSelectList;
        
        this.executeApex(component, "getProductOfferingData", {"productOfferingId" : poId,"objectFieldJSON":JSON.stringify(selectListNameMap)}, function(error, result){
            if(!error && result){
                var data = JSON.parse(result);
                console.log('data is : '+JSON.stringify(data));
                if(data.objPO.EMI_Amount__c != null){
                    data.objPO.EMI_Amount__c = data.objPO.EMI_Amount__c.toFixed(2);
                }
                component.set("v.productOffering", data.objPO);
                component.set("v.objLead", data.objLead);
                component.set("v.scam", data.scam);//Bug 18576
                console.log('data.objPO is :'+JSON.stringify(data.objPO));
                console.log('data.objLead is :'+JSON.stringify(data.objLead)); 
                /*Bug 18448 Start*/
                var leadObj = data.objLead; 
                if(leadObj.Employer__c != null && leadObj.Employer__r.Name != null){
                    component.set('v.isEmpDisableP',true);
                    component.set('v.selectedEmployer',leadObj.Employer__r.Name);//Bug 18576
                    console.log('selectedEmployer is :'+ component.get('v.selectedEmployer'));
                    if (leadObj.Employer__r.Name.toUpperCase() == 'COMPANY NOT LISTED' || leadObj.Employer__r.Name.toUpperCase() == 'OTHER' || leadObj.Employer__r.Name.toUpperCase() == 'OTHERS') {
                    	component.set("v.ifOther", true);
                	}
                    else{
                        component.set("v.ifOther", false);
                    }
                }
                else{
                     component.set('v.isEmpDisableP',false);
                }
                if(leadObj.Designation__c != null){
                    component.set('v.isDesDisableP',true);
                }
                else{
                     component.set('v.isDesDisableP',false);
                }
                
                /*Bug 18448 End*/
                /*Bug 18576 Start*/
                if(leadObj.Employer__c != null && leadObj.Employer__r.Company_Category__c != null){
                    component.set('v.selectedCompCat',leadObj.Employer__r.Company_Category__c);
                    console.log('selectedCompCat is :'+ component.get('v.selectedCompCat'));
                }
                	
                /*Bug 18576 End*/
                console.log(component.get("v.productOffering"));
                var mobile_number = component.get("v.mobilenumber");
                mobile_number = "tel:"+component.get("v.objLead.Customer_Mobile__c");
                component.set("v.mobilenumber",mobile_number);
                
                var picklistFields = data.picklistData;
                var poPickFlds = picklistFields["Product_Offerings__c"];
                component.set("v.teleCallingList", poPickFlds["TeleCalling_Desposition_Status__c"]);
                component.set("v.teleCallingSubList", poPickFlds["Tele_Calling_Sub_disposition__c"]);
                component.set("v.leadSourceList", poPickFlds["Lead_Source__c"]);
                component.set("v.fieldDispositionList", poPickFlds["Field_Disposition_1__c"]);
                component.set("v.fieldSubDispositionList", poPickFlds["Field_Desposition_Status__c"]);
                component.set("v.StateList",poPickFlds["Resi_Pick_State__c"]);//5881
                component.set("v.CityList",poPickFlds["Resi_Pick_City__c"]);//5881
                console.log('data is tele'+data.isTeleCaller+data.isFieldAgent);
                component.set("v.isTeleCaller", data.isTeleCaller);
                component.set("v.isFieldAgent", data.isFieldAgent);
                
                if(!$A.util.isEmpty(data.objPO) && !$A.util.isEmpty(data.objPO.Product_Offering_Converted__c))
                    component.set("v.isPOconverted",data.objPO.Product_Offering_Converted__c);
                
                if(!$A.util.isEmpty(data.theme))
                    component.set('v.nameTheme',data.theme);
                if (!$A.util.isEmpty(data.isCommunityUsr))
                    component.set('v.iscommunityUser', data.isCommunityUsr);
                
                if (!$A.util.isEmpty(data.objPO.Sourcing_Channel__r))
					component.set("v.sourceSearchKeyword", data.objPO.Sourcing_Channel__r.Name);
                else
                    component.set("v.sourceSearchKeyword",data.sourcingChannelName);
                
                if (data.objPO.Referral__r) {
					console.log('data.objPO.Referral__r.Name' + data.objPO.Referral__r.Name);
					component.set("v.referralSearchKeyword", data.objPO.Referral__r.Name);
					console.log('referralSearchKeyword' + component.get("v.referralSearchKeyword"));
				}
                var dispoCmp = component.find("landingScreen");
        		dispoCmp.getPO();
                this.showhidespinner(component,event,false);
            }
            this.showhidespinner(component,event,false);
        });
    },
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
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
    /*commented the code for bug 18566 Start*/
    backToStdRecordPage: function(component, event,poId){
        if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
            if(component.get('v.iscommunityUser'))
                window.location.href = '/Partner/'+poId;
            else
            { //Added if/else condition for Bug 17698
                if(component.get("v.recordId") != null || component.get("v.productOfferingId") != null)
                    window.location.href = '/'+poId;
                else
                    window.location.href = '/lightning/r/Product_Offerings__c/'+poId+'/view';
            }
            this.showhidespinner(component,event,false);
        }
        else if(component.get('v.nameTheme') == 'Theme4d')
        {
        	if(component.get("v.productOfferingId") != null)
                    window.location.href = '/'+poId;
                else
                    window.location.href = '/lightning/r/Product_Offerings__c/'+poId+'/view';
        }
        else if(component.get('v.nameTheme') == 'Theme4t')
            this.navigateToRecordForLEX(component, event,poId);
    },
    navigateToRecordForLEX : function (component, event,poId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        console.log('poId inside navigateToRecordForLEX : '+poId);
        navEvt.setParams({
            "recordId": poId
        });
        navEvt.fire();
        this.showhidespinner(component,event,false);
    },
    /*commented the code for bug 18566 Start*/
    showhidespinner:function(component, event, showhide){
       var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
		showhideevent.setParams({
			"isShow": showhide
			
		});
		showhideevent.fire();
	},
})