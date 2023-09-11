trigger DeletionOfDocFinnoneReports  on FinnOne_Report__c (before delete,after insert,after update,before insert) 
{ //Miles Change(added after update,before insert)**Garima
    
    public class MilesException extends Exception {}
    
    //Miles Change**S** (Garima) 
    //Following block will mark the Destination system for Loan Disbursement - spcly FAS cases, as of now!
    if(trigger.isInsert && trigger.isBefore)
    {
        try
        {
            for(FinnOne_Report__c fRep: Trigger.new)
            {
                if(fRep.Loan_Application__c != NULL && fRep.Product__c == 'FAS')
                {
                    if(String.isNotBlank(Label.Miles_Switch) &&  Label.Miles_Switch == 'true')
                    {
                        fRep.Destination_System__c = 'Miles';
                    }
                    fRep.Miles_Create_Client_Response__c = NULL;   //Did null manually
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Exception occurred***'+e);
        }
    }
    
    //If this trigger is update, we need to check the Miles response status, and if all the are updated, 
    //then only need to send primary app's data to Miles. 
    if(trigger.isUpdate && trigger.isAfter)
    {
        System.debug('>>> Code to execute for Loan creation start : ');
        System.debug('>>> Recd list of  : ' + trigger.new.size() );
        Boolean isAllReportsUpdated = true;        
        String loanId = NULL ; //Need to check and ensure, if all the Finnone reports are updated with response
        
        try
        {
            for(FinnOne_Report__c fRep: Trigger.new)
            {
                System.debug('>> Found the loan record id: ' + fRep.Loan_Application__c);
                System.debug('>> Processing with this record now -: ' + fRep);
                if(fRep.Loan_Application__c != NULL && fRep.Product__c == 'FAS' && fRep.Destination_System__c== 'Miles')
                {
                    if(loanId == NULL)
                    {
                        
                        loanId = fRep.Loan_Application__c;
                        System.debug('>> Found the loan record id: ' + loanId);
                    }

                    if(Trigger.OldMap.containsKey(fRep.Id) &&  fRep.Miles_Create_Client_Response__c != Trigger.OldMap.get(fRep.Id).Miles_Create_Client_Response__c)
                    {

                        Map<String, object> resMap  = (Map<String, object>) JSON.deserializeUntyped(fRep.Miles_Create_Client_Response__c);
                        system.debug('Client creation response****'+resMap); 
                        if(resMap.containsKey('Remarks') && resMap.containsKey('CustomerID'))
                        {
                            String remarks = (String ) resMap.get('Remarks');
                            String custId = (String) resMap.get('CustomerID');

                            if(String.isNotBlank(remarks) && String.isNotBlank(custId) && 
                                ( remarks.containsIgnoreCase('success') ||
                                remarks.containsIgnoreCase('UniqueRecordID already exists in System,PAN Already Exists')
                                ||  Decimal.valueOf(custId) !=0 ) )
                                {
                                    continue;
                                }
                        }
                    }   

                    //If this statement is executing that meant, it is neither in old map(which is exceptional case) and old val is not updated
                    isAllReportsUpdated = false;
                    break;
                }
                else{
                    isAllReportsUpdated = false;
                    break;
                }
            }

			System.debug('>>> Status of loan cration call :  ' + isAllReportsUpdated + ' with loan :  '  +loanId);
                
            if(String.isNotBlank(loanId) && isAllReportsUpdated == true)
            {
                List<Finnone_Report__c> finReps = new List<Finnone_Report__c>();
				                    
                //Queried fields, which is used in Enqueed scheduled job. 
                finReps = [SELECT Id,Name,Primary_Applicant_Type__c,createdDate,Primary_Last_Name__c,Loan_Application_Number__c,
                                Miles_Create_Client_Response__c,Loan_Application__c,Product__c,	
                                Loan_Application__r.Loan_Amount__c,Applicant_ID__c,Payment_Mode__c,Loan_Application__r.createdDate,
                                Primary_First_Name__c,Primary_Middle_Name__c,IFSC_code__c,Applicant_Type__c,
                                Loan_Application__r.Sour_Channel_Name__c, Destination_System__c,Loan_Application__r.Application_Form_Number__c // US:33655 - Added Application form number to query
                            FROM 
                                Finnone_Report__c 
                            WHERE
                                Loan_Application__c = :loanId ];    //commented following code, since we did checks while getting the loan id.

                System.debug('>>> Sending ' +  finReps.size()  + ' records for loan creations');
                //This means same number of Finnone report is updated, which is already present. Need to check if it actually changed.
                if(finReps.size() == trigger.new.size()  )
                {       
                    ID jobID = System.enqueueJob(new CreateLoanForMiles(finReps));         
                    System.debug('>> Job Id : ' + jobId);                        
                }
            }
        

        }
        catch(Exception e){
            system.debug('Exception in finone trigger***'+e);
        }
        
    }
    //Miles Change**E** (Garima)
    
    if(trigger.isDelete && trigger.isbefore)
    { 
        for (FinnOne_Report__c a : Trigger.old)
        {
            system.debug('===>> in loop');
            List<Document_Finnone_Report__c> DocFinnone=[select id from Document_Finnone_Report__c where FinnOne_Report__c=:a.id];
            system.debug('===>> after query');    
            if(DocFinnone.size()>0)
            {
                delete DocFinnone;
                system.debug('===>>records deleted');    
            }
        }
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        String primaryFinnRecordID1 = '';//17949
        System.debug('Bitly Trigger');
        Set<ID> ids = new Set<ID>();  
        String i =''; //Miles**Garima**
        for(FinnOne_Report__c obj: Trigger.New)
        {
            ///Miles Start (Added destination system & product condition --Garima)
            if(string.isBlank(i) && obj.Loan_Application__c != NULL && obj.Product__c == 'FAS' && 
               string.isNotBlank(obj.Destination_System__c) && obj.Destination_System__c == 'Miles')
            {
                system.debug('Inside if');
                i = obj.Loan_Application__c;
            }
            ///Miles End
            //17949--S
            if(!Test.isRunningTest()){
                if (obj.Applicant_Type__c == 'P' && obj.IMPS__c=='Y') {
                    primaryFinnRecordID1 = obj.Id;
                }    
            }
            else
            {
                primaryFinnRecordID1 = obj.Id;    
            }
            
            //17949--E  
            //Added by Anurag to prevent FinnOne_Report__c objects created from Insurance__c to activate the Trigger-- Start
            if (obj.Record_Type__c != 'Insurance Distribution')
                //Added by Anurag-- End
            {ids.Add(obj.id);}
        }
        //17949--S
        List<FinnOne_Report__c> FDList = [SELECT id,Loan_Application__c,Loan_Application__r.id FROM FinnOne_Report__c WHERE ID = : primaryFinnRecordID1];
        if(FDList != null && FDList.size() > 0)
        {
            ID finnoneR=FDList[0].Loan_Application__r.id;
            List<Opportunity> oppList=[SELECT Id FROM Opportunity WHERE ID = :finnoneR];
            if(Label.SMS_for_IMPS_YES_or_NO=='YES')
            {
                GeneralCommunicationHandler.sendSMS(oppList, 'Finnone_IMPS');
            }
        }    
        //17949
        // if(!Test.isRunningTest())
        //Added by Anurag-- Start
        if (ids.size()>0)
        //Added by Anurag-- End
        {
            bitly_sms_cls.sendbitlySms(ids);
        }
        System.debug('called class');
        //Miles**Added if condition (Garima)
        if(string.isNotBlank(i))
        {
            system.debug('calling createclient****');
            String returnMsg = ProcessMiles.milesCreateClient(i);
            if(string.isNotBlank(returnMsg) && returnMsg.containsIgnoreCase('ERROR'))
            {
                throw new milesException(returnMsg);
            }
        }
    }
}