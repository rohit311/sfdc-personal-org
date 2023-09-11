trigger contactInitialize on Contact (before insert) {
List<Contact> clist=new List<Contact>();
    
    clist=[SELECT ID,Deals_Accepted__c,Deals_Rejected__c FROM Contact WHERE CreatedDate=TODAY];
    
    for(Contact c:clist)
    {
        
        c.Deals_Accepted__c=0;
        c.Deals_Rejected__c=0;
        
        
    }
    upsert clist;
}