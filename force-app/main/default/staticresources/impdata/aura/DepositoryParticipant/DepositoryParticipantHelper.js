({
	onload : function(component, event, helper) {
		try{
            console.log('Loan id****'+component.get("v.oppId"));
            var utility = component.find("toastCmp");
            var fetchLoanAction = component.get("c.fetchLoanDetails");
            fetchLoanAction.setParams({loanId:component.get("v.oppId")});
            fetchLoanAction.setCallback(this,function(response){
                var resp = response.getState();
                if(resp == "SUCCESS"){
                    if(!response.getReturnValue().includes('EXCEPTION')){
                        var respReceived = JSON.parse(response.getReturnValue());
                        //console.log('REsponse from server****'+JSON.stringify(respReceived));
                        var optsApplicant = []; optsApplicant.push({label:'--None--', value: null});
                        //var applicantMAP = [];
                        var optsDepository = []; optsDepository.push({label:'--None--', value: null});
                        component.set("v.productName",respReceived.productName);
                        //console.log('Product Name***'+component.get("v.productName"));
                        var applicantList = JSON.parse(respReceived.applicants);
                        component.set("v.appRecords",JSON.parse(respReceived.applicants));
                        var existingDPListTemp = JSON.parse(respReceived.participants);
                        var existingDPList = JSON.parse(respReceived.participants);
                        //console.log('response received*****'+respReceived.participants);
                        if(existingDPList && existingDPList.length>0){
                            component.set("v.depositoryData",existingDPList);
                        }
                        else{
                            //console.log('Inside else');
                            var RowItemList =[];
                            RowItemList.push({dpRec:{
                                'Applicant__c': '',
                                'Applicant_type__c': '',
                                'Depository__c': '',
                                'DP_Id__c':'',
                                'Client_Id__c':''},
                                'isEditable':true
                            });
                            component.set("v.depositoryData",RowItemList);
                            //component.set("v.depositoryData",defaultValues);
                        }
                        for(var i =0;i<applicantList.length;i++){
                            //console.log('Applicant type***'+applicantList[i].Applicant_Type__c);
                            //console.log('Applicant name****'+applicantList[i].ContactName__c);
                            //applicantMAP.push({value:applicantList[i].Applicant_Type__c, key:applicantList[i].Id});
                            optsApplicant.push({
                                    label : applicantList[i].ContactName__c,
                                    value : applicantList[i].ContactName__c
                            });
                        }
                        optsDepository.push({
                                    label : 'NSDL',
                                    value : 'NSDL'
                            		},
                              		{
                                    label : 'CDSL',
                                    value : 'CDSL'
                            		});
                        
                        component.set("v.applicantList",optsApplicant);
                        component.set("v.depositoryOptions",optsDepository);
                    } 
                }
                else{
                    console.log('Error in server call for fetching applicants-->'+response.getReturnValue());
                    utility.showToast('Error!', 'An error occurred. Please contact your admin' , 'error');
                }
                component.set("v.isProcessing", false);
            })
            $A.enqueueAction(fetchLoanAction);
        }
        catch(err){
            console.log('Exception in onload method-->'+err);
        }
	}
})