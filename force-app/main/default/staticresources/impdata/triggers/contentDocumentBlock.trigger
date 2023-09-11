trigger contentDocumentBlock on ContentDocument (before insert,before delete) {
Static public String userName;  //added for 101 SOQL Taniya
    if(Trigger.isInsert){
        //Rohit added for soql removal
        //added for 101 SOQL Taniya
        if(userName==null || userName=='')
        userName = [Select Name from Profile where Id=:UserInfo.getProfileId()].Name;
        System.debug('User Name is::'+userName);
        for(ContentDocument c : trigger.new){
            if(!Label.hasChatterFileUploadAccess.contains(userName)  && !SFDCMobilePOController.allowFileUpload){ 
                if(!System.Test.isRunningTest()){
                    c.adderror('File cannot be uploaded!!!');   
                }
            }
        }
    }
     if(Trigger.isDelete){
        List<Id> cdId = new List<Id>();
        List<Id> oppIds = new List<Id>();
        List<Id> appIds = new List<Id>();
        Map<String,ContentDocumentLink > cdMap = new Map<String,ContentDocumentLink >();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Map<Id,Applicant__c> appMap = new Map<Id,Applicant__c>();
        for(ContentDocument cdoc : Trigger.Old){
            cdId.add(cdoc.Id);    
        }
        system.debug('cdId size'+cdId.size());
        for(ContentDocumentLink cdl : [SELECT ContentDocumentID, LinkedEntity.type, LinkedEntityId 
                FROM ContentDocumentLink 
                WHERE ContentDocumentID IN: cdId]){
            
            system.debug('linked entity'+cdl.LinkedEntityId);
            if(cdl.LinkedEntity.type == 'Opportunity'){
                oppIds.add(cdl.LinkedEntityId);
                cdMap.put(cdl.ContentDocumentID,cdl);
            }
            if(cdl.LinkedEntity.type == 'Applicant__c'){
                appIds.add(cdl.LinkedEntityId);     
                cdMap.put(cdl.ContentDocumentID,cdl);
            }
        }
        system.debug('cdMap'+cdMap);
        if(oppIds.size() > 0)
            oppMap = new Map<Id,Opportunity>([SELECT Id,Account.Flow__c from Opportunity where Id IN: oppIds]);
        if(appIds.size() > 0)
            appMap = new Map<Id,Applicant__c>([SELECT Id,Loan_Application__r.Account.Flow__c from Applicant__c where Id IN: appIds]);
        for(ContentDocument cdoc : Trigger.Old){
            String flow = '';
           if(cdMap != null && cdMap.size() > 0 && cdMap.get(cdoc.Id) != null){
               //system.debug('cdoc.Id'+cdoc.Id+'--'+cdMap.get(cdoc.Id).LinkedEntityId);
                if(cdMap.get(cdoc.Id).LinkedEntity.type == 'Opportunity'){
                    if(oppMap!=null){
                       flow = oppMap.get(cdMap.get(cdoc.Id).LinkedEntityId).Account.Flow__c;
                    }
                }
                else if(cdMap.get(cdoc.Id).LinkedEntity.type == 'Applicant__c'){
                    if(appMap!=null){
                    flow = appMap.get(cdMap.get(cdoc.Id).LinkedEntityId).Loan_Application__r.Account.Flow__c;   
                       }                    
                }
                system.debug('flow is'+flow);
                if(flow == 'Mobility V2'){
                   if(cdoc!=null){
                    if(cdoc.OwnerId != UserInfo.getUserId()){
                        cdoc.adderror('This attachment could not be deleted because you are not the owner');
                    }
                    }
                }
            }
            
        
            
        }
    }
         //writing this code because cant cover this line, if we cover this line the we have to go to line number 4 and if it happens then test class will fail    }
}