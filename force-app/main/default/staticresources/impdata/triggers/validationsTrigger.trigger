trigger validationsTrigger on Property_Price_Index__c (before insert,before update) {

List<Id> PPIRecordsId= new list<id>();
List<Property_Price_Index__c> PPIRecords = new List<Property_Price_Index__c>();
Set<Id> AreaMasterRecordsId= new Set<id>();

integer countPrimary = 0;
boolean inInsert=false;

for(Property_price_index__c p:trigger.new){
    PPIRecordsId.add(p.id);
    AreaMasterRecordsId.add(p.Area_Locality__c);
    
}



for(Property_price_index__c p: [select id,name,Area_Locality__c,Primary_partner_value__c,From_Date__c,Till_Date__c,Partner_Name__c,Project_Name__c   from Property_price_index__c where Area_Locality__c IN :AreaMasterRecordsId]){ 
        PPIRecords.add(p);
      
    }

for(Property_price_index__c p:trigger.new){
    
    countPrimary=0;
    Boolean isAlreadyPrimary = false;
   if(p.Primary_partner_value__c==true ){
       countPrimary++; 
       isAlreadyPrimary =true;
       
   }
              
   for(Property_price_index__c ppi:PPIRecords) {
       
           if(p.Area_Locality__c == ppi.Area_Locality__c){
               if(trigger.isInsert)
                   if(((p.From_Date__c >= ppi.From_Date__c && p.From_Date__c <=ppi.Till_Date__c)||(p.Till_Date__c >= ppi.From_Date__c && p.From_Date__c <=ppi.Till_Date__c)) &&  ppi.Primary_partner_value__c==true )
                      countPrimary++; 
               if(trigger.isUpdate)
                  if(((p.From_Date__c >= ppi.From_Date__c && p.From_Date__c <=ppi.Till_Date__c)||(p.Till_Date__c >= ppi.From_Date__c && p.From_Date__c <=ppi.Till_Date__c)) &&  ppi.Primary_partner_value__c==true && p.id!=ppi.id)
                      countPrimary++;
                 
           }
           if(p.Area_Locality__c == ppi.Area_Locality__c){ 
               if(p.Partner_Name__c==ppi.Partner_Name__c){
                   if(p.From_Date__c==ppi.From_Date__c){
                       if((p.id==null)||(p.id!=null && p.id!=ppi.id))
                           p.addError('you cannot have 2 records of same (from) date for a single partner');
                   
                   }     
               }
           }
           if(p.Area_Locality__c == ppi.Area_Locality__c){
               if(p.Partner_Name__c==ppi.Partner_Name__c){
                   if(p.Till_Date__c==ppi.Till_Date__c){
                       if((p.id==null)||(p.id!=null && p.id!=ppi.id))
                           p.addError('you cannot have 2 records of same (till) date for a single partner');
                   
                   }     
               }
           }
		   
		   // Start of PPI v2 changes	
           if(p.Area_Locality__c == ppi.Area_Locality__c){ 
               if(p.Partner_Name__c==ppi.Partner_Name__c){
                   if(p.Project_Name__c==ppi.Project_Name__c){
                       if((p.id==null)||(p.id!=null && p.id!=ppi.id && p.Project_Name__c!= null))
                           p.addError('You cannot have 2 records of same project for a single partner');
                           
                   }     
               }
           }
		   // End of PPI v2 changes 
           
       }
       
       if(countPrimary>1)
           p.addError('You cannot have multiple primary partners for a single area');
   
  
}


}