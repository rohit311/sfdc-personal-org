trigger ConvertToSegmentMaster on MCP_Parameter_Master__c (After update) {
System.Savepoint sp = Database.setSavepoint();
try{
   
    List<Segment_Master__c> objList = new List<Segment_Master__c>();
    List<QueueSobject> rmQueue = [SELECT Queue.Name, QueueId from QueueSobject where Queue.Name = 'Risk Manager Queue' limit 1];
     system.debug('rmQueue>>'+rmQueue[0].QueueId);
     
     for(MCP_Parameter_Master__c obj : Trigger.new){
         if(obj.approved_by_RM__c == true && obj.Accepted__c == true && obj.approved_by_RM__c != Trigger.oldMap.get(obj.Id).approved_by_RM__c){
                system.debug('obj>>'+obj);
                Segment_Master__c smObj = new Segment_Master__c();
                smObj.Name = obj.Company_Name__c;
                smObj.Company_Name__c= obj.Company_Name__c; 
                smObj.Group_Company_Listed__c = obj.Group_Company_Listed__c;
                smObj.MNC__c = obj.MNC__c;
                smObj.Company_Category__c = obj.Company_Category__c;
                smObj.Company_website__c = obj.Company_website__c; 
                smObj.Company_Listing_Request__c = obj.Company_Listing_Request__c;
                smObj.sector__c= obj.sector__c;
                smObj.Active_Flag__c = true; 
                smObj.Parameter_fields__c = 'Employer';     
               // smObj.CA_NUMBER__c = '10'; 
               // smObj.First_Name__c = 'test';
             //   smObj.City__c = 'pune';
             //   smObj.State__c = 'maharashtra';
                smObj.Business_Summary__c = obj.Business_Summary__c;
                smObj.Major_Clients__c = obj.Major_Clients__c;
                smObj.Overall_Existence_of_the_Company__c = obj.Overall_Existence_of_the_Company__c;
                smObj.Presence_in_India_since__c = obj.Presence_in_India_since__c;
                smObj.Company_turnover_Internationally_in_Cr__c = obj.Company_turnover_Internationally_in_Cr__c;
                smObj.Profits_Internationally_in_Rs_Cr__c = obj.Profits_Internationally_in_Rs_Cr__c;
                smObj.Turnover_in_India_in_Rs_Cr__c = obj.Turnover_in_India_in_Rs_Cr__c;
                smObj.Profit_in_India_in_Rs_Cr_Last_2years__c = obj.Profit_in_India_in_Rs_Cr_Last_2years__c;
                smObj.Overall_number_of_Employees__c = obj.Overall_number_of_Employees__c;
                smObj.No_of_Employees_in_India__c = obj.No_of_Employees_in_India__c;
                smObj.No_of_Employees_working_in_Office__c = obj.No_of_Employees_working_in_Office__c;
                smObj.Company_Setup__c = obj.Company_Setup__c;
                smObj.Company_website_address__c = obj.Company_website_address__c;
                smObj.Recommened_For_Listing__c = obj.Recommened_For_Listing__c;
                smObj.Accepted__c = obj.Accepted__c;
                if(rmQueue.size() >0 &&  rmQueue[0].QueueId != null){
                    smObj.OwnerId = rmQueue[0].QueueId;
                    if(Schema.SObjectType.Segment_Master__c.getRecordTypeInfosByName().get('Risk Manager Layout') != null){
                        Id devRecordTypeId = Schema.SObjectType.Segment_Master__c.getRecordTypeInfosByName().get('Risk Manager Layout').getRecordTypeId();
                        smObj.recordTypeId = devRecordTypeId;
                     }
                }
                objList.add(smObj);
            }
      }
     
      if(objList.size() >0){
        insert objList;
        List<Attachment> attachments = [ select Id, Name, Description,body from Attachment where ParentId in :Trigger.new order by Name];
        if(attachments.size()>0){
            List<Attachment> newAttchments = new List<Attachment>();
            for(Segment_Master__c smObj:objList){
                system.debug('smObj>>'+smObj.Id);
                for(Attachment atObj:attachments){
                    Attachment newAttch = atObj.clone();
                    newAttch.ParentId = smObj.Id;
                    newAttchments.add(newAttch);
                }
            }
            if(newAttchments.size() > 0){
                delete attachments;
                insert newAttchments;
            }
                
        }
        delete [select id from MCP_Parameter_Master__c  where id in :Trigger.new];
      //  Trigger.new[0].addError('record inserted into Segment Master with Active Status');
       // PageReference ref = new PageReference('/apex/DisplayListViewPage');
         //ref.setRedirect(true);
        // return ref;
        CompanyListingController bac1 = new CompanyListingController();
        bac1.abc();
      }
      
   }
  catch(Exception e){
       system.debug('exception>>'+e);
       Database.rollback(sp); 
      
  }   
      
}