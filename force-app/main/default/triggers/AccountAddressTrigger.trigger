trigger AccountAddressTrigger on Account (before insert,after update) {
/*List<Account> acclist=new List<Account>();
    for(Account a: Trigger.new)
    {
        if(a.Match_Billing_Address__c == true && a.BillingPostalCode != null){
            a.ShippingPostalCode=a.BillingPostalCode;    
            
        }
    }
      
   */
   if(Trigger.isBefore){
       AccountHandler.insertNewAccount(Trigger.new[0].Name);
   }
   
   switch on Trigger.OperationType {
       when AFTER_INSERT{
           System.debug('insert '+Trigger.new.size());
       }
       when AFTER_UPDATE{
           System.debug('update'+Trigger.new.size());
       }
   }
   
    
}