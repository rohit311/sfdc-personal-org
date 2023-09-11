Trigger CreateUserTrigger on Approval_Note_Remarks__c(before insert, before update, after Insert) 
{   
    System.debug('in create user');

    if(ControlRecursiveCallofTrigger_Util.getapprovalChangeT() == false){
    ControlRecursiveCallofTrigger_Util.setapprovalChangeT(); 
    //CreateUserTriggerHandler createUser = new CreateUserTriggerHandler();
    system.debug('Trigger.oldmap in  Trigger' + Trigger.oldmap);
    
    CreateUserTriggerHandler createUserObj = new CreateUserTriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldmap);
    List < String > mailToSend = new List < String > ();
    
    // Step 0: Create a master list to hold the emails we'll send
    List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();

    List < String > sendTo = new List < String > ();
    system.debug('condition check' + Trigger.isupdate + '   ' + Trigger.isBefore);
    
    if (Trigger.isupdate && Trigger.isBefore) 
    {
        system.debug('in After Update');
        for (Approval_Note_Remarks__c approvalObj: Trigger.New) 
        {
            if (approvalObj.business_unit__c != null) 
            {
                if (approvalObj.ApprovalStatus__c == 'BHNH' && approvalObj.Email_Sent__c == false) 
                {
                    createUserObj.sendEmailToBHNH(approvalObj);
                    approvalObj.Email_Sent__c = true;
                } 
                else if (approvalObj.ApprovalStatus__c == 'SPOC' && approvalObj.Remarks__c != null && approvalObj.Email_Sent__c == false) 
                {
                    createUserObj.sendEmailToBHNH(approvalObj);
                    approvalObj.ApprovalStatus__c = 'BHNH';
                    approvalObj.Email_Sent__c = true;
                }

            }
        }
        
        createUserObj.checkStatus();
        createUserObj.appendRuralServingCities();
        createUserObj.processRemainingLicences(Trigger.New, 'update');
    }
 
    if (Trigger.isInsert && Trigger.isAfter) 
    {
        system.debug('in After Insert' + Trigger.New);
        system.debug('in After Insert' + Trigger.NewMap);
        List<Approval_Note_Remarks__c>  lstApprovalObj =  new List<Approval_Note_Remarks__c>();
        for (Approval_Note_Remarks__c approvalObj: Trigger.NewMap.Values()) 
        {
            System.debug('approvalObj'  + approvalObj.Id);
            lstApprovalObj.add(approvalObj);
        }
        
        //if it is for Temporary access, use different method.
        if(lstApprovalObj != NULL && lstApprovalObj.size() > 0 && lstApprovalObj[0].User_for_Temporary_Access__c != NULL  )
        {
            System.debug('Call for temp access detected.');
            createUserObj.processTemporaryAccess(lstApprovalObj[0]);   
        } 
        //it is for Normal User Creation Flow. 
        else
        {
            for (Approval_Note_Remarks__c approvalObj: Trigger.New) 
            {
                if (approvalObj.business_unit__c != null) 
                {
                    createUserObj.sendEmailToBHNH(approvalObj);
                }
            }
            createUserObj.processRemainingLicences(Trigger.New, 'insert'); 
            
        }
        //added by gopika
          createUserObj.checkStatus();
    }
    
    if ((trigger.isBefore && trigger.isInsert)) 
    {
        system.debug('is Before and is Insert INNNNN');
        List<Approval_Note_Remarks__c>  lstApprovalObj =  Trigger.New;
        System.debug('Map size : ' + lstApprovalObj.size() );
        System.debug('lstApprovalObj' + lstApprovalObj);
        System.debug('lstApprovalObj.size()' + lstApprovalObj.size());
        System.debug('lstApprovalObj[0].User_for_Temporary_Access__c' + lstApprovalObj[0].User_for_Temporary_Access__c);
        //if it is for Temporary access, use different method.
        if(lstApprovalObj != NULL && lstApprovalObj.size() > 0  && lstApprovalObj[0].User_for_Temporary_Access__c != NULL )
        {
            System.debug('Call for temp access detected.');
            //createUserObj.processTemporaryAccess(lstApprovalObj[0]);   
        } 
        else
        {
            System.debug('Call for append rural service access detected.');
            createUserObj.appendRuralServingCities();
        }
    }
    }
}