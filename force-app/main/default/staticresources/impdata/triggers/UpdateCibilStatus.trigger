/** 

* File Name: UpdateCibilStatus

* Description: This trigger is used to update

* UpdateCibilStatus on loan

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   19-Feb-10  Raji Created 
*/ 

trigger UpdateCibilStatus on Applicant__c (after update) {


       
system.debug(' old flow');
 //Added by mahima to restric integration user access- start--
    ID Pid=Userinfo.getProfileID();
    string Ids= Label.dedupe_App_restrictedUserId;
    //List<string> restrictedIds= new list<string>();
    set<string> restrictedIdsSet= new set<string>();
    if( ids!=null)
    {
        restrictedIdsSet.addAll(Ids.split(','));
    }
    if( !restrictedIdsSet.contains(Pid))
    {
      //Added by mahima to restric integration user access- end--  
    if(!ControlRecursiveCallofTrigger_Util.hasUpdatecibilstatus()){
     ControlRecursiveCallofTrigger_Util.setUpdatecibilstatus();
    List <Opportunity> opp= new List<Opportunity>();
    List <Applicant__C> apps= new List<Applicant__C>();
    List <Id> oppId= new List<Id>();
    Id LoanId;
    integer count=0;
    integer flag1=0;
    decimal flag=0;
    
     map<id,Opportunity>  oppmap=new map<id,Opportunity>();
   // boolean updateOpp=false;
     List <Opportunity> oppTemp= new List<Opportunity>();
    map<id,Opportunity>  oppmapTemp=new map<id,Opportunity>();
     list<Opportunity> oppListForUpdate= new List<Opportunity>();
     set<Opportunity> oppsetForUpdate= new set<Opportunity>();
    for(Applicant__c app: trigger.new){
     flag1=0;
        for(integer n=0;n<oppId.size();n++){
            if(oppId[n]==app.Loan_Application__c)
            flag1=1;
        }
        if(flag1==0 && app.Loan_Application__c != null) { // added null check to resolve production issue - 7981
            system.debug('app.Loan_Application__c --> ' + app.Loan_Application__c);
            OppId.add(app.Loan_Application__c);
        }     
        
  } // end of for
     
    for(Id oppTempid : OppId){
      system.debug('Opportunity id --> ' + oppTempid);
    } 
    
    //getting oppty and applicant data 
    //7981
    //harsit----optimization START  
        //retreiving applist from opportunity related list
    if(OppId!=null && !OppId.isEmpty())   {
            opp=[Select Id,(select Id,Update_CIBIL_Error__c,Contact_Name__r.Customer_Type__c,Loan_Application__c from Loan_Application__r where  Contact_Name__r.Customer_Type__c='Individual'),
                Cibil_Status__c,FlagChecklist__C from Opportunity
          where Id in :OppId LIMIT :(Limits.getLimitQueryRows()- Limits.getQueryRows())];        
       
        oppTemp.addall(opp);
      }
     for(Opportunity ops:oppTemp){
     
        oppmapTemp.put(ops.id,ops);
        if(!CommonUtility.isEmpty(ops.Loan_Application__r)){
            apps.addAll(ops.Loan_Application__r);
        }

     } 
          
      /*try{ 
      //7981
          if(OppId!=null && !OppId.isEmpty())
          {
              
                    apps=[ Select Id,Update_CIBIL_Error__c,Loan_Application__c from Applicant__C 
                    where  Contact_Name__r.Customer_Type__c='Individual' 
                   and Loan_Application__c in :OppId LIMIT :(Limits.getLimitQueryRows()- Limits.getQueryRows())];
               
                
      }
      }
      catch(Exception e){}*/
      //harsit----optimization END
if(apps.size()>0){  
  for(integer i=0;i<opp.size();i++){   
        flag=0;
        count=0;
    for(integer k=0;k<apps.size();k++){   
      if(opp[i].Id==apps[k].Loan_Application__c && apps[k].Update_CIBIL_Error__c==true){            
           count=count+1;
      }
   }// end of for
    if(count>0){
     opp[i].Cibil_Status__c=true;}
    else{
    opp[i].Cibil_Status__c=false;}
                if(opp[i].FlagChecklist__C >=0 || opp[i].FlagChecklist__C<0)
                opp[i].FlagChecklist__C=opp[i].FlagChecklist__C+1;
                else
                opp[i].FlagChecklist__C=flag+1;
                
                
      oppmap.put(opp[i].id,opp[i]);          
                
   }// end of for
          
   
     if(oppTemp.size()>0 && opp.size()>0){
      
            for(Opportunity  opcompare : opp){
            
               if(oppmap.get(opcompare.id)!=null && oppmapTemp.get(opcompare.id)!=null){
                   if(oppmap.get(opcompare.id).Cibil_Status__c !=oppmapTemp.get(opcompare.id).Cibil_Status__c){
                     oppsetForUpdate.add(opcompare);
                   
                   }
                  if(oppmap.get(opcompare.id).FlagChecklist__C !=oppmapTemp.get(opcompare.id).FlagChecklist__C){
                   
                   oppsetForUpdate.add(opcompare);
                   }  
                                                                     
               }
              
            }
     
     }
    if(oppsetForUpdate.size()>0){
      for(Opportunity opset:oppsetForUpdate){
        oppListForUpdate.add(opset);
      }
    
    }
    
     
   if(oppListForUpdate.size()>0){
     update oppListForUpdate;
   }  
    //update opp;    
    }// end of if
   }
  }//end of crt
  
}//end of trigger