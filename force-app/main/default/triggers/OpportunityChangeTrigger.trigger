trigger OpportunityChangeTrigger on OpportunityChangeEvent (after insert) {

    List<Task> taskLst = new List<Task>();
    
    for(OpportunityChangeEvent oppChgEvt : Trigger.new){
        EventBus.ChangeEventHeader header = oppChgEvt.ChangeEventHeader;
         
        if(header.changetype == 'UPDATE' && oppChgEvt.isWon){            
            Task folTask = new Task(Subject = 'Follow up on won opportunities: '+header.recordids);
            taskLst.add(folTask);
        }
    }
    
    if(taskLst.size() > 0)
        insert taskLst;
    
}