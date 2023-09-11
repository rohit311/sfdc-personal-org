trigger CCLeadToSalariedLoan on CCLeadSalaried__c (after insert,after update) {
    CCLeadToSalaried ccLeadObj;
     Opportunity Loan1;
     List<Opportunity> loanList = new List<Opportunity>();
 //cclead-salaried changes
 if(trigger.isAfter && trigger.isinsert)
    {  
      for(CCLeadSalaried__c sal : Trigger.New)
      { 
          List<CCLeadSalaried__c> ccSalList = Trigger.New;  
             system.debug('*********newSalList****::'+ccSalList);  
            if(sal.ReadyForCPA__c!=true){ 
                ccLeadObj = new CCLeadToSalaried();    
                ccLeadObj.salariedToLoanCreation(ccSalList);           
        
            }  
      }     
    
   } 
   if(trigger.isAfter && trigger.isupdate){
     for(CCLeadSalaried__c sal1 : Trigger.New)
      { 
            system.debug('*********sal***::'+sal1);     
              String City;
            if(sal1.ReadyForCPA__c==true){ 
                  //send to CPA queue           
                 system.debug('*********sal1***::'+sal1.Opportunity__c); 
                             
                     loanList = [select id,ownerId,Branch_Name__r.Name from Opportunity where id=:sal1.Opportunity__c];    
                     if(loanList != null && loanList.size() > 0){
                           Loan1 =  loanList[0];
                           system.debug('*********Loan1***::'+Loan1.OwnerId);  
                            Loan1.StageName ='Pending CPA Acceptance';   
                            Loan1.Approver__c='CPA Login Partner';  
                            List<User> userObj = [select id,Product__c,Branch_City__c,Mobile_number__c ,Profile.Name from User where profile.Name = 'CPA Login Partner' and IsActive=true ]; 
                           System.debug('*********userObj::'+userObj);   
                           if(userObj!=null && userObj.size()>0){    
                                for(User user:userObj){
                                    System.debug('******Loan1.Branch_Name__r.Name:'+Loan1.Branch_Name__r.Name);
                                    System.debug('**********Product__c::'+user.Product__c+'user.Branch_City__c***'+user.Branch_City__c);    
                                        if(user.Product__c !=null){
                                            if((user.Product__c.toUpperCase().contains('SPL'))){
                                                 if(Loan1.Branch_Name__r.Name!=null)
                                                    City = Loan1.Branch_Name__r.Name.toUpperCase();  
                                                 if(user.Branch_City__c !=null){
                                                         if((user.Branch_City__c.toUpperCase().contains(City))){   
                                                               System.debug('**********match found for this user::'+user);     
                                                               Loan1.OwnerId = user.id;  
                                                               Loan1.CPA__c = user.id;    
                                                           }
                                                  }
                                             }
                                              if((user.Product__c.toUpperCase().contains('SBS CS SAL'))){
                                                 if(Loan1.Branch_Name__r.Name!=null)
                                                    City = Loan1.Branch_Name__r.Name.toUpperCase();  
                                                 if(user.Branch_City__c !=null){
                                                         if((user.Branch_City__c.toUpperCase().contains(City))){   
                                                               System.debug('**********match found for this user::'+user);     
                                                               Loan1.OwnerId = user.id;  
                                                               Loan1.CPA__c = user.id;    
                                                           }
                                                  }
                                             }    
                                        }                                
                                }
                                 
                            }
                          update Loan1;
                    }     
                                 
            }else{
                  
                     List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>(
                    [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection
                        where ConnectionStatus = 'Accepted' and id = 'id=04P90000000HVvR']      );  
                    system.debug('*****connMap******'+connMap);  
                    if(connMap !=null && connMap.size()>0)  {     
                    for(PartnerNetworkConnection network : connMap) {          
                      
                        PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();        
                        newrecord.ConnectionId = network.Id;
                        newrecord.LocalRecordId = sal1.id;  // current cc_Lead record id  
                        system.debug('*****newrecord******'+newrecord);     
                         insert newrecord;     
                     }  
                     }
            }
      }      
   
      
   }
      
      
}