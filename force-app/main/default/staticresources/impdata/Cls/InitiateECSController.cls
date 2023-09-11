public without sharing class InitiateECSController {
    
    @AuraEnabled
	public static MAP < String,String > openESCMAP {get;set;}
    
	@AuraEnabled
    public static  Map<String,String> checkCustomerRec(String opp){
        system.debug('opp - '+opp);
        String resultStr;
    	 openESCMAP = new MAP < String,String > ();
        Opportunity op = [select id,CUSTOMER__c,CUSTOMER__r.Name,PAN_Number__c from Opportunity where id = : opp];
        if(op != null && op.CUSTOMER__c != null){
            //make API call
            if (!Test.isRunningTest()) {
                system.debug('Customer id---'+op.CUSTOMER__r.Name);
                openESCMAP = BRECallout.RestAPICallForOpenECS(op.CUSTOMER__r.Name);
               //openESCMAP = BRECallout.RestAPICallForOpenECS('2960660007');
            }
            system.debug('--openESCMAP --' + openESCMAP);
            if (openESCMAP != null && openESCMAP.size() > 0) {
                if (openESCMAP.get('ecsErrMsg') == null || openESCMAP.get('ecsErrMsg') == 'null') {
                    openESCMAP.put('Called','Success');
                    return openESCMAP;
                }
                else if(openESCMAP.get('ecsErrMsg') != null){
                    openESCMAP.put('API Error','API Error');
                    return openESCMAP;
                }
                
            }
            else
            {
                return openESCMAP;
            }
        }
        else {
            openESCMAP.put('ERROR','No Customer');
        }
        return openESCMAP;
    }
    
    @AuraEnabled
    public static String createRepayRecord(String LoanId, Map<String,String> RepayMap){
        String status='SUCCESS';
        String type='';
        Opportunity op = [select id,CUSTOMER__c,CUSTOMER__r.Name,PAN_Number__c from Opportunity where id = : LoanId];  // bug 20682
        type=RepayMap.get('accTYPE');
        system.debug('type'+type);
        List<RePayment_mode_detail__c> rePayLst = new List<RePayment_mode_detail__c>();
        RePayment_mode_detail__c rePayObj = new RePayment_mode_detail__c();
        //rePayObj.Name = 'TestRepayRecord';
        rePayObj.A_C_NO__c = RepayMap.get('accNo');
        rePayObj.MICR_Code__c=Decimal.valueOf(RepayMap.get('micrCode'));
        rePayObj.IFSC_Code__c=RepayMap.get('ifscCode');
        rePayObj.Bank_Name__c=RepayMap.get('bankName');
        repayObj.Bank_Branch__c=RepayMap.get('branchName');
        
        repayObj.A_C_Type__c=RepayMap.get('accTYPE');
        rePayObj.Account_Holder_Name__c=RepayMap.get('customerName');
        rePayObj.ECS_End_Date__c= Date.valueOf(RepayMap.get('endDate'));
        rePayObj.Open_ECS_Max_Limit__c= Decimal.valueOf(RepayMap.get('balLimit'));
        rePayObj.Loan_Application__c = LoanId;
        rePayObj.Open_ECS_Facility__c = 'Existing'; //Bug:20136 set Open ECS to existing when Clone is clicked
        //Bug 20682 --S
        if(op != null && op.CUSTOMER__c != null){
        	rePayObj.Open_ECS_Ex_Customer_Id__c = Integer.valueOf(op.CUSTOMER__r.Name);   
        }
		//Bug 20682 --E
        rePayLst.add(rePayObj);
        system.debug('List:'+rePayLst[0]);
        if(rePayLst != null && rePayLst.size() > 0)
        {
            try{
                if(rePayLst[0].A_C_Type__c=='Savings'){
                    rePayLst[0].A_C_Type__c='Savings A/c';
                }
                else if(rePayLst[0].A_C_Type__c=='Current'){
                    rePayLst[0].A_C_Type__c='Current A/c';
                }
                insert rePayLst;
            }catch(Exception exp){
                system.debug('Lighting Exception Line No.-'+exp.getLineNumber()+ 'Exception Message -'+ exp.getMessage());
                status= exp.getMessage();
            }
        }
        return status;
    }
}