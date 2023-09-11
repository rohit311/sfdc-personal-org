trigger UpdateMeetingfields on Task (after Update) {
Set<ID> TaskID = new Set<ID>();
List<Task> Newtask = new List<Task>();
List<Meeting_request__c> metlist = new List<Meeting_request__c>();
List<Meeting_request__c> metlist1 = new List<Meeting_request__c>();
    for(Task ntask : Trigger.new){
                TaskID.add(ntask.id);
                Newtask.add(ntask); 
                }
                if(TaskID.size()>0){ 
                    metlist = [Select Name, Id,Date_of_Call__c,Due_dates__c,Lead__c,Managers_Comments__c,Next_Steps__c,Outcome__c,Person_Met__c
                               ,Purpose_of_Call__c,TaskId__c,Weekly_reminders__c from Meeting_request__c  where TaskId__c in : TaskID];
                   }
   if(metlist .size()>0){
    for(Task ntask : Trigger.new){
        for(Meeting_request__c met : metlist){
           met.Date_of_Call__c =  ntask.Date_of_Call__c;
           met.Person_Met__c =  ntask.Person_Met__c;
           met.Purpose_of_Call__c=  ntask.Purpose_of_Call__c;
          
           met.Next_Steps__c =  ntask.Next_Steps__c;
           met.Outcome__c =  ntask.Outcome__c;
           met.Due_dates__c =  ntask.Due_date__c;
           met.Managers_Comments__c=ntask.Managers_Comments__c;
           met.Weekly_reminders__c=ntask.Weekly_reminders__c;
           
           metlist1.add(met);
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
Update metlist1;


}