public class OpportunityDetailsOperator {
    
    @AuraEnabled
    public static String validateRepayObj(String sRepay){
        String status = '';
        RePayment_mode_detail__c rePaymentRecord =(RePayment_mode_detail__c) JSON.deserialize(sRepay, RePayment_mode_detail__c.class);
        System.debug('in validateRepayObj : ' + rePaymentRecord);
        try
        {
            System.debug('in Validate repay object server function.');
            List<String> sErr = isEmandateEnabled(rePaymentRecord);
            if( sErr != NULL && sErr.size() > 0 )
            {
                for(String s : sErr){
                    if(!String.isBlank(s))
                    {
                        status += s + '\n';    
                    }
                }                    
            }
            else{
                verifyEmandateEnabled(rePaymentRecord.IFSC_Code__c);
                status = 'SUCCESS';
            }
        }catch(Exception e){
            status ='IFSC is not enabled for current branch.';
        }
        return status;
    }
    
    @AuraEnabled
    public static String opportunityExists(Id opportunityId){
        RePayment_mode_detail__c rePaymentRecord = null;
        String status ='' ;
        try {
            rePaymentRecord = [ SELECT Id,Account_Holder_Name__c,A_C_NO__c,ECS_End_Date__c,ECS_Start_Date__c,IFSC_Code__c,
                               Loan_Application__r.Account.Mobile__c,Loan_Application__r.Account.Current_Email_Id__c,
                               Loan_Application__r.Product__c, UMRN__c, Open_ECS_Ex_Customer_Id__c,Open_ECS_Max_Limit__c 
                               FROM RePayment_mode_detail__c 
                               WHERE Repayment_Mode__c = 'SI' AND Loan_Application__c = :opportunityId //Bug 19726: Removed ECS from Where clause as Emandate is to be done for SI only
                               ORDER BY LastModifiedDate DESC 
                               LIMIT 1 ];

            if(rePaymentRecord != NULL && rePaymentRecord.UMRN__c != NULL && rePaymentRecord.UMRN__c != '' ){
                status = 'DISABLED:E-Mandate is already availed!';
            }
            else if(false)
            {
                //product condition need to check!
                status = 'E-Mandate facility is not availble for this Loan product!';
            }
            else{
                List<String> sErr = isEmandateEnabled(rePaymentRecord);
                if( sErr != NULL && sErr.size() > 0 )
                {
                    for(String s : sErr){
                        if(String.isBlank(s))
                        {
                            status += s + '\n';    
                        }
                        
                    }                    
                }
                else{
                    verifyEmandateEnabled(rePaymentRecord.IFSC_Code__c);
                    status = 'SUCCESS:Opportunity-' + rePaymentRecord.Loan_Application__c + ':RePayment_mode_detail__c-' + rePaymentRecord.Id;
                }
            }
        } 
        catch (QueryException e) {
            status = 'No records exists for the Id - ' + opportunityId;
        } catch(InvalidValuesException e) {
            status =  'Opportunity Id:' + rePaymentRecord.Loan_Application__c + ' RePayment_mode_detail__c Id:' + rePaymentRecord.Id + 
                '\nFollowing fields have either null or empty value: ' + e;
        } catch(IFSCException e) {
            status = 'Emandate Not Enabled. Opportunity Id:' + rePaymentRecord.Loan_Application__c + ' RePayment_mode_detail__c Id:' + rePaymentRecord.Id;
        } catch(Exception e) {
            status = 'Could not process your request!  ' + e;
        }
        system.debug('Status******'+status);
        return status;
    }
    
    
    
    /********************************************
     * Purpose: If E-mandate product is enabled, 
     *          then return Serialized version of 
     *           Repayment_mode_Details__c object
     *          Else, send NULL deliberately!
     * *****************************************/
    @AuraEnabled
    public static String getRepayObject(Id oppId){
        List<RePayment_mode_detail__c> rePaymentRecord = [ SELECT Id,Account_Holder_Name__c,A_C_NO__c,ECS_End_Date__c,ECS_Start_Date__c,IFSC_Code__c,
                               Loan_Application__r.Account.Mobile__c,Loan_Application__r.Account.Current_Email_Id__c,
                               Loan_Application__r.Product__c, UMRN__c, Open_ECS_Ex_Customer_Id__c,Open_ECS_Max_Limit__c 
                               FROM RePayment_mode_detail__c 
                               WHERE Repayment_Mode__c = 'SI' AND Loan_Application__c = :oppId //Bug 19726: Removed ECS from Where clause as Emandate is to be done for SI only
                               ORDER BY LastModifiedDate DESC 
                               LIMIT 1 ];
        
        if(rePaymentRecord != NULL && rePaymentRecord.size() > 0  ){
            if( isProductEmandateEnabled(rePaymentRecord[0].Loan_Application__r.Product__c) ){
                return JSON.serialize(rePaymentRecord[0]);
            }
            else{
                return NULL;
            }
        }
        return NULL;
    }
    
