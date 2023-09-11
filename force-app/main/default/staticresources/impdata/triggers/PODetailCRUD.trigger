trigger PODetailCRUD on PODetail__c(before insert, after insert, before update, after update, before delete, after delete) {
 // SEND OFFER EMAIL ON INSERT
 static Set < Id > mobPOIdList = new Set < Id > ();
 Map<ID,List<PODetail__c>> PODetailsMap = new Map<ID,List<PODetail__c>>();
 if((ATOSParameters__c.getValues('PODetailCRUDTriggerflag') == null) || (ATOSParameters__c.getValues('PODetailCRUDTriggerflag') != null && ATOSParameters__c.getValues('PODetailCRUDTriggerflag').NewTriggerOptimizationFlow__c == true)){
     if (trigger.isInsert && Trigger.isAfter) {
        OnAfterInsert(Trigger.new);
     }
 }
 
 public void OnAfterInsert(List < PODetail__c > PODetailList) {
  for (PODetail__c poDetailsTemp: PODetailList) {
       List<PODetail__c> PODTemp = new List<PODetail__c>(); 
   if (poDetailsTemp.Product_Offerings__c != null) {
    mobPOIdList.add(poDetailsTemp.Product_Offerings__c);
    }
     if(PODetailsMap.get(poDetailsTemp.Product_Offerings__c) == null){
       PODTemp.add(poDetailsTemp);
       PODetailsMap.put(poDetailsTemp.Product_Offerings__c,PODTemp);
   }
  else{
       PODTemp = PODetailsMap.get(poDetailsTemp.Product_Offerings__c);
       PODTemp.add(poDetailsTemp);
       PODetailsMap.put(poDetailsTemp.Product_Offerings__c,PODTemp);
   }
  }
  if (mobPOIdList.size() > 0) {
   system.debug('mobPOIdList Entered');
   // Send Email
   PODetailCRUDHandler.productOffersEmail(mobPOIdList);
    //Send sms
   PODetailCRUDHandler handlerObj = new PODetailCRUDHandler();
   handlerObj.OnAfterInsert(mobPOIdList,PODetailsMap);
  }

 } 
 
}