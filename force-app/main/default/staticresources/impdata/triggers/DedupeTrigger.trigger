trigger DedupeTrigger on De_Dupe__c (after update , after insert, before insert, before update) { //Bug:23567 Added before context

    //Added by mahima to restric integration user access- start--
    ID Pid=Userinfo.getProfileID();
    string Ids= Label.dedupe_App_restrictedUserId;
    //List<string> restrictedIds= new list<string>();
    set<string> restrictedIdsSet= new set<string>();
    if( ids!=null)
    {
        restrictedIdsSet.addAll(Ids.split(','));
    }
    //Bug:23567**S**
    if(Label.Enable_new_flow_for_sourcing_Channel.equalsIgnoreCase('TRUE')){
        if(Trigger.isBefore){
                        if(Trigger.isInsert || Trigger.isUpdate){
                list<Opportunity> loanDetails = new  list<Opportunity>();
        		system.debug('flag in trigger****'+ControlRecursiveCallofTrigger_Util.getrestrictDedupe());
        		if(!ControlRecursiveCallofTrigger_Util.getrestrictDedupe() && Trigger.New[0].Loan_Application__c!=null){
           		loanDetails = [Select Id,Product__c,Sourcing_Channel__c,Sourcing_Channel__r.Name,Sour_Channel_Name__c,PAN_Number__c From Opportunity WHERE
                                        id = : Trigger.New[0].Loan_Application__c];
            	system.debug('Query executed****');
            	ControlRecursiveCallofTrigger_Util.setrestrictDedupe();
        		}
                if(loanDetails!=null && loanDetails.size()>0 && loanDetails[0].Sourcing_Channel__c!=null &&
                   Label.Sourcing_Channel.containsIgnoreCase(loanDetails[0].Sour_Channel_Name__c)){
                    system.debug('createApproveLoanforSourcingChannel called from trigger****');
                	createApproveLoanforSourcingChannel.sourcingChannelPANChange(Trigger.new,loanDetails);    
                }
            }

        }
    }
    //Bug:23567 End
    if( !restrictedIdsSet.contains(Pid))
    {
      //Added by mahima to restric integration user access- end--  
        if(trigger.isUpdate && Trigger.isAfter){
            //Pankaj:NJ Wealth start
            Id loanId = NULL;
            Id appId = NULL;
            Boolean isDedupeChanged = false;
            //Pankaj:NJ Wealth ends     
             //ESF_Service  instanceOf_ESF_Service = new ESF_Service();
             List<opportunity> oppList = new List<opportunity>();
             for(De_dupe__c dedupeObj : trigger.new ){
                //Pankaj:NJ Wealth start
                loanId = dedupeObj.Loan_Application__c;
                appId = dedupeObj.Applicant__c;
                //harsit----optimization START
            //Adding the flag to call the handler method only if required
            if(dedupeObj.De_Dupe_Check_Done__c != Trigger.oldMap.get(dedupeObj.Id).De_Dupe_Check_Done__c && dedupeObj.De_Dupe_Check_Done__c == true)
                isDedupeChanged = true;
            //harsit----optimization END
                //Pankaj:NJ Wealth ends
                Boolean dedupeAllStatus = true;
               if(dedupeObj.Loan_Application__c != null){
                
                /*if(dedupeObj.Loan_Product__c == 'ESF'){  
                Opportunity oppObj = [select Id,Product__c,StageName from Opportunity where id=: dedupeObj.Loan_Application__c];
                    system.debug('>>>>>>>>>>> '+dedupeObj.Customer_Status__c);
                    if(dedupeObj.Customer_Status__c == 'Bad'){
                        oppObj.StageName = 'Rejected';
                        oppList.add(oppObj);
                        //update oppObj;
                    }else{ 
                        List<De_Dupe__c> dedupeObjList = [select Customer_Status__c from De_Dupe__c where Loan_Application__c =:oppObj.id ];        
                         system.debug('>>>>>>>>>>> '+dedupeObj.Customer_Status__c);
                        for(De_Dupe__c dedupeObject : dedupeObjList){
                            if(!(dedupeObject.Customer_Status__c == 'Good' || dedupeObject.Customer_Status__c == 'Refer' || dedupeObject.Customer_Status__c == 'No Match')){
                                dedupeAllStatus = false;
                            }
                        }
                        if(dedupeAllStatus){
                            oppObj.StageName = 'Cibil';
                            //update oppObj;
                            oppList.add(oppObj);
                            system.debug('>>>>>>>>>>> oppObj : '+oppObj);
                            ESF_Service.ESF_CIBILCheck( oppObj.id);
                        }
                     //   instanceOf_ESF_Service.ESF_CIBILCheck( dedupeObj.Loan_Application__c );
                    }
                }*/
            }
            
             }
                //Pankaj:NJ Wealth start
                if(isDedupeChanged){//harsit----optimization
                    system.debug('Inside flag true***');
                if(loanId!= null && appId!= null) {
                    DedupeTriggerHandler handlerObject = new DedupeTriggerHandler(trigger.new,loanId,appId);
                    //handlerObject.handleAfterUpdate(); //Bug:23567 (Commented this)
                    system.debug('Calling method***');
                    handlerObject.handleAfterInsert(); //Bug:23567
                    }
                }
                //Pankaj:NJ Wealth ends
             if(oppList.size() >0)
             update oppList;
        }
    
   
    // After ?Inser Event processing.......
    
        if(trigger.isInsert && Trigger.isAfter){
            Boolean isDedupeDone = false; //Bug:23567
          System.debug('------- trigger.isInsert && Trigger.isAfter ------ ');
           //Pankaj:NJ Wealth starts
            Id loanId = NULL;
            Id appId = NULL;
            for(De_dupe__c dedupeObj : trigger.new){
                loanId = dedupeObj.Loan_Application__c;
                appId = dedupeObj.Applicant__c;
                //23567**S**
                if(dedupeObj.De_Dupe_Check_Done__c == true && dedupeObj.Source_Or_Target__c == 'Source')
                    isDedupeDone = true;
                //23567**E**
            }
            system.debug('the loan apllication id in trigger is'+loanId+'\n appId  : '+appId );
             if(loanId!= null && appId!= null) {
             System.debug('Calling DedupeTriggerHandler .....................................');
             //Bug:23567**S***
                 if(isDedupeDone == true)
                 {
                 	DedupeTriggerHandler handlerObject = new DedupeTriggerHandler(trigger.new,loanId,appId);
             		handlerObject.handleAfterInsert();    
                 }
                 //Bug:23567**E**
            }
            //Pankaj:NJ Wealth ends
            
        }
    }
}