    public static Boolean isProductEmandateEnabled(String product)
    {
        if(product == NULL )    return false;

        List<String> str = Label.EmandateProducts.split(';');
        if(str.contains(product) ){
            return true;
        }
        else{
            return false;
        }
    }
    
    
    public static List<String> isEmandateEnabled(RePayment_mode_detail__c rObj)
    {
        List<String> status = NULL ;
        if(rObj != NULL)
        {
            status  = new List<String>();
            if(rObj.ECS_Start_Date__c == NULL){
                status.add('Error: EMI start date cannot be empty. It must be today’s date and less than EMI end date(Past dates are not allowed).'); 
            }
            else if(rObj.ECS_Start_Date__c != NULL && rObj.ECS_Start_Date__c < Date.today() )
            {
                status.add('Error: EMI start date must be today’s date and less than EMI end date(Past dates are not allowed).'); 
            }
            
            if(rObj.ECS_End_Date__c == NULL ){
                 status.add('Error: EMI end date cannot be empty. It should be Todays date or future date, but greater than EMI start date or Both can be equal.');
            }
            
            else if(rObj.ECS_End_Date__c != NULL && (rObj.ECS_End_Date__c < rObj.ECS_Start_Date__c || rObj.ECS_End_Date__c < Date.today() ) )
            {
                status.add('EMI enddate should be Todays date or future date, but greater than EMI start date or Both can be equal.');
            }

            Boolean flag = false; 
            if(rObj.Loan_Application__r.Account.Mobile__c == null) 
            {
                System.debug('Mobile__c');
                flag = true; 
            }
            //Bug: 20171 Start (Garima) -Made Current_Email_Id__c non mandatory for Initiate E-mandate
            /*else if(String.isBlank(rObj.Loan_Application__r.Account.Current_Email_Id__c) ) 
            {
                System.debug('Current_Email_Id__c');
                flag = true;
            } */
            //Bug: 20171 End
            else if (String.isBlank(rObj.Account_Holder_Name__c)) 
            {
                System.debug('Account_Holder_Name__c');
                flag = true;
            }
            else if( String.isBlank(rObj.A_C_NO__c) ){
                System.debug('A_C_NO__c'+rObj.A_C_NO__c);
                flag = true;
            }
            //Bug: 19726 Start (Garima) -Made Open_ECS_Ex_Customer_Id__c non mandatory for Initiate E-mandate
            /*else if( rObj.Open_ECS_Ex_Customer_Id__c == NULL  ){
                System.debug('Open_ECS_Ex_Customer_Id__c');
                flag = true;
            }*/
            //Bug: 19726 End (Garima)
            else if( String.isBlank(rObj.IFSC_Code__c) ){
                System.debug('IFSC_Code__c');
                flag = true;
            }
            else if( rObj.Open_ECS_Max_Limit__c == NULL ){
                System.debug('Open_ECS_Max_Limit__c');
                flag = true;
            }

            if(flag){
                //Bug: 19726(Garima) - Removed Open ECS Ex Customer Id from error message since it is non mandatory
                status.add('Please fill mandatory fields. Open Account Holder Name,Mobile No.(Account), Open ECS Max Limit, ECS Start Date, ECS End Date, IFSC Code, A/C NO. are mandatory for E-Mandate');
            }
        }
        else{
            status = NULL;
        }

        return status;
    }

    @testvisible
    private static void verifyEmandateEnabled(String ifscCode) {
        try {
            IFSC_Master__c record = [ SELECT Id FROM IFSC_Master__c WHERE IFSC_Code__c = :ifscCode AND Is_Emandate_Enabled__c = true ];
        } catch(QueryException e) {
            throw new IFSCException();
        }
    }
    
