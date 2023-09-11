trigger AccountBudgetTrigger on Account (after insert,after update) {
	
    Decimal salesPercentage = 0.60,marketingPercentage = 0.40;
    Map<Id,Integer> accountToMarketingCount = new Map<Id,Integer>();
    Map<Id,Integer> accountToSalesCount = new Map<Id,Integer>();
    List<Contact> contactsToUpdate = new List<Contact>();
            
    for(AggregateResult resObj : [SELECT AccountId,COUNT(Id)marketingCount FROM Contact WHERE AccountId IN :Trigger.newMap.keySet() AND Use_Marketing_Budget__c = true GROUP BY AccountId]){
        accountToMarketingCount.put((String)resobj.get('AccountId'),(Integer)resobj.get('marketingCount'));
    }
    
    for(AggregateResult resObj : [SELECT AccountId,COUNT(Id)salesCount FROM Contact WHERE AccountId IN :Trigger.newMap.keySet() AND Use_Sales_Budget__c = true GROUP BY AccountId]){
        accountToSalesCount.put((String)resobj.get('AccountId'),(Integer)resobj.get('salesCount'));
    }
    
    for(Contact con : [SELECT Account.Budget__c,AccountId,Budget__c,Use_Marketing_Budget__c,Use_Sales_Budget__c FROM Contact WHERE AccountId IN :Trigger.newMap.keySet() AND (Use_Marketing_Budget__c = true OR Use_Sales_Budget__c = true)]){
        
        if(con.AccountId != null && con.Account.Budget__c != null){
            if(con.Use_Marketing_Budget__c == true && con.Use_Sales_Budget__c == true){
                
                con.Budget__c = (con.Account.Budget__c*salesPercentage)/accountToSalesCount.get(con.AccountId) + (con.Account.Budget__c*marketingPercentage)/accountToMarketingCount.get(con.AccountId);
            }
            else if (con.Use_Marketing_Budget__c == true){
                con.Budget__c = (con.Account.Budget__c*marketingPercentage)/accountToMarketingCount.get(con.AccountId);
            }
            else if(con.Use_Sales_Budget__c == true){
                con.Budget__c = (con.Account.Budget__c*salesPercentage)/accountToSalesCount.get(con.AccountId);
            }
        	
            contactsToUpdate.add(con);
        }
    }
    
    if(contactsToUpdate.size() > 0){
        update contactsToUpdate;
    }
}