trigger CategoryofScoringModule on Builder_Maintainance__c (before insert,before update,after insert,after update) {
    if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)){
        List<Builder_Maintainance__c > BMList=new List<Builder_Maintainance__c >();
        
        for (Builder_Maintainance__c a : Trigger.new) {
            system.debug('====>');
            
            //by praveen for changing T2 catgeory through workflow
            // if(a.Total_Score_with_weightage__c>=8){
            //    a.Developer_and_Project_category__c='A+';
            //   system.debug('====>A+');
            // }
            // else{
            //         if(a.Total_Score_with_weightage__c>=7 && a.Total_Score_with_weightage__c<7.99){
            //            a.Developer_and_Project_category__c='A';
            //            system.debug('====>A');
            //         }else if(a.Total_Score_with_weightage__c<7){
            //               a.Developer_and_Project_category__c='Reject';
            //               system.debug('====>B');
            //            }
            
            
            // }
            BMList.add(a);
            
            
            
        }
    }
    
    if((Trigger.isAfter && Trigger.isInsert) || (Trigger.isAfter && Trigger.isUpdate)){
        if (Trigger.isInsert) {
            for (Builder_Maintainance__c a : Trigger.new) {
                if(a.Developer_and_Project_category__c != 'Reject' && a.tier__c==2){
                    Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                    app.setObjectId(a.id);
                    system.debug('====>cat '+a.Developer_and_Project_category__c +app );
                    if(!system.test.isRunningTest())
                        Approval.ProcessResult result = Approval.process(app);
                }
               /* System.debug('LF_Magnitude_Analysis_weightage__c::::'+a.LF_Magnitude_Analysis_weightage__c);
                System.debug('LF_Score_Years_of_Experience_c__c::::'+a.LF_Score_Years_of_Experience_c__c);
                System.debug('LF_Score_Association_with_HL_Players_c__c::::'+a.LF_Score_Association_with_HL_Players_c__c);
                System.debug('LF_No_of_Projects_Launched_since_2009__c::::'+a.LF_No_of_Projects_Launched_since_2009__c);
                System.debug('No_of_Projects_Launched_since_weightage__c'+a.No_of_Projects_Launched_since_weightage__c);
                System.debug('a.LF_Developer_category__c:::'+a.LF_Developer_category__c);
                System.debug('a.tier__c'+a.tier__c);*/
                if(a.LF_Developer_category__c != 'Reject' && a.tier__c==1){
                    Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                    app.setObjectId(a.id);
                    system.debug('====>cat '+a.LF_Developer_category__c +app );
                    if(!system.test.isRunningTest())
                        Approval.ProcessResult result = Approval.process(app);
                }    
            }
        }
        else{
            
            for (Builder_Maintainance__c a : Trigger.new) {
                System.debug(' a.Developer_and_Project_category__c '+a.Developer_and_Project_category__c+' '+ a.tier__c);
                if(a.Developer_and_Project_category__c != 'Reject' && a.tier__c==2){
                    if(Trigger.oldMap.get(a.ID)!= null){
                        Builder_Maintainance__c oldCase = Trigger.oldMap.get(a.ID);
                        if (a.Developer_and_Project_category__c != oldCase.Developer_and_Project_category__c || a.Developer_and_Project_category__c=='') {
                            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                            app.setObjectId(a.id);
                            system.debug('====>cat '+a.Developer_and_Project_category__c + oldCase.Developer_and_Project_category__c+app );
                            if(!system.test.isRunningTest())
                                Approval.ProcessResult result = Approval.process(app);
                        }
                    }
                }
                if(a.LF_Developer_category__c != 'Reject' && a.tier__c==1){
                    if(Trigger.oldMap.get(a.ID)!= null){
                        Builder_Maintainance__c oldCase = Trigger.oldMap.get(a.ID);
                        if (a.LF_Developer_category__c != oldCase.LF_Developer_category__c || a.LF_Developer_category__c=='') {
                            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                            app.setObjectId(a.id);
                            system.debug('====>cat '+a.LF_Developer_category__c + oldCase.LF_Developer_category__c+app );
                            if(!system.test.isRunningTest())
                                Approval.ProcessResult result = Approval.process(app);
                        }
                    }
                }
                /*else{
List<ProcessInstance> app=[SELECT Id,Status,createddate,(SELECT Id,CreatedDate, StepStatus,Comments FROM StepsAndWorkitems)
FROM ProcessInstance where TargetObjectId=:a.id ORDER BY createdDate DESC];
system.debug('====>'+app);
for(ProcessInstance ab:app){
system.debug('====>'+ab.createddate);
}
}*/
            }
        }
    }   
}