    //Bug:19726 (Start) Method for API call to generate bitly
    @AuraEnabled
    public static String generateBitlyFunction(Id oId, Id repayId){
        String retunValue = '';
        System.debug('Repay record Id : ' + repayId);

		String bitlyGenerated = '';
        generateBitly.WS_GenericBitlySoap genBitly = new generateBitly.WS_GenericBitlySoap();
        //String urlCreated = 'https://bflcrm.my.salesforce.com/'+repayId;
        
        //String urlCreated = Label.URL_for_Emandate_Bitly+CommonUtility.encryptURLParam(repayId);//--changed for updated bitly req
        
        String urlCreated = System.Label.E_Mandate_Site_Url +CommonUtility.encryptURLParam(repayId);
        
        system.debug('url created******'+urlCreated);
        
        //==updated module Ids --:: bitlyGenerated = genBitly.generateBitly(2,5,'123455',urlCreated,'','','','','','','','','','','','','','','','','','','','','','','','','','','','');
        
		//Rohit added test check
        if(!Test.isRunningTest())
			bitlyGenerated = genBitly.generateBitly(5,6,'',urlCreated,'','','','','','','','','','','','','','','','','','','','','','','','','','','','');

		else
            bitlyGenerated = 'https:etgsegs.dsgsdegsdgds';
        //bitlyGenerated = 'https://bfin.in/?6XBC9P2S';
        if(String.isNotBlank(bitlyGenerated)){
            if(bitlyGenerated.contains('https:')){
               retunValue = 'SUCCESS'+';'+bitlyGenerated; 
            }
            else{
                retunValue = 'ERROR';
            }
        }
        else{
           retunValue = 'ERROR'; 
        }
        system.debug('Bitly generated******'+bitlyGenerated);
        return retunValue;
    }
    //Bug:19726 (End)

