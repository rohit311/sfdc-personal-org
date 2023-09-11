({
    isChargesIntegration : function(component) 
    {
        var utility = component.find("toastCmp");
        this.executeApex(component,"checkIntegration",{ requestOpp : JSON.stringify(component.get("v.opp")) },
                         function(error,result){
                             var response = JSON.parse(result);

                             if(!error){
                                 component.set("v.chargesAPIIntegration",response);
                             }
                             else
                             {
                                 utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
                                 if (error[0] && error[0].message) {
                                     console.log("Error message: " +errors[0].message);
                                 }
                                 else{
                                     console.log("unknown error");
                                 }
                             }
                         });
    },
    
    executeApex: function (component, method, params, callback) 
    {
        var utility = component.find("toastCmp");
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback.call(this, null, response.getReturnValue());
            }
            else if (state === "ERROR") 
            {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                utility.showToast( "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    segregate: function(component)
    {
        var utility = component.find("toastCmp");
        component.set("v.lFnCNew",new Array());
        component.set("v.lFnCFixed",new Array());
        component.set("v.lFnCCross",new Array());
        component.set("v.lFnCIns",new Array());
        var fncList = component.get("v.lFnC");
        var oi,ii;
        var bifurMap = component.get("v.bifurMap");
        
        for(oi=0; oi<fncList.length; oi++ )
        {
            var flag = false;
            for(ii=0; ii< bifurMap.length; ii++)
            {
                /***START: 20713 - patch ***/
                if(fncList[oi].Change_Amount__c > 0)
                {
                    fncList[oi].Deducted_from_Disbursement__c = 'Yes';
                    fncList[oi].Instrument_type__c = 'Deduct from Disb';
                    fncList[oi].Status__c = 'To be collected';
                }
                /***END:   20713 - patch ***/
                var chrgId = bifurMap[ii]["CHARGEID"];
                if(chrgId.indexOf(';'+ fncList[oi].Finnone_ChargeId__c +';')  != -1)
                {
                    if(bifurMap[ii]["Charges Section"] == "Fixed")
                    {
                        var fixedList = component.get("v.lFnCFixed");
                        fixedList.push(fncList[oi]);
                        component.set("v.lFnCFixed",fixedList);
                        flag = true;
                        break;
                    }
                    else if(bifurMap[ii]["Charges Section"] == "Insurance Charges")
                    {
                        var fixedList = component.get("v.lFnCIns");
                        fixedList.push(fncList[oi]);
                        component.set("v.lFnCIns",fixedList);
                        flag = true;
                        break;
                    }
                    else
                    {
                        var fixedList = component.get("v.lFnCCross");
                        fixedList.push(fncList[oi]);
                        component.set("v.lFnCCross",fixedList);   
                        flag = true;
                        break;
                    }   
                }                
            }
            if(flag === false)
            {
                var fixedList = component.get("v.lFnCCross");
                fixedList.push(fncList[oi]);
                component.set("v.lFnCCross",fixedList);   
            }
        }        
    },
    
    getChrgBifurDetails : function(component)
    {
        var utility = component.find("toastCmp");
        this.executeApex(component,"getChargesBifur",{},
                         function(error,result){
                             var response = JSON.parse(result);
                             if(!error){
                                 component.set("v.bifurMap",response);
                             }
                             else
                             {
                                 utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
                                 if (error[0] && error[0].message) {
                                     console.log("Error message: " +errors[0].message);
                                 }
                                 else{
                                     console.log("unknown error");
                                 }
                             }
                         });
    },
    
    fetchFees : function(component, event, helper)
    {
        var utility = component.find("toastCmp");
        var oppId = component.get("v.oId");
        this.executeApex(component,"fetchFeesAndCharges",{oId : oppId},
                           function(error,result){
                               var response = JSON.parse(result);
                               if(!error){
                                   //console.log("infectch fees"+result)
                                   component.set("v.lFnC" , response);
                                   this.segregate(component);
                               }
                               else
                               {
                                   utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
                                   if (error[0] && error[0].message) {
                                       console.log("Error message: " +errors[0].message);
                                   }
                                   else{
                                       console.log("unknown error");
                                   }
                               }
                           });
    },
    
    saveFees : function(component, event, helper)
    {
        var utility = component.find("toastCmp");       
        var oppId = component.get("v.oId");
        var newList = component.get("v.lFnCNew");
        var fnCL = component.get("v.lFnC");
        fnCL=fnCL.concat(newList);
        
        var fnCList = JSON.stringify(fnCL);
        if(oppId)
        {
            helper.executeApex(component,"saveFees",{request : fnCList,
                                                     oId : oppId},
                               function(error,result){
                                   var response = JSON.parse(result);
                                   if(!error){
                                       utility.showToast('Success!', 'Saved Successfully!' , 'success');
                                       component.set("v.newFlag","false");
                                       component.set("v.lFnC",fnCL);
                                       helper.fetchFees(component, event, helper);
                                       this.segregate(component);
                                       
                                   }
                                   else
                                   {
                                       utility.showToast('Error!', 'Something went wrong. Please check you data.' , 'error');
                                       if (error[0] && error[0].message) {
                                           console.log("Error message: " +errors[0].message);
                                       }
                                       else{
                                           console.log("unknown error");
                                       }
                                   }
                               });
        }
        else
        {
            utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
        }
    }
    
})