trigger cibilExToCibilcheck on CIBIL_Extension__c (after update,after insert) {


Set<id> applicantid = new Set<id>();
List<Applicant__c> app = new List<Applicant__c>();
List<opportunity> opplist= new List<opportunity>();
List<CIBIL_Extension__c>  ceRecords1 =new List<CIBIL_Extension__c>();
List<CIBIL__c> pcibil = new List<CIBIL__c>();
     
    if(trigger.isUpdate){        
        if (!ControlRecursiveCallofTrigger_Util.hascibilcntr1()) {
            ControlRecursiveCallofTrigger_Util.setcibilcntr1();   

            try{
                applicantid.add(trigger.new[0].applicant__c);    
                app=[select id,name,Loan_Application__c from Applicant__c where id =: applicantid];  
                opplist=[select id,name,Product__c from Opportunity where id =:app[0].Loan_Application__c];
                pcibil = [select id,CIBIL_Extension__c  from CIBIL__c where CIBIL_Extension__c =: trigger.new limit 1];
                system.debug(pcibil+'sssssssssssssssssssss');
                if(opplist[0].Product__c =='SOL'){
                    cibilcheckclass ccs = new cibilcheckclass();
                    ccs.cibilUpdate(pcibil);
                }
                boolean executeLogic = CIBILSegmentationHandler.checkProductWiseOwnershipType(opplist[0].Product__c,'',true);
                System.Debug('Value of executeLogic in cibilExToCibilcheck trigger ' + executeLogic);
                if(executeLogic != null && executeLogic)
                {
                     cibilcheckclass ccs = new cibilcheckclass();
                     ccs.cibilUpdate(pcibil);
                }
                   
            }
            catch(exception e)
            {
              System.debug('Exception occured in cibilExToCibilcheck trigger details are Line Number ' + e.getLineNumber() + ' Details ' + e);
            }
                      
        }
    }
    //Bug 22141 S
    if(Trigger.isAfter && trigger.isInsert){
        try{
            if(System.Label.MobileValidationOn=='true'){
                if(Label.FraudValidationsforProducts!=null && string.isNotBlank(Label.FraudValidationsforProducts) ){
                    List<string> ListofProducts = Label.FraudValidationsforProducts.split(',');   
                    //List<CIBIL_Extension__c> cibilextensionObjList = new List<CIBIL_Extension__c> ();
                    //String cibextnId = trigger.new[0].id
                    //  cibilextensionObjList = [select id,Lead_Applicants__c,Lead__c,Applicant__c from CIBIL_Extension__c where id =:cibextnId];
                    if(trigger.new[0].Lead_Applicants__c != null)
                    {
                        Id leadAppId = trigger.new[0].Lead_Applicants__c;
                        List<Lead_Applicants__c> leadApplicantobj = new List<Lead_Applicants__c>();
                        // query to be made dyanimc based on custom label values
                        leadApplicantobj = [select id,mobile__c,PAN__C,Lead__r.product__c from Lead_Applicants__c where id = :leadAppId];
                        if(leadApplicantobj!=null && leadApplicantobj.size()>0 && leadApplicantobj[0].Lead__r!=null){
                            String productName = leadApplicantobj[0].Lead__r.product__c;  
                            if(productName!=null){
                                productName = productName.toUppercase();
                                if(productName!=null && ListofProducts.contains(productName))
                                {
                                    system.debug('inside demo');
                                    if(label.FraudFieldsforLeadApplicant != null && string.isNotBlank(Label.FraudFieldsforLeadApplicant)){
                                        List<String> fieldstobeCompared = Label.FraudFieldsforLeadApplicant.split(',');
                                        FraudValidationUtility.utilityMethod('Lead_Applicants__c',leadApplicantobj[0],productName,fieldstobeCompared,'');
                                    }
                                }
                            }
                            
                        }
                    }
                    else if(trigger.new[0].Lead__c!=null){
                        Id leadId = trigger.new[0].lead__c;
                        List<lead>leadObj = new List<lead>();
                        leadObj = [select id, MobilePhone,PAN__c,product__c from Lead where id = :leadId];
                        if(leadObj!=null && leadObj.size()>0){
                            String productName = leadObj[0].product__c;
                            if(productName!=null){
                                productName = productName.toUppercase();
                                if(ListofProducts.contains(productName)){
                                system.debug('inside demo');
                                    if(label.FraudFieldsforLead != null && string.isNotBlank(Label.FraudFieldsforLead)){
                                        List<string> fieldstobeCompared = Label.FraudFieldsforLead.split(',');
                                        FraudValidationUtility.utilityMethod('Lead',leadObj[0],productName,fieldstobeCompared,'');
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    else if(trigger.new[0].Applicant__c != null){
                        Id applicantId = trigger.new[0].Applicant__c;
                        List<Contact> contactObj = new List<Contact>();        
                        contactObj = [select id,mobile__c,PAN__c,(select id,product__c,Applicant_Type__c from contact__r) from Contact  where id IN (select Contact_Name__c from applicant__c where id = :applicantId)];
                        if(contactObj!=null && contactObj.size()>0 && contactObj[0].contact__r!=null && contactObj[0].contact__r.size()>0){
                            String productName = contactObj[0].contact__r[0].product__c;
                            if(productName!=null){
                                productName = productName.toUppercase();
                                if(ListofProducts.contains(productName)){
                                    if(label.FraudFieldsforContact != null && string.isNotBlank(Label.FraudFieldsforContact)){
                                        List<string> fieldstobeCompared = Label.FraudFieldsforContact.split(',');
                                        FraudValidationUtility.utilityMethod('Contact',contactObj[0],productName,fieldstobeCompared,contactObj[0].contact__r[0].Id);
                                    }
                                        
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }
        catch(Exception e){
            String exceptionMessage = e.getMessage() + '\n' + e.getLineNumber() + '\n' + e.getCause() + '\n' + e.getTypeName();
            system.debug('Exception :###'+ exceptionMessage);
        }
    }   
    //Bug 22141 E
}