trigger welcome_letter_case_creation on Welcome_Letter__c (after update, before update) {
if (!ControlRecursiveCallofTrigger_Util.hasWelcomelettercasecreation()) {
ControlRecursiveCallofTrigger_Util.setWelcomelettercasecreation();

    if(trigger.isUpdate && Trigger.IsAfter){
    }
   if(trigger.isUpdate && Trigger.IsBefore){
   
      for(Welcome_Letter__c welcomeLetter : Trigger.New){   
        
       system.debug('checkpost-->'+ welcomeLetter.Welcome_Call_Status__c + '  '+welcomeLetter.Welcome_sms_sent__c);  
       system.debug('::isCalledFromBatch:::'+ControlRecursiveCallofTrigger_Util.hasIsCalledFromBatchFlag());
       

       /*
       Condition added by Rakesh Shinde. Date: 16 Feb 2016 
       Purpose :To stop calling of sendsms.message() from batch class
       */
      if(welcomeLetter.Welcome_sms_sent__c == false && (welcomeLetter.Welcome_Call_Status__c == 'New call' || welcomeLetter.Welcome_Call_Status__c == 'Repeat- Call Back') && welcomeLetter.Call_Status__c == 'Right Party Contact' && !ControlRecursiveCallofTrigger_Util.hasIsCalledFromBatchFlag()){
        system.debug('welcomeLetter.MOBILE__c-->' + welcomeLetter.MOBILE__c);
        String message = 'We would like to gauge the effort taken by you for our loan disbursement process. Rate us on a scale ( 1-5) , 1 lowest and 5 highest . Type DISBEFF space your rating send it to 9227564444';
        sendsms.message(welcomeLetter.MOBILE__c+'',message);
        welcomeLetter.Welcome_sms_sent__c = true; 
        
        if(welcomeLetter.Call_Back_Attempt__c==null){
          welcomeLetter.Call_Back_Attempt__c=0;
        }
        if(welcomeLetter.Welcome_Call_Status__c == 'Repeat- Call Back')
          welcomeLetter.Call_Back_Attempt__c +=1;
      }
      else if(welcomeLetter.Welcome_sms_sent__c == false && (welcomeLetter.Welcome_Call_Status__c == 'New call' || welcomeLetter.Welcome_Call_Status__c == 'Repeat- Call Back') && welcomeLetter.Call_Status__c != 'Right Party Contact'){
        if(welcomeLetter.Call_Back_Attempt__c==null){
          welcomeLetter.Call_Back_Attempt__c=0;
        }
        welcomeLetter.Call_Back_Attempt__c +=1;
      }
      /*
       Condition added by Rakesh Shinde. Date: 16 Feb 2016 
       Purpose :To stop calling of sendsms.message() from batch class
       */
      if(welcomeLetter.Welcome_sms_sent__c == false && welcomeLetter.Call_Back_Attempt__c!=null && welcomeLetter.Call_Back_Attempt__c > 2 && !ControlRecursiveCallofTrigger_Util.hasIsCalledFromBatchFlag()){
        String message = 'We would like to gauge the effort taken by you for our loan disbursement process. Rate us on a scale ( 1-5) , 1 lowest and 5 highest . Type DISBEFF space your rating send it to 9227564444';
          sendsms.message(welcomeLetter.MOBILE__c+'',message);
          welcomeLetter.Welcome_sms_sent__c = true;
        } 
      }
      
      List<Case> newCasesList = new List<Case>();
        List<Loan_INFO__c> loanInfoList = new List<Loan_INFO__c>();
        
        for(Welcome_Letter__c welcomeLetter : Trigger.New){   
           
        system.debug(welcomeLetter.Welcome_Call_Status__c + '----' + trigger.oldMap.get(welcomeLetter.id).Welcome_Call_Status__c);    
        system.debug(welcomeLetter.Call_Status__c+'----'+trigger.oldMap.get(welcomeLetter.id).Call_Status__c); 
           
            
            // Scenario 1 starts ******************************************
      if(   welcomeLetter.Welcome_Call_Status__c != trigger.oldMap.get(welcomeLetter.id).Welcome_Call_Status__c || 
            welcomeLetter.Call_Status__c != trigger.oldMap.get(welcomeLetter.id).Call_Status__c)
        {
            if(welcomeLetter.Welcome_Call_Status__c == 'New call' && welcomeLetter.Call_Status__c == 'Right Party Contact'){
                Case newCaseObj = new Case();
                
                newCaseObj.Origin = 'Phone';
                newCaseObj.Type__c = 'Close Looping';
                newCaseObj.Sub_Type__c = 'Welcome Calling Done';
                newCaseObj.Category__c = 'Request - NSR';
                newCaseObj.FTR__c = 'No';
                newCaseObj.Welcome_Letter__c = welcomeLetter.id;
                newCaseObj.Welcome_Letter_Customer_ID__c = welcomeLetter.customer_ID__c;
                
                loanInfoList = [Select id from Loan_INFO__c where name=:welcomeLetter.LAN__c];
                if(loanInfoList.size()>0){
                    newCaseObj.Loan_INFO__c = loanInfoList[0].id;
                }
                
                newCasesList.add(newCaseObj);
                
            }
            if(welcomeLetter.Welcome_Call_Status__c != 'New call' && welcomeLetter.Call_Status__c != 'Right Party Contact'){
                Case newCaseObj = new Case();
                
                newCaseObj.Origin = 'Phone';
                newCaseObj.Type__c = 'Close Looping';
                newCaseObj.Sub_Type__c = 'Welcome Calling Attempted';
                newCaseObj.Category__c = 'Request - NSR';
                newCaseObj.FTR__c = 'No';
                newCaseObj.Welcome_Letter__c = welcomeLetter.id;
                newCaseObj.Welcome_Letter_Customer_ID__c = welcomeLetter.customer_ID__c;
              
     loanInfoList = [Select id from Loan_INFO__c where name=:welcomeLetter.LAN__c];
                if(loanInfoList.size()>0){
                    newCaseObj.Loan_INFO__c = loanInfoList[0].id;
                }
                
                newCasesList.add(newCaseObj);
            }
        //  Scenario 1 ends *****************************************
                 
      } 
        
    }  
      if(newCasesList.size() > 0){
          insert newCasesList;
      }
   } 
    
    }
}