    @AuraEnabled
    public static String MandateInitiation(Id oId, Id repayId, String generatedBitly){ // Bug:19726 Added generatedBitly in argument
        String retunValue = '';
        System.debug('Opportunity Id  : ' + oId);
		System.debug('Bitly generated : '+generatedBitly);
        Opportunity o = new Opportunity();
        List<Opportunity>  lLoan = [SELECT 
                                            id, loan_application_number__c, Account.Mobile__c,Product__c // Bug:19726 Added Product in SOQL
                                    FROM 
                                            Opportunity
                                    WHERE 
                                        id =: oId
                                    ];

        if(lLoan != NULL && lLoan.size() > 0 ){
            o =  lLoan[0];
        }
        /*added by swapnil 20939 s*/
        try{
            SALMobilityOppCntrl_V2.gensendsms(lLoan[0],null,'On LA E-Mandate');
         
        }catch(EXception e){
            System.debug('Error occrred during sms or email sendging '+e.getMessage()+' on line '+e.getLineNumber());
        }   
        /*added by swapnil 20939 e*/
        // Bug:19726 (Start) send sms using responsys as well as ValueFirst
        List<Rack_Rate__c> rrMaster = new List<Rack_Rate__c>();
        Rack_Rate__c rrRec = new Rack_Rate__c(); //20939 RCU s
        rrMaster = [SELECT name,Products__c,SMS_Text__c,Additional_SMS_Text__c,Campaign_Name__c,ReceipientsAPINames__c,
                    resendFlag__c,SMS_Type__c,Dynamic_Parameters__c,isPriority__c,Event__c,Used_For__c
                    from Rack_Rate__c where Campaign_Name__c = 'A_EMANDATE_BITLY_SAL' OR Campaign_Name__c  = 'A_E_MANDATE']; //20939 added OR
        String smsText ='';
        /*20939 s*/
        if(rrMaster!=null && rrMaster.size()>0){
           	for(Rack_Rate__c rr : rrMaster){
			                if((o.Product__c == 'SAL' || o.Product__c == 'SPL') && rr.Campaign_Name__c == 'A_E_MANDATE') 
			                    rrRec = rr;
			                else if(o.Product__c != 'SAL' && o.Product__c != 'SPL' && rr.Campaign_Name__c == 'A_EMANDATE_BITLY_SAL')
			                    rrRec = rr;
			                
			            }
        }
         /*20939 e*/
        //20939 changed rrMaster[0] to rrRec below
          smsText = rrRec.SMS_Text__c;
        List<String> listmsg=new List<String>(); 
        List<String> contactNum=new List<String>(); 
        Set<String> prodList = new Set<String>();
        List<SMS_Sent__c> lSms = new List<SMS_Sent__c>();
        SMS_Sent__c oSmsSent = new SMS_Sent__c();
        String productList = '';
        if(AtosParameters__c.getValues('ResponsysAPI') != null && AtosParameters__c.getValues('ResponsysAPI').Product__c != null){
            productList = AtosParameters__c.getValues('ResponsysAPI').Product__c;
        }
        prodList.addAll(productList.split(';'));
        
        oSmsSent.Name = 'EMandate';
        oSmsSent.SMS_Type__c = 'EMandate';
        oSmsSent.LoanApplication__c = o.Id;
        oSmsSent.Event__c = 'A_EMANDATE_BITLY_SAL';
        String mNumber = o.Account.Mobile__c+'';
        oSmsSent.SMS_Sent_Number__c  = mNumber.replace(',', '') ;
        oSmsSent.SMS_Receiver__c = 'Customer';
        System.debug('this mobile number will be used :'+  o.Account.Mobile__c );
        
        if(prodList!=null && prodList.size()>0 && rrMaster!=null && rrMaster.size()>0){ // To check that rack rate record is present and null check for prodlist
           if(prodList.contains(o.Product__c) && rrMaster[0].Used_For__c == 'Responsys'){
               system.debug('Inside responsys****');
                //20939 added if else
                if(o.Product__c == 'SAL' || o.Product__c == 'SPL') 
                    oSmsSent.SMS_Parameters__c = '{"P_LAN":"'+ o.loan_application_number__c +'","P_BITLY": "'+ generatedBitly + '"}';
                else
                    oSmsSent.SMS_Parameters__c = '{"P_LAN":"'+ o.loan_application_number__c +'","P_BILITY": "'+ generatedBitly + '"}';
                lSMS.add(oSmsSent);
           
                //NOTE :No need of inserting the SMS sent here. The further code will upsert the code with status
                sendsms.sendResponsysSMS(lSms);       
                /**** code for sending bitly for Emandate ***/
        	} 
            else{ // to send sms vis valuefirst
                system.debug('Inside value first****');
                if(smsText!= null){
                    if(generatedBitly != null){
                       smsText = smsText.replace('**bitly**',generatedBitly); 
                    }
                    if(o.Id != null){
                       smsText = smsText.replace('**LAN**', o.loan_application_number__c); 
                    }
                }
                /*20939 s*/
                if(rrRec.Additional_SMS_Text__c != null)
                    smsText += rrRec.Additional_SMS_Text__c;
                /*20939 e*/
                listmsg.add(smsText);
                contactNum.add(String.valueof(mNumber.replace(',', '')));
                try{
                   sendsms.sendBulkSMS(listmsg,contactNum);
                   if(smsText.length() >= 255){
                      oSmsSent.SMS_Text_Sent__c = smsText.substring(0,255);
                      oSmsSent.Additional_SMS_Text_Sent__c = smsText.substring(255,smsText.length());
                   }
                    else{
                       oSmsSent.SMS_Text_Sent__c = smsText; 
                    }
                   oSmsSent.Status__c = 'Sent';
                   oSmsSent.SMS_Sent__c = true;
                   oSmsSent.SMS_Sent_Time__c = system.now();
                    //oSmsSent.SMS_Text_Sent__c = smsText; //20939 commented
                }
                catch(Exception e){
                    System.debug('Exception send bulk sms -->'+e.getMessage());
                    oSmsSent.Status__c = 'Failed';
                }
                try{
                    upsert oSmsSent;
                }
                catch(Exception e){
                    System.debug('Exception updating sms details -->'+e.getMessage());
                }
                
            }
        }
       	//Bug:19726 End
        if(oSmsSent.Status__c == 'Sent'){
            try{
                //Repayment record update: 
                RePayment_mode_detail__c oRmd = new RePayment_mode_detail__c(Id =repayId);
                oRmd.Mandate_Process_Stage__c = 'In Progress';
                update oRmd;
            }
            catch(Exception e ){
                System.debug('Exception while updating repayment record, after sending sms through Responsys.Details are as follows- ');
                System.debug(e.getMessage());
            }
            retunValue = 'SUCCESS';
        }
        else{
            retunValue = 'FAILURE';
        }
        
        return retunValue;
    }

    class InvalidValuesException extends Exception {}
    
    class IFSCException extends Exception {}
}