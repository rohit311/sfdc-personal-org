({
	onload : function(component, event, helper) {
		try{
            console.log('Loan id****'+component.get("v.oppId"));
            var utility = component.find("toastCmp");
            if(component.get("v.flow") == 'csvScreen' && !component.get("v.oppId")){
                if(component.get("v.insuranceData")== '' || component.get("v.insuranceData")== null){
                    console.log('No insurance data***');
                    var RowItemList =[];
                            RowItemList.push({dpRec:{
                                'Applicant__c': '',
                                'Applicant_type__c': '',
                                'Insurance_Company_Name__c': '',
                                'Policy_Number__c':'',
                                'Policy_Commencement_Date__c':'',
                                'Policy_Type':'',
                                'Remarks':''},
                                'isEditable':true
                            });
                            component.set("v.insuranceData",RowItemList);
                }
                component.set("v.isProcessing", false);
            }
            else{
            var fetchLoanAction = component.get("c.fetchLoanDetails");
            fetchLoanAction.setParams({loanId:component.get("v.oppId")});
            fetchLoanAction.setCallback(this,function(response){
                var resp = response.getState();
                if(resp == "SUCCESS"){
                    /*if(!response.getReturnValue()){
                        var RowItemList =[];
                            var applicant = component.get("v.appRecords");
                            RowItemList.push({
                                'Applicant__c': '',
                                'Applicant_type__c': '',
                                'Insurance_Company_Name__c': '',
                                'Policy_Number__c':'',
                                'Policy_Commencement_Date__c':'',
                                'Policy_Type':'',
                                'Remarks':'',
                                'isEditable':true
                            });
                            component.set("v.insuranceData",RowItemList);
                            this.setCompanyName(component,event,helper);
                    }*/
                    if(!response.getReturnValue().includes('EXCEPTION')){
                        var respReceived = JSON.parse(response.getReturnValue());
                        console.log('REsponse from server****'+JSON.stringify(respReceived));
                        var optsApplicant = []; optsApplicant.push({label:'--None--', value: null});
                        //var applicantMAP = [];
                        //var optsInsurance = []; optsInsurance.push({label:'--None--', value: null});
                        var applicantList = JSON.parse(respReceived.applicants);
                        component.set("v.appRecords",JSON.parse(respReceived.applicants));

                        var existingDPList = JSON.parse(respReceived.insurance);
                        console.log('response received*****'+respReceived.insurance);
                        if(existingDPList && existingDPList.length>0){
                            component.set("v.insuranceData",existingDPList);
                        }
                        else{
                            console.log('Inside else');
                            var RowItemList =[];
                            var applicant = component.get("v.appRecords");
                            RowItemList.push({dpRec:{
                                'Applicant__c': '',
                                'Applicant_type__c': '',
                                'Insurance_Company_Name__c': '',
                                'Policy_Number__c':'',
                                'Policy_Commencement_Date__c':'',
                                'Policy_Type':'',
                                'Remarks':''},
                                'isEditable':true
                            });
                            component.set("v.insuranceData",RowItemList);
                            this.setCompanyName(component,event,helper);
                            //component.set("v.insuranceData",defaultValues);
                        }
                        if(applicantList!=null && applicantList.length>0){
                            for(var i =0;i<applicantList.length;i++){
                                console.log('Applicant type***'+applicantList[i].Applicant_Type__c);
                                console.log('Applicant name****'+applicantList[i].ContactName__c);
                                //applicantMAP.push({value:applicantList[i].Applicant_Type__c, key:applicantList[i].Id});
                                optsApplicant.push({
                                        label : applicantList[i].ContactName__c,
                                        value : applicantList[i].ContactName__c
                                });
                            }
                        }
                       
                        console.log('Insurance list wrapper****'+JSON.stringify(component.get("v.insuranceData")));
                        console.log('Applicant list****'+optsApplicant);
                        component.set("v.applicantList",optsApplicant);
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
        }
        catch(err){
            console.log('Exception in onload method-->'+err);
        }
	},
    
    setCompanyName : function(component,event,helper) {
		try{
            console.log('Inside setCompanyName');
            var applicant = component.get("v.appRecords");
            console.log('Applicants****'+applicant);
            var data = component.get("v.insuranceData");
            if(data){
                for(var i=0; i<data.length; i++){
                    console.log('Inside for***');
                    if(component.get("v.flow") == 'financialScreen')
                    	data[i].dpRec.Insurance_Company_Name__c = applicant[0].Loan_Application__r.Sour_Channel_Name__c;
                    if(component.get("v.flow") == 'csvScreen')
                        data[i].dpRec.Insurance_Company_Name__c = component.get("v.channel");
            	}
            console.log('Updated data***'+JSON.stringify(data));
            component.set("v.insuranceData",data);
            }
        }catch(e){
            console.log('Error in company name****'+e);
        }
    },
})