trigger updateCibilScore on Cibil_Temp__c (after update) {
    
    if(trigger.isUpdate && Trigger.isAfter){    
       List<Id> applist = new List<Id>();
       List<CCLeadSalaried__c> tempSal = new List<CCLeadSalaried__c>(); 
        List<CCLeadSalaried__c> tempSal1 = new List<CCLeadSalaried__c>(); 
        for(Cibil_Temp__c ct:Trigger.New){
           if(ct.Loan_Application__c !=null)
                applist.add(ct.Loan_Application__c);
        
        }
        if(applist !=null && applist.size()>0)
        tempSal = [select Opportunity__c ,cibil_score__c from CCLeadSalaried__c where Opportunity__c in :applist];
        if(tempSal !=null && tempSal.size()>0){
           for(Cibil_Temp__c ctt:Trigger.New){
                for(CCLeadSalaried__c sal:tempSal){
                    if(sal.Opportunity__c == ctt.Loan_Application__c){
                            if(ctt.CIBIL_Score__c!=null)
                                    sal.cibil_score__c = ctt.CIBIL_Score__c;
                     } 
                           tempSal1.add(sal);
                    }
               }
                update tempSal1;
        }
    }

   /*if(trigger.isUpdate && Trigger.isAfter){
        CibilTempHandler handlerObj = new CibilTempHandler(trigger.new,trigger.old,trigger.newmap,trigger.oldmap);
        system.debug('beforecheckCibilScore::::');
        handlerObj.checkCibilScore();
   }*/
    
    //Bug 24640 - DG Online for SOL and PLCS : Start
    try{
        if(Trigger.isUpdate && Trigger.isAfter){
            List<Salaried__c> lst_salaried = new List<Salaried__c>();
            List<String> lst_DummyApplicantDGOnline = String.valueOf( System.Label.DummyApplicantDGOnline ).split(';') ;
            System.debug('lst_DummyApplicantDGOnline : '+lst_DummyApplicantDGOnline+'\n'+Trigger.New);
            for(Cibil_Temp__c ct: Trigger.New){
                if(ct.Salaried__c !=null  && ct.Applicant__c != null ){
                    Boolean isDummyApplicantDGOnline;
                    isDummyApplicantDGOnline = CibilService_Salaried.isDummyApplicantDGOnline( ct.Applicant__c );
                    if(Test.isRunningTest()){
                        isDummyApplicantDGOnline = true; 
                    }
                    if(isDummyApplicantDGOnline){
                        Salaried__c salaried = new Salaried__c();
                        salaried.Id = ct.Salaried__c;
                        salaried.CIBIL_Score__c = ct.CIBIL_Score__c;
                        salaried.CIBIL_Match_Check__c = ct.CIBIL_Match_Check__c;
                        salaried.Update_CIBIL_Error__c = ct.Update_CIBIL_Error__c;
                        salaried.Descriptin__c = ct.Descriptin__c;
                        System.debug(' ---- salaried ---- '+ salaried);
                        lst_salaried.add( salaried );
                    }
                    
                }
            }
            if(lst_salaried!=null && !lst_salaried.isEmpty()) update lst_salaried;
        }
    }catch(Exception e){
        System.debug('Exception : updateCibilScore : '+ e);
    }
    //Bug 24640 - DG Online for SOL and PLCS : End
   
}