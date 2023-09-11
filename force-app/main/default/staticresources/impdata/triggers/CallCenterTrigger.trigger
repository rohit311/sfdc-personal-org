trigger CallCenterTrigger on Call_Center_Event__e (after insert) {
try{system.debug('inside CallCenterTriggerevent');
    
    List<String> PONumber = new List<String>();    
    List < ID > idList = new List < ID > ();
    
    for (Call_Center_Event__e e : Trigger.New) { if (e.PO_Number__c!=null) PONumber.add(e.PO_Number__c); }
    system.debug('PONumber-->'+PONumber);    
    
    if(PONumber != null && PONumber.size() > 0){
                
        List<Product_Offerings__c> poList = [select id, Lead__r.ID FROM Product_Offerings__c WHERE id IN :PONumber];
        system.debug('Queried poList'+poList);
        
        if(poList != null && poList.size() > 0)
        { for(Product_Offerings__c plist :poList){ if (plist.Lead__r.ID!=null) {idList.add(plist.Lead__r.ID);} } }
        
        if(idList != null && idList.size() > 0){
            List <Lead> LList= [select id, SentToCallCenter__c from Lead WHERE id IN: idList];
           system.debug('Queried LList '+LList);
             
            if(LList != null && LList.size() > 0){
                for(Lead LLst :LList){ LLst.SentToCallCenter__c = system.now(); } update LList;
            }                        
             //if(LList != null && LList.size() > 0) {update LList;}
            system.debug('updated LList '+LList);
         }
    }
    }catch(exception e){system.debug('po trigger Lead_Sharing_to_PO_Owner '+e);}
}