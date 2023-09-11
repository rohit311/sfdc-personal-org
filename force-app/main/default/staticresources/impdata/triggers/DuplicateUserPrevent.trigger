trigger DuplicateUserPrevent on Credit_Officer_Queue_Mapping__c (before insert, before update) {
    List <Credit_Officer_Queue_Mapping__c> CreditOfficer = new list<Credit_Officer_Queue_Mapping__c>();
    if(trigger.isBefore){
        if(trigger.isInsert){
            for(Credit_Officer_Queue_Mapping__c CM : trigger.new){
            system.debug('CM.User__c : '+CM.User__c);
                if(CM.User__c != null){
                    CreditOfficer = [select User__c from Credit_Officer_Queue_Mapping__c where User__c=:CM.User__c];
                    
                    if(CreditOfficer != null && CreditOfficer.size() > 0){
                        CM.addError('Duplicate Record for user is not allowed');                    
                    }
                }
                if(CM.QueueValue__c != null && CM.ExceptionQueueValue__c!= null){
                    List <String> QueueList = CM.QueueValue__c.split(',');
                    List <String> ExceptionQueueList = CM.ExceptionQueueValue__c.split(',');
                        
                    if(QueueList != null && QueueList.size() > 0 && ExceptionQueueList != null && ExceptionQueueList.size() > 0){
                        for(String queue:QueueList){
                            if(ExceptionQueueList.contains(queue)){
                                CM.addError('Queue and Exception queue cannot be same');
                            }
                        }
                    }
                        
                }               
            }
        }
        if(trigger.isUpdate){
            system.debug('Update event');
            for(Credit_Officer_Queue_Mapping__c CMnew : trigger.new){
                system.debug('old : '+Trigger.oldMap.get(CMnew.Id).User__c);
                system.debug('new : '+CMnew.User__c);
                if(CMnew.User__c != null){
                    if(CMnew.User__c!= Trigger.oldMap.get(CMnew.Id).User__c){
                        system.debug('User is changed');
                        CreditOfficer = [select User__c,QueueValue__c,ExceptionQueueValue__c from Credit_Officer_Queue_Mapping__c where User__c=:CMnew.User__c];
                        
                        if(CreditOfficer != null && CreditOfficer.size() > 0){
                            CMnew.addError('Duplicate Record for user is not allowed');
                        }
                    }
                }
                if(CMnew.QueueValue__c != null && CMnew.ExceptionQueueValue__c != null){                    
                    List <String> QueueList = CMnew.QueueValue__c.split(',');
                    List <String> ExceptionQueueList = CMnew.ExceptionQueueValue__c.split(',');                    
                    if(QueueList != null && QueueList.size() > 0 && ExceptionQueueList != null && ExceptionQueueList.size() > 0){
                        for(String queue:QueueList){                            
                            if(ExceptionQueueList.contains(queue)){
                                CMnew.addError('Queue and Exception queue cannot be same');
                            }
                        }
                    }
                }                            
            }
        }
    }

}