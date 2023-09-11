trigger UpdateReminderfields on Task (after Update) {
Set<ID> TaskID = new Set<ID>();
List<Task> Newtask = new List<Task>();
List<Reminder__c> remlist = new List<Reminder__c>();
List<Reminder__c> remlist1= new List<Reminder__c>();
    for(Task ntask : Trigger.new){
                TaskID.add(ntask.id);
                Newtask.add(ntask); 
                }
                if(TaskID.size()>0){ 
                    remlist = [Select Name, Id,Description__c,DueDate__c,Lead__c,Reminder_for__c,Reminder_frequency__c,Reminder_to__c
                                ,Subject__c,TaskId__c,TaskURL__c from Reminder__c  where TaskId__c in : TaskID];
                   }
   if(remlist .size()>0){
    for(Task ntask : Trigger.new){
        for(Reminder__c rem : remlist ){
           rem.Reminder_for__c =  ntask.Reminder_for__c;
           rem.Description__c =  ntask.Description__c;
           rem.Due_date__c=  ntask.ActivityDate;
          // rem.Reminder_to__c =ntask.Owner;
           rem.Subject__c =  ntask.Subject;
           remlist1.add(rem);
            }
           // if(ntask.ActivityDate!=null)
            //{
            //system.debug('%%%%%%'+ntask.ActivityDate);
            ////ntask.ReminderDateTime=ntask.ActivityDate;
            //system.debug('$$$$$$$'+ntask.ReminderDateTime);
           // }
       // Update ntask;
         }
    }
Update remlist1;


}