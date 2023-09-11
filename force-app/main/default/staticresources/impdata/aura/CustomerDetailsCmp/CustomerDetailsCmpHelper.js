({
    saveLeadHelper : function(component,event){
        
        this.populateLead(component, event);
        var self = this;
        var params = new Object();
        params["lead"] = JSON.stringify([component.get("v.leadObj")]);
        params["mobNo"] = component.get("v.mobileNo");
        params["pan"] = component.get("v.panStr");
        
        
        this.executeApex(component,"generateLead",{"paramsMap":params},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            console.log('here response.status'+response.status);
            if(!error && response.status == "SUCCESS"){  
                console.log(component.get("v.mobileNo")+'--- '+response.leadRec.Id);
                // self.
                component.set("v.leadObj",response.leadRec);
               
                //component.find("saveButtonId").set("v.disabled", true); commented CR 24406
                self.displayToastMessage(component,event,'Success','Details saved successfully !','success');
                var shareinfo = component.getEvent("shareLeadInfo");
                if(shareinfo){
                    shareinfo.setParams({"leadObj":component.get("v.leadObj"),"insObj":component.get("v.insObj")});
                    shareinfo.fire();
                }
                
            }
            else{
                self.displayToastMessage(component,event,'Error','Internal server error :'+response.message,'error');
                
            }
            
        });
        
        
    },
    populateLead : function(component, event) {
        var leadObj = new Object();
        var customer = component.get("v.customer");
        
        
        leadObj.Company = 'Others';
        leadObj.Name = customer.First_Name__c + ' '+customer.Last_Name__c;
        leadObj.LastName = customer.Last_Name__c;
        leadObj.FirstName = customer.First_Name__c;
        if(customer.DOB__c){
            leadObj.Date_of_Birth__c = customer.DOB__c.toString();
            leadObj.DOB__c = customer.DOB__c;
        }       
        leadObj.DOB_Cibil__c = customer.DOB__c;
        leadObj.Employment_Type__c = 'Salaried';
        leadObj.Applicant_Type__c = 'Primary Applicant';
        
        if(customer.Customer_ID__c){
            //leadObj.Customer_ID__c = customer.Id;
            leadObj.Customer_ID1__c = customer.Id;
        }  
        console.log('customer id '+customer.Id);
        leadObj.PAN__c = customer.PAN__c;
        leadObj.PAN_Cibil__c = customer.PAN__c;
        leadObj.Gender__c = customer.GENDER__c;
        leadObj.Permanent_Line_1_New__c = customer.Address1_New__c;
        leadObj.Address_Line_2_New__c = customer.Address2_New__c;
        
        if(customer.Address3_New__c){
        	leadObj.Permanent_Address_3__c = customer.Address3_New__c;
        }
        if(customer.Address4_New__c)
        leadObj.Permanent_Address_3__c = leadObj.Permanent_Address_3__c +' '+customer.Address4_New__c;
        
        leadObj.Per_City__c = customer.City_New__c;
        leadObj.Per_Pin_Code__c = customer.Pin_Code_New__c;
        leadObj.Per_State__c = customer.State_New__c;
        leadObj.Email = customer.Customer_Email__c;
        leadObj.Customer_Mobile__c = customer.Mobile__c;
        leadObj.Customer_Email_Id__c = customer.Customer_Email__c;
        
        component.set("v.leadObj",leadObj);
        
    }, 
    executeApex: function(component, method, params,callback){
        
        console.log('params'+JSON.stringify(params));
        console.log('method name is '+method)
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('response is'+response);
            var state = response.getState();
            console.log('state is '+state);
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()123'+response.getReturnValue());
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
     openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
     },
    fetchCityState : function(component,event){
        component.set("v.Spinner",true);
        var self = this;
        this.executeApex(component,"fetchDemogMapings",{"pinCode":component.get("v.customer.Pin_Code_New__c")+''},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            try {
                
                if(!error && response){
                    console.log('response ');
                    console.log(response);
                    if(response["State__c"] && response["City__c"]){
                        component.set("v.customer.State_New__c",response["State__c"]);
                        component.set("v.customer.City_New__c",response["City__c"]);
                        self.displayToastMessage(component,event,'Success','City & State fetched successfully!','success');
                    }else{
                        self.displayToastMessage(component,event,'Info','Unable to find city & state !','info');
                        component.set("v.customer.State_New__c","");
                        component.set("v.customer.City_New__c","");
                    }
                }
                else{
                    self.displayToastMessage(component,event,'Info','Unable to find city & state !','info');  
                    component.set("v.customer.State_New__c","");
                    component.set("v.customer.City_New__c","");
                }
            
        }
        catch(err) {
        	self.displayToastMessage(component,event,'Info','Unable to find city & state !','info');
        }
            
        });
        
    },
})