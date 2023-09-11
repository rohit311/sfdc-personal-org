trigger ContactTrigger on Contact (after insert, after update, before insert, before update){

    system.debug('inside contact trigger'+ Trigger.isAfter+ 'update' + Trigger.isUpdate);
    if(Trigger.isUpdate && Trigger.isAfter) {
        ContactTriggerHandler obj = new ContactTriggerHandler(trigger.new,trigger.old);
        obj.fraudValidateMethod(trigger.oldmap,trigger.newmap);
    }
    if (!ControlRecursiveCallofTrigger_Util.hascontactTriggerFlag()) {
            ControlRecursiveCallofTrigger_Util.setcontactTriggerFlag();
            ContactTriggerHandler obj = new ContactTriggerHandler(trigger.new,trigger.old); //changed signature 20939
            system.debug('condition here is'+Trigger.isUpdate+'------'+Trigger.isAfter);
            if(Trigger.isUpdate && Trigger.isAfter) 
                obj.checkMCP();
            if(Trigger.isUpdate && Trigger.isBefore) 
                obj.fraudDATAcheck(Trigger.isupdate, Trigger.isinsert, Trigger.oldmap, Trigger.newmap);        
            if((Trigger.isUpdate && Trigger.isBefore) || (Trigger.isInsert && Trigger.isBefore)) obj.copyMobile();    
            if((Trigger.isUpdate && Trigger.isAfter) || (Trigger.isInsert && Trigger.isAfter)) obj.DNCReport(Trigger.isupdate, Trigger.isinsert,Trigger.oldmap, Trigger.newmap);
 
     // bug 15927 start
     if(!(Trigger.isBefore && Trigger.isInsert)){
          Set<ID> ids = new Set<ID>();
             for(Contact con: Trigger.new){
                 ids.add(con.id);
             }
              List<ID> pdID=new List<ID>();
             Applicant__c app = new Applicant__c();
             List<Applicant__c> appList = new LIst<Applicant__c>();
            if(ids!=null && ids.size()>0 && ContactTriggerHandler.isFirstTime){
                               ContactTriggerHandler.isFirstTime = false;
             appList = [select id,Name,Contact_Name__r.Date_of_Birth__c ,Loan_Application__c from Applicant__c where Contact_Name__c in :ids and Applicant_Type__c='Primary' limit 1];
             }
             system.debug('applist'+appList);
            if(appList!=null && appList.size()>0){
                 app = appList[0];
                 List<Property_Details__c> propList = new  List<Property_Details__c>();
                 if(app.Loan_Application__c!=null)
                 propList =[SELECT id, name,Top_Up_Percentage__c,Construction_Rate_As_per_Valuer_1__c,Construction_Area_Val1__c, Amount_fund_property__c, Digital_Scrip_market_price__c, Number_of_Shares__c, Contribution__c/* bug 15927 s*/,Property_Age__c,Construction_Area_SBU__c,Total_valuation_As_per_PE_PPIV2__c,
        Property_Land_Area_In_Sq_Ft__c,Avg_Property_price__c,Nature_of_property__c,Property_Type__c,Stage_of_Construction__c,Developer_Name__c,Property_City__c,Approach_Road_Mortgage__c,Top_floor_property__c,Separate_Access_to_the_property__c,Property_Status__c,No_of_tenants_Relative__c,
Net_LTV1__c,Distance_Outside_Municipal_limits__c,Construction_Rate__c,Property_Usage__c,Developer_Name__r.Builder_Segmentation__c,Loan_Application__c,/* bug 16051 s*/ Total_Valuation_1__c,Top_Up__c,Seperate_access_to_the_property__c /* bug 16051 s*/ 
                  FROM Property_Details__c 
                  WHERE Loan_Application__c =: app.Loan_Application__c];
                  System.debug('Property List: '+propList);
                  if(propList!=null && propList.size()>0){
                  for(Property_Details__c  pd:propList){
                      pdID.add(pd.id);
                  }
                  }
                  System.debug('Prop ID: '+pdID);
                     
                   for(Contact con:trigger.new){
                       if(Trigger.oldMap != null){ 
                           Contact oldVal = Trigger.oldMap.get(con.id);
                           if(oldVal.Date_of_Birth__c != con.Date_of_Birth__c ){
                               if(pdID!=null)
                                 CallAutoDCM.AutoDCM(pdID);
                           }
                       }
                   }
            }  
      }
             // bug 15927 end
      
    }  
      // Bug Id : 16618 - NSDL PAN Check -- start
             System.debug('Starting Update_Contact_PAN method from trigger' + Trigger.isUpdate +'after -->'+ Trigger.isAfter); 
          if(Trigger.isUpdate && Trigger.isAfter) {
          ContactTriggerHandler obj = new ContactTriggerHandler(trigger.new,trigger.old); //20939 changed signature
          System.debug('inside if -->');
            obj.reTriggerBRE(); //Retrigger BRE 20939
          obj.Update_Contact_PAN(Trigger.oldmap, Trigger.new);
              System.debug('Finished Update_Contact_PAN method execution'); 
              }
        
            
        // Bug Id : 16618 - NSDL PAN Check -- end
        // 3493 start
    if(Trigger.isUpdate && Trigger.isBefore ){
        ContactTriggerHandler obj = new ContactTriggerHandler(trigger.new,trigger.old);
        obj.resetOtpOnOfficeEmailChange(trigger.newmap,trigger.oldmap);
    }     
    // 3493 end
}