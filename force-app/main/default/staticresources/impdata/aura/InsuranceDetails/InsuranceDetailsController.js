({
	doInit : function(component, event, helper) {
        helper.onload(component,event);
	},
    
    onChangeApplicant : function(component, event, helper) {
        console.log('Inside onchange***');
        try{
            console.log('Applicants****'+JSON.stringify(component.get("v.appRecords")));
            var app = component.get("v.appRecords");
            //var index = event.currentTarget.dataset.index;
            var index = event.getSource().get("v.name");
            console.log('Index***'+index);
            var dpData = component.get("v.insuranceData");
            if(dpData){
                console.log('DP data****'+JSON.stringify(dpData));
                for(var i =0;i<app.length;i++){
                    console.log('applicant record name**'+app[i].ContactName__c);
                    if(dpData[index].dpRec.Applicant__r.ContactName__c == app[i].ContactName__c){
                        console.log('Inside if****');
                        dpData[index].dpRec.Applicant__c = app[i].Id;
                        dpData[index].dpRec.Applicant_type__c = app[i].Applicant_Type__c;
                        break;
                    }
                }
                component.set("v.insuranceData",dpData);
                console.log('Changed data****'+JSON.stringify(component.get("v.insuranceData")));
            }
        }
        catch(err){
            console.log('Exception in onChangeApplicant method-->'+err);
        }
    },
    addRow : function(component, event, helper) {
        console.log('Existing data****'+component.get("v.insuranceData"));
        component.set("v.isProcessing", true);
        try{
           var addNewRowaction = component.get("c.addNewRow");
            addNewRowaction.setParams({
                "depData": JSON.stringify(component.get("v.insuranceData"))
            });
            addNewRowaction.setCallback(this,function (response){
                var resp = response.getState();
                if(resp == "SUCCESS"){
                    if(!response.getReturnValue().includes('EXCEPTION')){
                        component.set("v.insuranceData", JSON.parse(response.getReturnValue()));
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
            console.log('Complete data****'+JSON.stringify(component.get("v.insuranceData"))); 
        }
         catch(err){
            console.log('Exception in addRow method-->'+err);
             component.set("v.isProcessing", false);
        }
        
    },
    deleteRow : function(component, event, helper) {
        console.log('Inside delete row***');
        component.set("v.isProcessing", true);
        var utility = component.find("toastCmp");
        try{
            var index = event.currentTarget.dataset.index; 
            console.log('Index***'+index);
            var allRowsList = component.get("v.insuranceData");
            var arr = [];
            arr.push(allRowsList[index]);
            component.set("v.recordsDeleted", arr);
            console.log('Deleted rwo***'+JSON.stringify(component.get("v.recordsDeleted")));
            allRowsList.splice(index, 1);
            var dummy = JSON.stringify(allRowsList);
            component.set("v.insuranceData", allRowsList);
            console.log('Data after deletion****'+component.get("v.insuranceData"));
            var deleteDepository = component.get("c.deleteDepositoryDetails");
            deleteDepository.setParams({deleteDepository:JSON.stringify(component.get("v.recordsDeleted")),
                                      });
            deleteDepository.setCallback(this,function(response){
                var resp = response.getState();
                if(resp == "SUCCESS"){
                    if(!response.getReturnValue().includes('EXCEPTION')){
                        utility.showToast('Success!', 'Record Deleted Successfully' , 'success');
                    }
                    else{
                        utility.showToast('Error!', 'Error in deleting record' , 'error');
                        console.log('Error in delete***'+response.getReturnValue())
                        }
                    helper.onload(component,event);
                    //component.set("v.isProcessing", false);
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
            console.log('id-->'+index);
            var completeList = component.get("v.insuranceData");
            for(var i=0;i<completeList.length;i++){
                console.log('Inside for***'+completeList[i].dpRec.Id);
                if(completeList[i].dpRec.Id == index){
                    completeList[i].isEditable = true;
                }
            }
            component.set("v.insuranceData",completeList); 
        }
        catch(err){
            console.log('Exception in deleteRow method-->'+err);
        }      
    },
    onSave : function(component, event, helper) {
        console.log('Inside onsave   '+JSON.stringify(component.get("v.insuranceData")));
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
               helper.setCompanyName(component,event);
               if(component.get("v.flow") == 'financialScreen'){
               		var saveDepository = component.get("c.saveDepositoryDetails");
                	saveDepository.setParams({depData:JSON.stringify(component.get("v.insuranceData")),
                                          	loanId: component.get("v.oppId"),
                                          	product: 'LAIP'});
                    saveDepository.setCallback(this,function(response){
                        var resp = response.getState();
                        if(resp == "SUCCESS"){
                            if(!response.getReturnValue().includes('EXCEPTION')){
                                //alert('Save successful!!!');
                                utility.showToast('Success!', 'Save successfull' , 'success');
                            }
                            else{
                                  //alert('Error in saving record');
                                  utility.showToast('Error!', 'Error in saving record' , 'error');
                                  console.log('Error in save***'+response.getReturnValue());
                                }
                            //component.set("v.isProcessing", false);
                            helper.onload(component,event);
                            //window.location.reload();
                        }
                    });
                $A.enqueueAction(saveDepository);
               }
               else if(component.get("v.flow") == 'csvScreen'){
                   var saveInsurance = component.get("c.saveInsurance");
                   saveInsurance.setParams({insuranceData:JSON.stringify(component.get("v.insuranceData")),
                                          	scripData: JSON.stringify(component.get("v.scripData"))});
                    saveInsurance.setCallback(this,function(response){
                        var resp = response.getState();
                        if(resp == "SUCCESS"){
                            if(response.getReturnValue() && !response.getReturnValue().includes('EXCEPTION')){
                                utility.showToast('Success!', 'Insurance record saved successfully.' , 'success');
                                component.set('v.insuranceData',JSON.parse(response.getReturnValue()));
                            }
                            else{
                                  utility.showToast('Error!', 'Error in saving record/loan creation' , 'error');
                                  console.log('Error in save insurance***'+response.getReturnValue());
                                }
                            helper.onload(component,event);
                        }
                        else{
                            utility.showToast('Error!', 'An error occurred.Please contact your admin' , 'error');
                            console.log('Error in server call of save insurance***'+response.getReturnValue());
                        }
                    });
                $A.enqueueAction(saveInsurance);
               }
                
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
})