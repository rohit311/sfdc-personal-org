trigger CL_UpdatePlbsSummary on CL_PL_BS__c (after insert,after update) {
    List<CL_PL_BS__c> clist = new List<CL_PL_BS__c>();
    Set<Id> oppIds = new Set<Id>();
    for(CL_PL_BS__c c: Trigger.new){
        
        //System.debug('c.applicant__r.Consider_for_Eligibility__c$$ '+c.applicant__r.Consider_for_Eligibility__c); 
        //System.debug('c.applicant__r.name'+c.applicant__c);
        if(c.Type__c !='Summary'){
            oppIds.add(c.Loan_App__c);
            //clist.add(c);
        }    
    }
    
    clist = [select Applicant__c,Loan_App__c,Type__c from CL_PL_BS__c where Loan_App__c in:oppIds
            and Type__c !='Summary'];
    if(clist.size()>0)
        CL_FATDetails.updatePLBSSummary(clist);
}