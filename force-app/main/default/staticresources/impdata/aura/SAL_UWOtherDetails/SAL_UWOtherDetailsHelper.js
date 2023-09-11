({
	getCkycDetails: function(component,event){    
        console.log('inside ckyc data');
        var oppId = component.get("v.oppId");
        var contSelectList = ["months_of_Residence__c","Residence_Type__c"];
        var appSelectList = ["Proof_of_Residence_Address_Submitted__c","Proof_of_Address_Submitted_for_Permanent__c"];
       // var accSelectList = ["Gender__c","Preferred_language__c"];    
        var selectListNameMap = {};
        selectListNameMap["Applicant__c"] = appSelectList;
        selectListNameMap["Contact"] = contSelectList;
        //selectListNameMap["Account"] = accSelectList;
        //console.log('inside ckyc data2');
        this.executeApex(component, "getCkycDetails", {"oppID":oppId, "objectFieldJSON" : JSON.stringify(selectListNameMap)}, function(error, result){
            if(!error && result){
                var data = JSON.parse(result);
                console.log('datapk'+JSON.stringify(data.objCon));
                var picklistFields = data.picklistData;
                var conPickFields = picklistFields["Contact"];
                var appPickFields = picklistFields["Applicant__c"];
                component.set("v.residenceTypeList", conPickFields["Residence_Type__c"]);
                component.set("v.monthsAtResidence", conPickFields["months_of_Residence__c"]);
                component.set("v.permDocumentList", appPickFields["Proof_of_Address_Submitted_for_Permanent__c"]);
                component.set("v.resDocumentList", appPickFields["Proof_of_Residence_Address_Submitted__c"]);
                component.set("v.oppObj", data.opp);
                component.set("v.accObj", data.accObj);
                component.set("v.contObj", data.objCon);
                component.set("v.appObj", data.applicantPrimary);
                /*City CR s*/
                if(!$A.util.isEmpty(component.get('v.contObj.Permanant_City__c'))){
                    component.set("v.validCity",true);
                    component.set("v.citySearchKeyword", component.get('v.contObj.Permanant_City__c'));
                }
                /*City CR e*/ 
                    /*if(!$A.util.isEmpty(data.poobj))
                    	component.set("v.poObj", data.poobj);
                    */
                    if(!$A.util.isEmpty(data.eKycObj))
                    	component.set("v.eKycObj", data.eKycObj);
                    /*
                    if(!$A.util.isEmpty(data.bankObj))
                    	component.set("v.bankObj", data.bankObj);
                    */
                    if(!$A.util.isEmpty(data.ekycobj) && data.ekycobj.eKYC_Gender__c!=null)
                    {
                        var gen= (data.ekycobj.eKYC_Gender__c =='M') ? "Male":"Female";
                        component.set("v.accObj.Gender__c", gen);
                    }
                    console.log('cibil pk'+data.cibilobj);
                    if(!$A.util.isEmpty(data.cibilobj))
                    	component.set("v.cibilobj", data.cibilobj);
                    
                    if(!$A.util.isEmpty(data.objCon))
                        component.set("v.permpincodebackup",data.objCon.Permanent_Pin_Code__c);
                    /*var resiAdd = '';
                    if(!$A.util.isEmpty(data.accObj))
                    {
                        if(data.accObj.Current_Residence_Address1__c != null)
                            resiAdd = resiAdd + data.accObj.Current_Residence_Address1__c;
                        if(data.accObj.Current_Residence_Address2__c != null)
                            resiAdd = resiAdd + ' ' + data.accObj.Current_Residence_Address2__c;
                        if(data.accObj.Current_Residence_Address3__c != null)
                            resiAdd = resiAdd + ' ' + data.accObj.Current_Residence_Address3__c;
                        component.set("v.resiAddress",resiAdd);
                    }*/
                	var createContact = component.get('v.contObj');
                    var permanentResiAdd = '';
                    if(!$A.util.isEmpty(data.objCon))
                    {
                        if(data.objCon.Permanant_Address_Line_1__c != null)
                            permanentResiAdd = permanentResiAdd + data.objCon.Permanant_Address_Line_1__c;
                        if(data.objCon.Permanant_Address_Line_2__c != null)
                            permanentResiAdd = permanentResiAdd + ' ' + data.objCon.Permanant_Address_Line_2__c;
                        if(data.objCon.Permanant_Address_Line_3__c != null)
                            permanentResiAdd = permanentResiAdd + ' ' + data.objCon.Permanant_Address_Line_3__c;
                        component.set("v.paramAddress",permanentResiAdd);
                        component.set("v.paramAddressbackup",permanentResiAdd);
                        
                    }
                    console.log("checkdataPer" + component.get("v.paramAddress"));
                    /*
                    var officeResiAdd = '';
                    if(!$A.util.isEmpty(data.objCon))
                    {
                        if(data.objCon.Address_Line_One__c != null)
                            officeResiAdd = officeResiAdd + data.objCon.Address_Line_One__c;
                        if(data.objCon.Address_2nd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_2nd_Line__c;
                        if(data.objCon.Address_3rd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_3rd_Line__c;
                        component.set("v.officeAddress",officeResiAdd);
                    }
                    console.log("checkdataOff" + component.get("v.officeAddress"));
					*/
                    
                    if(createContact.Residence_Type__c == 'Owned by Self/Spouse' 
                       || createContact.Residence_Type__c == 'Owned by Parent/Sibling')
                        component.set('v.isOwnedTrue',false);
                    else      
                        component.set('v.isOwnedTrue',true);
                    this.showhidespinner(component,event,false);   
                
            }
            else
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
    saveCKYCData: function(component,event){ 
        var conobj = component.get("v.contObj");
        var accObj = component.get("v.accObj");
        var result =[]; 
        if((component.get("v.contObj.Residence_Type__c") != 'Owned by Self/Spouse') && 
           (component.get("v.contObj.Residence_Type__c") != 'Owned by Parent/Sibling'))
        {                
            accObj.Permanent_Residence_Address1__c = conobj.Permanant_Address_Line_1__c;
            accObj.Permanent_Residence_Address2__c = conobj.Permanant_Address_Line_2__c;
            accObj.Permanent_Residence_Address3__c = conobj.Permanant_Address_Line_3__c;
        }
        else{
            conobj.Permanent_Pin_Code__c = accObj.PinCode__c;
            conobj.Permanant_Address_Line_1__c='';
            conobj.Permanant_Address_Line_2__c='';
            conobj.Permanant_Address_Line_3__c='';
            conobj.months_of_Residence__c='';
            accObj.Permanent_Residence_Address1__c = '';
            accObj.Permanent_Residence_Address2__c = '';
            accObj.Permanent_Residence_Address3__c = '';
            component.set("v.paramAddress",'');
        }
        
        component.set("v.contObj", conobj);
        component.set("v.accObj", accObj);
        
        var contactobj =JSON.stringify([component.get("v.contObj")]);
        var appobj =JSON.stringify([component.get("v.appObj")]);
        var accountobj =JSON.stringify([component.get("v.accObj")]);
        var oppObj =JSON.stringify([component.get("v.oppObj")]);
        console.log('oppObj is : '+oppObj);
        console.log('oppObj String: '+JSON.stringify(oppObj));
        this.executeApex(component, 'updateCKYCDetails', {
            "jsoncontactObj": contactobj,
            "jsonaccountObj":accountobj,
            "jsonappObj":appobj,
            "oppObj":oppObj,
            "copyresiaddress":component.get("v.copyresiaddressflag")
        }, function(error, result){
            console.log('in save ckyc');
            if(!error && result){
                if(!$A.util.isEmpty(result))
                {
                    var data = JSON.parse(result);
                    console.log(data);
                    if(data.status == "City Fail"){
                        this.showhidespinner(component,event,false); 
                        this.displayToastMessage(component,event,'Error','Unable to save details. City/State mapping not available for pincode.','error');
                    }
                    else{
                        component.set("v.accObj", data.accObj );
                        component.set("v.contObj", data.objCon);
                        component.set("v.appObj", data.applicantPrimary);
                        this.displayToastMessage(component,event,'Success','Data Saved successfully','success');
                        if(component.get("v.accObj.Area_Locality__r") != null){
                            component.set("v.accObj.Area_Locality__c",component.get("v.accObj.Area_Locality__r.id"));
                            //delete loan['Area_Locality__r'];
                        }
                    }
                }
                else
                    this.displayToastMessage(component,event,'Error','Failed To Save','error');
                
                this.showhidespinner(component,event,false);
            }
            else
            {
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Failed To Save','error');
            }
            
        });
        
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
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    /*City CR s*/
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    /*City CR e*/
})