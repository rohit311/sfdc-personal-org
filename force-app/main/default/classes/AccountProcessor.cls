public class AccountProcessor {

    @AuraEnabled
    public static String createAccount(String jsonData){
        String status = '';
        
        if(String.isNotBlank(jsonData)){
            
            Map<String,Object> jsonMap = (Map<String,Object>)JSON.deserializeUntyped(jsonData);
                
            Account accRec = new Account(Name = (String)jsonMap.get('Name'),Type = (String)jsonMap.get('type'),Email__c = (String)jsonMap.get('Email'));
            List<Account> accList = [SELECT Name,Email__c,Type FROM Account WHERE Email__c = :(String)jsonMap.get('Email')];
                
            if(accList != null && acclist.size() >0){
                accRec.Id = accList[0].Id;
            }
                
            upsert accRec;
            status = 'success';
                
        }
        
        System.debug('jsonData '+jsonData);
        return status;
    }
    
    
    @future
    public static void countContacts(List<ID> lst)
    {
       List<Account> alist=[SELECT ID,Number_of_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE ID in :lst];
        System.debug('robin '+alist[0]);
       if(alist != null && alist.size()>0){
         for(Account a:alist)
         {
             List<Contact> conlist = a.Contacts;
             if(conList != null && conList.size()>0)
                 a.Number_of_Contacts__c = conList.size();
             else
                 a.Number_of_Contacts__c = 0;
           
         }
         update alist;
       }
    }
}