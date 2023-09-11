trigger StampingofEmailsonPDD on Personal_Discussion_Details__c (before insert) {
    Set<ID>OppID = new Set<ID>();
    string schemename;
    string productype;
    public list<Opportunity> oppList= new List<Opportunity>();
    if (!ControlRecursiveCallofTrigger_Util.hasStampingofEmailsonPDD()) {
         ControlRecursiveCallofTrigger_Util.setStampingofEmailsonPDD();
    for(Personal_Discussion_Details__c PDD : Trigger.New){    
        if(PDD.Loan_Application__c!=null && PDD.PDD_Type__c == 'LRD Details'){
            OppID.add(PDD.Loan_Application__c);
         }
    }
    if(OppID!=null){
        oppList = [select Product__c,Scheme_Master__c,ACM__r.Email,Area_SM__r.Email,Regional_SM__r.Email,RCM__r.Email,Zonal_SM__r.Email,CEO__r.Email,National_SM__r.Email from Opportunity where id in: OppID];
        system.debug('oppList-------------->'+oppList);
         if(oppList.size()>0){
             for(Opportunity oppObj :oppList){
                 schemename = oppObj.Scheme_Master__c;
                 productype = oppObj.Product__c;
             }
         }
    }
    if(schemename!=null && productype!=null){
     if(schemename.contains('LRD') && (productype == 'LAP' || productype == 'Home Laon')){
         if(trigger.isInsert && trigger.isBefore ){
            for(Personal_Discussion_Details__c pddObj : Trigger.new){
                   //if(pddObj.ASM_Email_ID__c!=null 
               
               if(oppList.size()>0){
                    system.debug('oppList-------------->'+oppList);
                    for(integer i=0;i<oppList.size();i++){
                        
                        if(pddObj.ACM_Email_ID__c==null){
                            
                            pddObj.ACM_Email_ID__c = oppList[i]. ACM__r.Email;
                                
                        }
                        if(pddObj.ASM_Email_ID__c==null){
                            
                            pddObj.ASM_Email_ID__c = oppList[i].Area_SM__r.Email;
                                
                        }   
                        
                        if(pddObj.NSM_Email_ID__c==null){
                            
                            pddObj.NSM_Email_ID__c = oppList[i].National_SM__r.Email;
                                
                        }
                        if(pddObj.RCM_Email_ID__c==null){
                            
                            pddObj.RCM_Email_ID__c = oppList[i].RCM__r.Email;
                                
                        }   
                        if(pddObj.RSM_Email_ID__c==null){
                            
                            pddObj.RSM_Email_ID__c = oppList[i].Regional_SM__r.Email;
                                
                        }
                        if(pddObj.ZCM_Email_ID__c==null){
                            
                            pddObj.ZCM_Email_ID__c = oppList[i].CEO__r.Email;
                                
                        }
                        if(pddObj.ZSM_Email_ID__c==null){
                            
                            pddObj.ZSM_Email_ID__c = oppList[i].Zonal_SM__r.Email;
                                
                        }   
                            
                        }
                }     
            }
         }
     }
    }
    }
}