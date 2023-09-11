trigger HLcamCRUD on HL_CAM__c (before update) {

    public HLcamCRUDHandler handler = new HLcamCRUDHandler();
     
    if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
       handler.onBeforeUpdate(Trigger.oldmap,trigger.new); 
    }
}