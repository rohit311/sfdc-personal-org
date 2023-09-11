({
	doInit : function(component, event, helper) {
        console.log('Do init***');
        helper.onload(component,event);
	},
    
    onChangeApplicant : function(component, event, helper) {
        console.log('Inside onchange***');
        try{
            //console.log('Applicants****'+JSON.stringify(component.get("v.appRecords")));
            var app = component.get("v.appRecords");
            //var index = event.currentTarget.dataset.index;
            var index = event.getSource().get("v.name"); 
            //console.log('Index***'+index);
            var dpData = component.get("v.depositoryData");
            if(dpData){
                //console.log('DP data****'+JSON.stringify(dpData));
                for(var i =0;i<app.length;i++){
                    //console.log('applicant record name**'+app[i].ContactName__c);
                    if(dpData[index].dpRec.Applicant__r.ContactName__c == app[i].ContactName__c){
                        //console.log('Inside if****');
                        dpData[index].dpRec.Applicant__c = app[i].Id;
                        dpData[index].dpRec.Applicant_type__c = app[i].Applicant_Type__c;
                        break;
                    }
                }
                component.set("v.depositoryData",dpData);
                //console.log('Changed data****'+JSON.stringify(component.get("v.depositoryData")));
            }
        }
        catch(err){
            console.log('Exception in onChangeApplicant method-->'+err);
        }
    },
    addRow : function(component, event, helper) {
        //console.log('Existing data****'+component.get("v.depositoryData"));
        component.set("v.isProcessing", true);
        try{
           var addNewRowaction = component.get("c.addNewRow");
            addNewRowaction.setParams({
                "depData": JSON.stringify(component.get("v.depositoryData"))
            });
            addNewRowaction.setCallback(this,function (response){
                var resp = response.getState();
                if(resp == "SUCCESS"){
                    if(response.getReturnValue() && !response.getReturnValue().includes('EXCEPTION')){
                        component.set("v.depositoryData", JSON.parse(response.getReturnValue()));
                    }
                    else{
                        console.log('Exception in add row***'+response.getReturnValue());
                    }
                }
                else{
                   console.log('Exception in add row server call***'+response.getReturnValue()); 
                }
                component.set("v.isProcessing", false);
            }); 
            $A.enqueueAction(addNewRowaction);
            console.log('Complete data****'+JSON.stringify(component.get("v.depositoryData"))); 
        }
         catch(err){
            console.log('Exception in addRow method-->'+err);
             component.set("v.isProcessing", false);
        }
        
    },
    deleteRow : function(component, event, helper) {
        //console.log('Inside delete row***');
        component.set("v.isProcessing", true);
        var utility = component.find("toastCmp");
        try{
            var index = event.currentTarget.dataset.index; 
            //console.log('Index***'+index);
            var allRowsList = component.get("v.depositoryData");
            var arr = [];
            arr.push(allRowsList[index]);
            component.set("v.recordsDeleted", arr);
            //console.log('Deleted rwo***'+JSON.stringify(component.get("v.recordsDeleted")));
            allRowsList.splice(index, 1);
            var dummy = JSON.stringify(allRowsList);
            console.log('Data after deletion****'+component.get("v.depositoryData"));
            var deleteDepository = component.get("c.deleteDepositoryDetails");
            deleteDepository.setParams({deleteDepository:JSON.stringify(component.get("v.recordsDeleted")),
                                      });
            deleteDepository.setCallback(this,function(response){
                var resp = response.getState();
                if(resp == "SUCCESS"){
                    if(!response.getReturnValue().includes('EXCEPTION')){
                        utility.showToast('Success!', 'Record Deleted Successfully' , 'success');
                        component.set("v.depositoryData", allRowsList);
                    }
                    else{
                        utility.showToast('Error!', 'Error in deleting record' , 'error');
                        console.log('Error in delete***'+response.getReturnValue())
                        }
                    helper.onload(component,event);
                }
                component.set("v.isProcessing", false);
            });
        $A.enqueueAction(deleteDepository);
        }
         catch(err){
            console.log('Exception in deleteRow method-->'+err);
             component.set("v.isProcessing", false);
        }
        
    },
    editRow : function(component, event, helper) {
        console.log('Inside edit');
        try{
           var index = event.currentTarget.id;
            //console.log('id-->'+index);
            var completeList = component.get("v.depositoryData");
            for(var i=0;i<completeList.length;i++){
                //console.log('Inside for***'+completeList[i].dpRec.Id);
                if(completeList[i].dpRec.Id == index){
                    completeList[i].isEditable = true;
                }
            }
            component.set("v.depositoryData",completeList); 
        }
        catch(err){
            console.log('Exception in deleteRow method-->'+err);
        }      
    },
    onSave : function(component, event, helper) {
        //console.log('Inside onsave   '+JSON.stringify(component.get("v.depositoryData")));
        component.set("v.isProcessing", true);
        var error = false;
        var utility = component.find("toastCmp");
        var list = ["DP_Name"];
        for (var i = 0; i < list.length; i++) {
            if (component.find(list[i]) && component.find(list[i]).length > 1)
            {
                var rows = component.find(list[i]);
                for(var j=0;j<rows.length;j++){
                    if(!rows[j].get("v.validity").valid){
                        console.log('Inside each row if***');
                        error=true;
                    }
                }
                console.log('Error flag***'+error);
            }
        }
        if(!error){
           try{
               var saveDepository = component.get("c.saveDepositoryDetails");
                saveDepository.setParams({depData:JSON.stringify(component.get("v.depositoryData")),
                                          loanId: component.get("v.oppId"),
                                          product: 'FAS'});
                saveDepository.setCallback(this,function(response){
                    var resp = response.getState();
                    if(resp == "SUCCESS"){
                        if(response.getReturnValue() && !response.getReturnValue().includes('EXCEPTION')){
                            utility.showToast('Success!', 'Save successfull' , 'success');
                        }
                        else{
                              utility.showToast('Error!', 'Error in saving record' , 'error');
                              console.log('Error in save***'+response.getReturnValue());
                            }
                        helper.onload(component,event);
                    }
                });
            $A.enqueueAction(saveDepository); 
        	}
            catch(err){
                console.log('Exception in onSave method-->'+err);
                component.set("v.isProcessing", false);
            } 
        }
        else{
            utility.showToast('Error!', 'Please fill all mandatory fields' , 'error');
            component.set("v.isProcessing", false);
        }
         
    },
    
    validateValue : function(component, event, helper) {
        var DPvalue = event.currentTarget.dataset.record;
        var DPId = event.currentTarget.dataset.id;
        //console.log('data Value = '+ DPvalue);
        //console.log('DP Id ='+DPId);
        if(DPvalue && DPvalue.length >7){
        	var cId;
        	if(DPId){
            	cId =  DPId.split(':');
        	}
            var clientId = cId[0]+':ClientID';
            //console.log('Client id***'+clientId);
            var temp = component.find("ClientID");
            //console.log('Element found***'+temp);
            if(cId[0]>0){
               for(var i=0;i<temp.length;i++){
                   if(i == cId[0]){
                        temp[i].focus();
                        break;
                   }
               } 
            }
            else{
                //console.log('Inside else');
                temp.focus();
            }
            
        }
    }
})