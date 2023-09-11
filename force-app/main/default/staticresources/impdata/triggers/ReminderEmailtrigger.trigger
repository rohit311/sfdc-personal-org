trigger ReminderEmailtrigger on Reminder__c (before insert) 
{
   ID userid=trigger.new[0].Reminder_to__c;
   list<user> userlist=new list<user>();
   userlist=[select id,Email from user where id=:userid limit 1];
   if(userlist.size()>0)
   {
    trigger.new[0].ReminderEmail__c=userlist[0].Email;
    }
}