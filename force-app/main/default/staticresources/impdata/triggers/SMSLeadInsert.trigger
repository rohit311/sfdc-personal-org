trigger SMSLeadInsert on SMS_Received__c (after insert) {

    SMSLeadTriggerHandler handler = new SMSLeadTriggerHandler();
    
    if (!ControlRecursiveCallofTrigger_Util.hasSmsleadt()) {
                    ControlRecursiveCallofTrigger_Util.setSmsleadt();
    /* After Insert */
    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    }
  
    }
}