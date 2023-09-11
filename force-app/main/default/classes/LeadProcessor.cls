global class LeadProcessor implements Database.Batchable<sObject>{

    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator('SELECT ID,LeadSource FROM Lead');
    }
    
    
     global void execute(Database.BatchableContext bc, List<Lead> lst)
         {
             List<Lead> ulist=new List<Lead>();
             for(Lead l:lst)
                 {
                     l.LeadSource='Dreamforce';
                     ulist.add(l);
                 }
             update ulist;
         }
    
    
    global void finish(Database.BatchableContext bc){}
}