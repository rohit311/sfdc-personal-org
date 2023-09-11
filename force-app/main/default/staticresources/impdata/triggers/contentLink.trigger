trigger contentLink on ContentDocumentLink (before delete) {
    List<Id> cdId = new List<Id>();
    for(ContentDocumentLink cLink : Trigger.Old){
        cdId.add(cLink.ContentDocumentId);
    }
    List<Id> oppIds = new List<Id>();
    List<Id> appIds = new List<Id>();
    Map<String,ContentDocumentLink > cdMap = new Map<String,ContentDocumentLink >();
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
    Map<Id,Applicant__c> appMap = new Map<Id,Applicant__c>();
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
    for(ContentDocumentLink cdoc : Trigger.Old){
        String flow = '';
        if(cdMap.get(cdoc.ContentDocumentID).LinkedEntity.type == 'Opportunity'){
            flow = oppMap.get(cdMap.get(cdoc.ContentDocumentID).LinkedEntityId).Account.Flow__c;
        }
        else if(cdMap.get(cdoc.ContentDocumentID).LinkedEntity.type == 'Applicant__c'){
            flow = appMap.get(cdMap.get(cdoc.ContentDocumentID).LinkedEntityId).Loan_Application__r.Account.Flow__c;    
        }
        system.debug('flow is'+flow);
        if(flow == 'Mobility V2'){
            if(cdoc.ContentDocument.OwnerId != UserInfo.getUserId()){
                cdoc.adderror('This attachment could not be deleted because you are not the owner');
            }
        }
        
    }
}