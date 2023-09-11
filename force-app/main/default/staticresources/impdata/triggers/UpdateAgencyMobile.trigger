trigger UpdateAgencyMobile on Verification__c (before insert,before update,after insert,after update) 
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
      List<Verification_Agency_Master__c> agency=new List<Verification_Agency_Master__c>();
        List<String> phone =new List<String>();
        
        // Start of invisible monitoring changes - Added logic to add filter in the query
        Set<ID> VAMSet = new Set<ID>();
        for(Verification__c ver : trigger.new) 
            VAMSet.add(ver.Verification_Agency__c);
        
        System.debug('VAM set size --> ' + VAMSet.size());
        // End of invisible monitoring changes
        
        if(VAMSet != null && VAMSet.size() > 0) 
        {            
            agency= [select id,mobile__C,Mail_Id__c,name FROM Verification_Agency_Master__c WHERE ID IN : VAMSet LIMIT 50000];
            for (Verification__c ver: trigger.new)
            {
                for(integer i=0;i<agency.size();i++)
                {
                    integer flag=0;
                    if(ver.Verification_Agency__c !=null && ver.Verification_Agency__c==agency[i].Id)
                    {
                        ver.agency_mobile__c=agency[i].mobile__C;     
                        ver.Agency_Email__c=agency[i].Mail_Id__c;  
                        ver.Agency_Name__c  =agency[i].name;  
                    }     
                }
            }
        }    
    }
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Verification__c objVerf : Trigger.new)
        {
            if(objVerf != null)
            {
              List<string> lstRSAAllowedStatus = Label.RSA_Allowed_Verification_Statuses.toUpperCase().split(',');
                if(string.isNotBlank(objVerf.Status__c) && lstRSAAllowedStatus != null && lstRSAAllowedStatus.size() > 0)
                    if(string.isNotBlank(objVerf.RSA_Verification_Status__c) && lstRSAAllowedStatus.contains(objVerf.Status__c.toUpperCase()))
                      objVerf.RSA_Verification_Status__c = 'Close';
                  else 
                        if(string.isNotBlank(objVerf.RSA_Verification_Status__c) && !lstRSAAllowedStatus.contains(objVerf.Status__c.toUpperCase()))
                          objVerf.RSA_Verification_Status__c = 'Open';               
            }
        }
    }
  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
        List<string> lstOfRSAOppIDs = new List<string>();
        List<string> lstOfIMOppIDs = new List<string>();
      for(Verification__c objVerf : Trigger.new)
        {
            if(objVerf != null)
            {
              if(objVerf.Loan_Application__c != null && objVerf.Initiated_by_invisible_monitoring__c)
                      lstOfIMOppIDs.Add(objVerf.Loan_Application__c);
                else
                    if(objVerf.Loan_Application__c != null && string.isNotBlank(objVerf.Loan_Application__c))
                        lstOfRSAOppIDs.Add(objVerf.Loan_Application__c);
            }
        }
        if(lstOfRSAOppIDs != null && lstOfRSAOppIDs.size() > 0 && !Test.isRunningTest())
          VerificationHelperClass.UpdateApplicantFraudStatus(lstOfRSAOppIDs,true,false);
            
        if(lstOfIMOppIDs != null && lstOfIMOppIDs.size() > 0 && !Test.isRunningTest())
            VerificationHelperClass.UpdateApplicantFraudStatus(lstOfIMOppIDs,false,true);
    }    
}